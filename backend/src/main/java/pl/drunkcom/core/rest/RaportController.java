package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.enums.Incidents;
import pl.drunkcom.core.model.Raport;
import pl.drunkcom.core.service.RaportService;

import javax.validation.Valid;
import java.sql.Timestamp;
import java.util.List;

/**
 * REST API controller for managing incident reports in the transit system.
 * Provides comprehensive endpoints for creating, reading, updating, and deleting incident reports
 * that affect public transportation routes and services.
 *
 * <p>This controller handles various types of transit incidents including:
 * <ul>
 *   <li>Service disruptions and delays</li>
 *   <li>Equipment failures and maintenance issues</li>
 *   <li>Weather-related incidents</li>
 *   <li>Emergency situations</li>
 *   <li>Construction and route changes</li>
 * </ul>
 *
 * <p>Key features:
 * <ul>
 *   <li>Standard CRUD operations with full validation</li>
 *   <li>Advanced filtering by incident type, route, and emergency status</li>
 *   <li>Time-based queries for historical analysis</li>
 *   <li>Emergency report management</li>
 *   <li>Statistical endpoints for reporting and analytics</li>
 *   <li>Pagination support for large datasets</li>
 * </ul>
 *
 * <p>All endpoints return standardized HTTP responses with appropriate status codes
 * and detailed error messages when applicable.
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see Raport
 * @see RaportService
 * @see Incidents
 */
@RestController
@RequestMapping("/api/reports")
@CrossOrigin
@Tag(name = "Reports", description = "Transit incident report management API. Handles creation, tracking, and management of transit service incidents, disruptions, and emergency situations affecting public transportation.")
public class RaportController extends BaseGtfsController<Raport, Long, RaportService> {

    /**
     * Retrieves reports filtered by incident type.
     * Returns all reports matching the specified incident type for analysis and monitoring.
     *
     * @param type The incident type to filter by
     * @return ResponseEntity containing list of reports matching the incident type
     */
    @GetMapping("/type/{type}")
    @Operation(
        summary = "Get reports by incident type",
        description = """
                Retrieves all incident reports filtered by the specified type. \
                Useful for analyzing patterns and frequency of specific incident types. \
                Returns comprehensive report details including location, timing, and associated routes.\
                Supports types such a:
                 ACCIDENT,
                    LANE_CLOSURE,
                    VEHICLE_BREAKDOWN,
                    COLLISION,
                    PEDESTRIAN_ACCIDENT,
                    OTHER,"""
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved reports for the specified incident type",
            content = @Content(schema = @Schema(implementation = Raport.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid incident type provided"
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error occurred while fetching reports"
        )
    })
    public ResponseEntity<List<Raport>> getReportsByType(
        @Parameter(description = "Type of incident to filter by", example = "SERVICE_DISRUPTION")
        @PathVariable Incidents type
    ) {
        List<Raport> reports = service.findByType(type);
        return ResponseEntity.ok(reports);
    }

    /**
     * Retrieves reports filtered by emergency status.
     * Returns all reports based on their emergency classification for priority handling.
     *
     * @param isEmergency True for emergency reports, false for regular reports
     * @return ResponseEntity containing list of reports filtered by emergency status
     */
    @GetMapping("/emergency/{isEmergency}")
    @Operation(
        summary = "Get reports by emergency status",
        description = "Retrieves incident reports filtered by emergency status. " +
                     "Emergency reports require immediate attention and priority handling. " +
                     "Use this endpoint to quickly identify and respond to critical situations."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved reports filtered by emergency status",
            content = @Content(schema = @Schema(implementation = Raport.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid emergency status parameter"
        )
    })
    public ResponseEntity<List<Raport>> getReportsByEmergencyStatus(
        @Parameter(description = "Emergency status filter - true for emergency reports, false for regular reports", example = "true")
        @PathVariable boolean isEmergency
    ) {
        List<Raport> reports = service.findByEmergencyStatus(isEmergency);
        return ResponseEntity.ok(reports);
    }

