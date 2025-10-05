package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
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
import pl.drunkcom.core.service.SimpleTripUpdate;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

/**
 * REST API controller for accessing real-time GTFS data including vehicle positions and trip updates.
 * Provides endpoints for retrieving live positions of public transit vehicles and real-time delay information
 * for buses, trams, and other transit vehicles in the Krakow area.
 *
 * <p>This controller interfaces with the GTFS Real-Time feed to provide:
 * <ul>
 *   <li>Current vehicle positions with coordinates</li>
 *   <li>Vehicle identifiers and associated trip information</li>
 *   <li>Real-time trip updates and delay information</li>
 *   <li>Bus delay monitoring and analysis</li>
 *   <li>Integration with incident reporting system</li>
 * </ul>
 *
 * <p>The data is sourced from Krakow's official GTFS-RT feed and updated
 * in real-time to provide accurate vehicle positioning and delay information.
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see GtfsRealTimeService
 * @see SimpleVehiclePosition
 * @see SimpleTripUpdate
 */
@RestController
@RequestMapping("/api/vehicles")
@CrossOrigin
@Tag(name = "Real-time Transit Data", description = "Real-time vehicle position tracking and trip update API. Provides live location data and delay information for public transit vehicles including buses, trams, and other transit services in the Krakow metropolitan area.")
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

    /**
     * Retrieves current trip updates including delay information for all active trips.
     * Returns real-time delay data for buses and other transit vehicles.
     *
     * <p>This endpoint fetches data directly from the GTFS Real-Time trip updates feed provided by
     * Krakow's public transit authority. The data includes:
     * <ul>
     *   <li>Trip identifiers and route information</li>
     *   <li>Delay information in seconds</li>
     *   <li>Schedule relationship status</li>
     *   <li>Associated vehicle identifiers (when available)</li>
     * </ul>
     *
     * <p>Positive delay values indicate the vehicle is running late, negative values indicate early arrival,
     * and zero indicates on-time performance.
     *
     * @return ResponseEntity containing list of current trip updates with delay information
     */
    @GetMapping("/trip-updates")
    @Operation(
        summary = "Get current trip updates and delays",
        description = "Retrieves real-time trip updates including delay information for all active public transit trips. " +
                     "Data includes trip IDs, route information, delay in seconds, and schedule relationship status. " +
                     "Information is sourced directly from Krakow's official GTFS-RT trip updates feed " +
                     "and provides up-to-date delay information for buses, trams, and other transit vehicles. " +
                     "This endpoint is essential for monitoring service performance and passenger information systems."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved current trip updates",
            content = @Content(
                schema = @Schema(
                    type = "array",
                    example = """
                        [
                          {
                            "tripId": "trip_123",
                            "routeId": "ROUTE_001",
                            "vehicleId": "1001",
                            "delay": 180,
                            "scheduleRelationship": "SCHEDULED"
                          },
                          {
                            "tripId": "trip_124",
                            "routeId": "ROUTE_002",
                            "vehicleId": "1002",
                            "delay": -60,
                            "scheduleRelationship": "SCHEDULED"
                          }
                        ]
                        """
                )
            )
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch or parse GTFS-RT trip updates data"
        ),
        @ApiResponse(
            responseCode = "502",
            description = "Bad Gateway - upstream GTFS-RT feed is unavailable"
        ),
        @ApiResponse(
            responseCode = "503",
            description = "Service Unavailable - GTFS-RT trip updates feed temporarily unavailable"
        )
    })
    public ResponseEntity<List<SimpleTripUpdate>> getTripUpdates() {
        try {
            log.info("Fetching current trip updates");
            List<SimpleTripUpdate> tripUpdates = gtfsRealTimeService.fetchTripUpdates();

            log.info("Successfully retrieved {} trip updates", tripUpdates.size());
            return ResponseEntity.ok(tripUpdates);

        } catch (IOException e) {
            log.error("Failed to fetch trip updates due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching trip updates", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Retrieves only significantly delayed trips (more than 5 minutes late).
     * Filters trip updates to show only those with substantial delays.
     *
     * @return ResponseEntity containing list of significantly delayed trips
     */
    @GetMapping("/delays")
    @Operation(
        summary = "Get significantly delayed trips",
        description = "Retrieves trip updates filtered to show only significantly delayed trips (more than 5 minutes late). " +
                     "This endpoint is useful for monitoring service disruptions and identifying problematic routes. " +
                     "Helps transit operators and passengers focus on the most impactful delays."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved delayed trips",
            content = @Content(schema = @Schema(implementation = SimpleTripUpdate.class))
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch trip updates"
        )
    })
    public ResponseEntity<List<SimpleTripUpdate>> getDelayedTrips() {
        try {
            log.info("Fetching significantly delayed trips");
            List<SimpleTripUpdate> allUpdates = gtfsRealTimeService.fetchTripUpdates();

            List<SimpleTripUpdate> delayedTrips = allUpdates.stream()
                    .filter(SimpleTripUpdate::isSignificantlyDelayed)
                    .collect(Collectors.toList());

            log.info("Found {} significantly delayed trips out of {} total", delayedTrips.size(), allUpdates.size());
            return ResponseEntity.ok(delayedTrips);

        } catch (IOException e) {
            log.error("Failed to fetch delayed trips due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching delayed trips", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Gets trip updates for a specific route.
     * Returns delay information filtered by route ID.
     *
     * @param routeId The route identifier to filter by
     * @return ResponseEntity containing trip updates for the specified route
     */
    @GetMapping("/trip-updates/route/{routeId}")
    @Operation(
        summary = "Get trip updates by route",
        description = "Retrieves trip updates filtered by a specific route ID. " +
                     "Useful for monitoring delays and performance on a particular transit route. " +
                     "Returns all trip updates (delayed and on-time) for the specified route."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved trip updates for the route",
            content = @Content(schema = @Schema(implementation = SimpleTripUpdate.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid route ID format"
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch trip updates"
        )
    })
    public ResponseEntity<List<SimpleTripUpdate>> getTripUpdatesByRoute(
        @Parameter(description = "Route identifier to filter by", example = "ROUTE_001")
        @PathVariable String routeId
    ) {
        try {
            log.info("Fetching trip updates for route: {}", routeId);
            List<SimpleTripUpdate> allUpdates = gtfsRealTimeService.fetchTripUpdates();

            List<SimpleTripUpdate> routeUpdates = allUpdates.stream()
                    .filter(update -> routeId.equals(update.routeId()))
                    .collect(Collectors.toList());

            log.info("Found {} trip updates for route {}", routeUpdates.size(), routeId);
            return ResponseEntity.ok(routeUpdates);

        } catch (IOException e) {
            log.error("Failed to fetch trip updates for route {} due to I/O error", routeId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching trip updates for route {}", routeId, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Gets count of delayed trips.
     * Returns the number of trips that are currently running behind schedule.
     *
     * @return ResponseEntity containing count of delayed trips
     */
    @GetMapping("/delays/count")
    @Operation(
        summary = "Get count of delayed trips",
        description = "Returns the total number of trips currently running behind schedule (any positive delay). " +
                     "Provides a quick metric for overall system performance and service reliability."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved delayed trip count",
            content = @Content(schema = @Schema(type = "integer", example = "42"))
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch trip data"
        )
    })
    public ResponseEntity<Integer> getDelayedTripsCount() {
        try {
            log.info("Fetching delayed trips count");
            List<SimpleTripUpdate> allUpdates = gtfsRealTimeService.fetchTripUpdates();

            int delayedCount = (int) allUpdates.stream()
                    .filter(update -> update.delay() > 0)
                    .count();

            log.info("Current delayed trips count: {}", delayedCount);
            return ResponseEntity.ok(delayedCount);

        } catch (IOException e) {
            log.error("Failed to fetch delayed trips count due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching delayed trips count", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
