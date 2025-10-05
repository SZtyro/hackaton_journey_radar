package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.service.GtfsRealTimeService;
import pl.drunkcom.core.service.SimpleVehiclePosition;

import java.io.IOException;
import java.util.List;

/**
 * REST API controller for accessing real-time vehicle position data from GTFS-RT feeds.
 * Provides endpoints for retrieving live positions of public transit vehicles
 * including buses, trams, and other transit vehicles in the Krakow area.
 *
 * <p>This controller interfaces with the GTFS Real-Time feed to provide:
 * <ul>
 *   <li>Current vehicle positions with coordinates</li>
 *   <li>Vehicle identifiers and associated trip information</li>
 *   <li>Real-time location data for transit monitoring</li>
 *   <li>Integration with incident reporting system</li>
 * </ul>
 *
 * <p>The data is sourced from Krakow's official GTFS-RT feed and updated
 * in real-time to provide accurate vehicle positioning information.
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see GtfsRealTimeService
 * @see SimpleVehiclePosition
 */
@RestController
@RequestMapping("/api/vehicles")
@CrossOrigin
@Tag(name = "Vehicle Positions", description = "Real-time vehicle position tracking API. Provides live location data for public transit vehicles including buses, trams, and other transit services in the Krakow metropolitan area.")
public class VehiclePositionController {

    private static final Logger log = LoggerFactory.getLogger(VehiclePositionController.class);

    @Autowired
    private GtfsRealTimeService gtfsRealTimeService;

    /**
     * Retrieves current positions of all active vehicles in the transit system.
     * Returns real-time location data including coordinates, vehicle IDs, and trip information.
     *
     * <p>This endpoint fetches data directly from the GTFS Real-Time feed provided by
     * Krakow's public transit authority. The data includes:
     * <ul>
     *   <li>Vehicle unique identifiers</li>
     *   <li>Current trip assignments</li>
     *   <li>GPS coordinates (latitude/longitude)</li>
     *   <li>Real-time positioning updates</li>
     * </ul>
     *
     * <p>The data is typically updated every 30-60 seconds and represents the most
     * current available position information for all active vehicles.
     *
     * @return ResponseEntity containing list of current vehicle positions
     */
    @GetMapping("/positions")
    @Operation(
        summary = "Get current vehicle positions",
        description = "Retrieves real-time positions of all active public transit vehicles. " +
                     "Data includes vehicle IDs, trip information, and GPS coordinates. " +
                     "Information is sourced directly from Krakow's official GTFS-RT feed " +
                     "and provides up-to-date location data for buses, trams, and other transit vehicles. " +
                     "This endpoint is essential for real-time transit monitoring, incident correlation, " +
                     "and passenger information systems."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved current vehicle positions",
            content = @Content(
                schema = @Schema(
                    type = "array",
                    example = """
                        [
                          {
                            "vehicleId": "1001",
                            "tripId": "trip_123",
                            "latitude": 50.0647,
                            "longitude": 19.9450
                          },
                          {
                            "vehicleId": "1002",
                            "tripId": "trip_124",
                            "latitude": 50.0619,
                            "longitude": 19.9368
                          }
                        ]
                        """
                )
            )
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch or parse GTFS-RT data"
        ),
        @ApiResponse(
            responseCode = "502",
            description = "Bad Gateway - upstream GTFS-RT feed is unavailable"
        ),
        @ApiResponse(
            responseCode = "503",
            description = "Service Unavailable - GTFS-RT feed temporarily unavailable"
        )
    })
    public ResponseEntity<List<SimpleVehiclePosition>> getVehiclePositions() {
        try {
            log.info("Fetching current vehicle positions");
            List<SimpleVehiclePosition> positions = gtfsRealTimeService.fetchVehiclePositions();

            log.info("Successfully retrieved {} vehicle positions", positions.size());
            return ResponseEntity.ok(positions);

        } catch (IOException e) {
            log.error("Failed to fetch vehicle positions due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching vehicle positions", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Gets the count of currently active vehicles in the system.
     * Provides a quick overview of fleet activity without returning full position data.
     *
     * @return ResponseEntity containing the number of active vehicles
     */
    @GetMapping("/count")
    @Operation(
        summary = "Get count of active vehicles",
        description = "Returns the total number of vehicles currently active and reporting positions. " +
                     "This is a lightweight endpoint that provides fleet activity overview " +
                     "without the overhead of returning full position data. " +
                     "Useful for monitoring system health and fleet utilization."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved vehicle count",
            content = @Content(schema = @Schema(type = "integer", example = "245"))
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch vehicle data"
        )
    })
    public ResponseEntity<Integer> getActiveVehicleCount() {
        try {
            log.info("Fetching active vehicle count");
            List<SimpleVehiclePosition> positions = gtfsRealTimeService.fetchVehiclePositions();
            int count = positions.size();

            log.info("Current active vehicle count: {}", count);
            return ResponseEntity.ok(count);

        } catch (IOException e) {
            log.error("Failed to fetch vehicle count due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching vehicle count", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Health check endpoint for the vehicle position service.
     * Verifies that the GTFS-RT feed is accessible and responding.
     *
     * @return ResponseEntity indicating service health status
     */
    @GetMapping("/health")
    @Operation(
        summary = "Check vehicle position service health",
        description = "Performs a health check on the vehicle position service by attempting " +
                     "to connect to the GTFS-RT feed. Returns service status and basic connectivity information. " +
                     "This endpoint can be used for monitoring and alerting purposes."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Service is healthy and GTFS-RT feed is accessible",
            content = @Content(schema = @Schema(type = "string", example = "OK - Service healthy"))
        ),
        @ApiResponse(
            responseCode = "503",
            description = "Service is unhealthy - GTFS-RT feed is not accessible"
        )
    })
    public ResponseEntity<String> checkHealth() {
        try {
            log.info("Performing health check on vehicle position service");
            List<SimpleVehiclePosition> positions = gtfsRealTimeService.fetchVehiclePositions();

            // If we can fetch data, service is healthy
            String healthMessage = String.format("OK - Service healthy, %d vehicles reporting", positions.size());
            log.info("Health check passed: {}", healthMessage);
            return ResponseEntity.ok(healthMessage);

        } catch (Exception e) {
            log.error("Health check failed", e);
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                    .body("Service unhealthy - " + e.getMessage());
        }
    }
}