    /**
     * Retrieves all reports associated with a specific route.
     * Returns reports that affect or are related to the specified transit route.
     *
     * @param routeId The unique identifier of the route
     * @return ResponseEntity containing list of reports for the specified route
     */
    @GetMapping("/route/{routeId}")
    @Operation(
        summary = "Get reports by route",
        description = "Retrieves all incident reports associated with a specific transit route. " +
                     "This includes disruptions, delays, and other incidents that may affect service " +
                     "on the specified route. Essential for route-specific incident management."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved reports for the specified route",
            content = @Content(schema = @Schema(implementation = Raport.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Route with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid route ID format"
        )
    })
    public ResponseEntity<List<Raport>> getReportsByRoute(
        @Parameter(description = "Unique identifier of the transit route", example = "ROUTE_001")
        @PathVariable String routeId
    ) {
        List<Raport> reports = service.findByRouteId(routeId);
        return ResponseEntity.ok(reports);
    }

    /**
     * Retrieves reports within a specified time range.
     * Returns reports that occurred between the specified start and end timestamps.
     *
     * @param startTime Start of the time range (Unix timestamp in milliseconds)
     * @param endTime End of the time range (Unix timestamp in milliseconds)
     * @return ResponseEntity containing list of reports within the time range
     */
    @GetMapping("/timerange")
    @Operation(
        summary = "Get reports by time range",
        description = "Retrieves incident reports that occurred within a specified time period. " +
                     "Useful for historical analysis, trend identification, and generating time-based reports. " +
                     "Timestamps should be provided in Unix millisecond format."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved reports within the specified time range",
            content = @Content(schema = @Schema(implementation = Raport.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid timestamp format or end time before start time"
        )
    })
    public ResponseEntity<List<Raport>> getReportsByTimeRange(
        @Parameter(description = "Start timestamp in Unix milliseconds", example = "1672531200000")
        @RequestParam Long startTime,
        @Parameter(description = "End timestamp in Unix milliseconds", example = "1672617600000")
        @RequestParam Long endTime
    ) {
        if (endTime <= startTime) {
            return ResponseEntity.badRequest().build();
        }

        Timestamp start = new Timestamp(startTime);
        Timestamp end = new Timestamp(endTime);
        List<Raport> reports = service.findByTimeRange(start, end);
        return ResponseEntity.ok(reports);
    }

    /**
     * Retrieves recent reports from the last specified hours.
     * Convenience endpoint for getting recent incident activity.
     *
     * @param hours Number of hours to look back from current time
     * @return ResponseEntity containing list of recent reports
     */
    @GetMapping("/recent/{hours}")
    @Operation(
        summary = "Get recent reports",
        description = "Retrieves incident reports from the last specified number of hours. " +
                     "Convenient endpoint for monitoring recent incident activity and getting " +
                     "up-to-date information on current transit system status."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved recent reports",
            content = @Content(schema = @Schema(implementation = Raport.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid hours parameter (must be positive)"
        )
    })
    public ResponseEntity<List<Raport>> getRecentReports(
        @Parameter(description = "Number of hours to look back", example = "24")
        @PathVariable int hours
    ) {
        if (hours <= 0) {
            return ResponseEntity.badRequest().build();
        }

        List<Raport> reports = service.findRecentReports(hours);
        return ResponseEntity.ok(reports);
    }

