// ignore_for_file: lines_longer_than_80_chars, avoid_dynamic_calls, strict_raw_type

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:journey_radar_mobile/config/logger.dart';
import 'package:journey_radar_mobile/generated/locale_keys.g.dart';

/// {@template ErrorInterceptor}
/// This interceptor handles errors coming from either the backend or the client.
/// {@endtemplate}
class ErrorInterceptor extends Interceptor {
  /// {@macro ErrorInterceptor}
  ErrorInterceptor();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    String errorMessage = LocaleKeys.failedConnectionWithServer.tr();

    /// Parses HTTP status codes and response bodies for error details.
    void handleBadResponse(Response? response) {
      if (response?.statusCode != null) {
        final statusCode = response!.statusCode!;

        // 2) If status >= 500 → standard server error
        if (statusCode >= HttpStatus.internalServerError) {
          final serverMsg = LocaleKeys.serverError.tr();
          logE('Dio Error: $serverMsg');
          final newError = DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            type: err.type,
            error: serverMsg,
          );
          handler.reject(newError);
          return;
        }

        // 3) Parse other error messages (Status.Body, message, etc.)
        final dynamic rawData = response.data;
        if (rawData == null) return;

        dynamic parsedData;
        if (rawData is Map<String, dynamic>) {
          parsedData = rawData;
        } else if (rawData is String) {
          try {
            parsedData = jsonDecode(rawData);
          } catch (_) {
            parsedData = rawData;
          }
        } else {
          parsedData = rawData.toString();
        }

        if (parsedData is Map<String, dynamic>) {
          errorMessage = parsedData['Status']?['Body']?.toString() ??
              parsedData['message']?.toString() ??
              errorMessage;
        } else {
          final message = parsedData.toString();
          if (message.isNotEmpty) errorMessage = message;
        }
      }
    }

    // Handle timeout and connection errors: show "no internet" message
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      errorMessage = LocaleKeys.noInternet.tr();
    }
    // Handle HTTP errors not caught by status-based parsing (e.g. 400–499)
    else if (err.type == DioExceptionType.badResponse) {
      if (err.response?.data != null) {
        final rawData = err.response!.data;
        if (rawData is Map<String, dynamic>) {
          try {
            errorMessage = rawData['Status']?['Body']?.toString() ??
                LocaleKeys.unexpectedError.tr();
          } catch (_) {
            errorMessage = LocaleKeys.unexpectedError.tr();
          }
        } else {
          final fallbackErrorMessage = rawData.toString();
          if (fallbackErrorMessage.isNotEmpty) {
            errorMessage = fallbackErrorMessage;
          } else {
            errorMessage = LocaleKeys.failedConnectionWithServer.tr();
          }
        }
      }
    }
    // Handle user-cancelled requests: propagate without modification
    else if (err.type == DioExceptionType.cancel) {
      handler.next(err);
      return;
    }
    // Handle unknown errors: could be socket or TLS exceptions, or fallback to status-based parsing
    else if (err.type == DioExceptionType.unknown) {
      switch (err.error.runtimeType) {
        case SocketException:
        case SignalException:
          errorMessage = LocaleKeys.noInternet.tr();
        case HttpException:
        case TlsException:
        case CertificateException:
        case HandshakeException:
        default:
          handleBadResponse(err.response);
          break;
      }
    }
    // Fallback for other DioException types: use status code handling
    else {
      handleBadResponse(err.response);
    }

    // Log the final error message for debugging purposes
    logE('Dio Error: $errorMessage');

    // Wrap any non-SubscriptionExpiredException error into a new DioException
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
    );

    handler.reject(newError);
  }
}