    /**
     * Retrieves emergency reports for a specific route.
     * Returns emergency incidents that affect the specified route.
     *
     * @param routeId The unique identifier of the route
     * @return ResponseEntity containing list of emergency reports for the route
     */
    @GetMapping("/route/{routeId}/emergency")
    @Operation(
        summary = "Get emergency reports by route",
        description = "Retrieves emergency incident reports for a specific transit route. " +
                     "Critical for immediate response and priority handling of route-specific emergencies. " +
                     "Returns only reports marked as emergency situations."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved emergency reports for the route",
            content = @Content(schema = @Schema(implementation = Raport.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Route with specified ID not found"
        )
    })
    public ResponseEntity<List<Raport>> getEmergencyReportsByRoute(
        @Parameter(description = "Unique identifier of the transit route", example = "ROUTE_001")
        @PathVariable String routeId
    ) {
        List<Raport> reports = service.findByRouteAndEmergencyStatus(routeId, true);
        return ResponseEntity.ok(reports);
    }

    /**
     * Retrieves reports by incident type with pagination.
     * Returns paginated results for efficient handling of large datasets.
     *
     * @param type The incident type to filter by
     * @param pageable Pagination parameters
     * @return ResponseEntity containing paginated reports
     */
    @GetMapping("/type/{type}/page")
    @Operation(
        summary = "Get reports by type with pagination",
        description = "Retrieves incident reports filtered by type with pagination support. " +
                     "Efficient for handling large numbers of reports while maintaining performance. " +
                     "Includes pagination metadata for navigation."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved paginated reports by type",
            content = @Content(schema = @Schema(implementation = Page.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid incident type or pagination parameters"
        )
    })
    public ResponseEntity<Page<Raport>> getReportsByTypePaged(
        @Parameter(description = "Type of incident to filter by", example = "SERVICE_DISRUPTION")
        @PathVariable Incidents type,
        @Parameter(description = "Pagination parameters")
        Pageable pageable
    ) {
        Page<Raport> reports = service.findByType(type, pageable);
        return ResponseEntity.ok(reports);
    }

    /**
     * Gets count of reports by incident type.
     * Returns statistical information for reporting and analytics.
     *
     * @param type The incident type to count
     * @return ResponseEntity containing count of reports
     */
    @GetMapping("/count/type/{type}")
    @Operation(
        summary = "Count reports by incident type",
        description = "Returns the total number of reports for a specific incident type. " +
                     "Useful for statistical analysis, trend monitoring, and generating summary reports."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved report count",
            content = @Content(schema = @Schema(implementation = Long.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid incident type"
        )
    })
    public ResponseEntity<Long> countReportsByType(
        @Parameter(description = "Type of incident to count", example = "SERVICE_DISRUPTION")
        @PathVariable Incidents type
    ) {
        long count = service.countByType(type);
        return ResponseEntity.ok(count);
    }

    /**
     * Gets count of emergency reports.
     * Returns the total number of emergency reports for monitoring critical situations.
     *
     * @return ResponseEntity containing count of emergency reports
     */
    @GetMapping("/count/emergency")
    @Operation(
        summary = "Count emergency reports",
        description = "Returns the total number of reports marked as emergency situations. " +
                     "Critical metric for monitoring system-wide emergency incidents and response readiness."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved emergency report count",
            content = @Content(schema = @Schema(implementation = Long.class))
        )
    })
    public ResponseEntity<Long> countEmergencyReports() {
        long count = service.countByEmergencyStatus(true);
        return ResponseEntity.ok(count);
    }

    /**
     * Creates a new incident report.
     * Validates and saves a new report with automatic timestamp assignment.
     *
     * @param raport The report data to create
     * @return ResponseEntity containing the created report with generated ID
     */
    @Override
    @PostMapping
    @Operation(
        summary = "Create new incident report",
        description = "Creates a new incident report in the system. Automatically assigns current timestamp " +
                     "if not provided. Validates all required fields and ensures data integrity. " +
                     "Returns the created report with generated unique identifier."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "201",
            description = "Report created successfully",
            content = @Content(schema = @Schema(implementation = Raport.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid report data or validation errors"
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error during report creation"
        )
    })
    public ResponseEntity<Raport> create(
        @Parameter(description = "Report data to create", required = true)
        @Valid @RequestBody Raport raport
    ) {
        Raport savedRaport = service.save(raport);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedRaport);
    }
}
