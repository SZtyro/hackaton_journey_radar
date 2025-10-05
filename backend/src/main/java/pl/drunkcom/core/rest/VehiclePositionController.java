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
import pl.drunkcom.core.service.VehicleCurrentState;

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
     * Retrieves all buses with extended delay information.
     * Returns all active trips with their delay status for comprehensive frontend display.
     *
     * @return ResponseEntity containing list of all trips with delay information
     */
    @GetMapping("/delays")
    @Operation(
        summary = "Get all buses with delay information",
        description = "Retrieves all active trip updates including delay information for every bus (both on-time and delayed). " +
                     "This endpoint provides extended data with delay status for all vehicles in the system. " +
                     "Perfect for frontend applications that need to display comprehensive delay information for all buses."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved all trips with delay information",
            content = @Content(schema = @Schema(implementation = SimpleTripUpdate.class))
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch trip updates"
        )
    })
    public ResponseEntity<List<SimpleTripUpdate>> getDelayedTrips() {
        try {
            log.info("Fetching all trips with delay information");
            List<SimpleTripUpdate> allUpdates = gtfsRealTimeService.fetchTripUpdates();

            // Return ALL trips (both delayed and on-time) - no filtering
            log.info("Successfully retrieved {} trips with delay information", allUpdates.size());
            return ResponseEntity.ok(allUpdates);

        } catch (IOException e) {
            log.error("Failed to fetch trip delay information due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching trip delay information", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Retrieves only delayed trips (positive delay only).
     * Filters to show only buses that are running behind schedule.
     *
     * @return ResponseEntity containing list of only delayed trips
     */
    @GetMapping("/delays/only-delayed")
    @Operation(
        summary = "Get only delayed trips",
        description = "Retrieves trip updates filtered to show only buses with positive delays. " +
                     "This endpoint shows only buses running behind schedule, excluding on-time vehicles. " +
                     "Useful for monitoring service disruptions and identifying problem areas."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved only delayed trips",
            content = @Content(schema = @Schema(implementation = SimpleTripUpdate.class))
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch trip updates"
        )
    })
    public ResponseEntity<List<SimpleTripUpdate>> getOnlyDelayedTrips() {
        try {
            log.info("Fetching only delayed trips");
            List<SimpleTripUpdate> allUpdates = gtfsRealTimeService.fetchTripUpdates();

            List<SimpleTripUpdate> delayedTrips = allUpdates.stream()
                    .filter(update -> update.delay() > 0) // Only positive delays
                    .collect(Collectors.toList());

            log.info("Found {} delayed trips out of {} total", delayedTrips.size(), allUpdates.size());
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
     * Retrieves complete current state of all vehicles (positions + delay info combined).
     * Returns comprehensive data combining vehicle locations with their delay status.
     *
     * @return ResponseEntity containing list of vehicle current states
     */
    @GetMapping("/current-state")
    @Operation(
        summary = "Get complete current state of all vehicles",
        description = "Retrieves comprehensive current state data combining vehicle positions with trip updates. " +
                     "Each entry includes location coordinates, delay information, route details, and schedule status. " +
                     "This endpoint provides the most complete view of the transit system's current operational state."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved vehicle current states",
            content = @Content(
                schema = @Schema(
                    type = "array",
                    example = """
                        [
                          {
                            "vehicleId": "M:401",
                            "tripId": "30876679_256163",
                            "routeId": "160013",
                            "latitude": 50.0647,
                            "longitude": 19.9450,
                            "delay": 22,
                            "scheduleRelationship": "SCHEDULED",
                            "delayDescription": "On time"
                          }
                        ]
                        """
                )
            )
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch vehicle data"
        )
    })
    public ResponseEntity<List<VehicleCurrentState>> getCurrentState() {
        try {
            log.info("Fetching complete vehicle current state");
            List<VehicleCurrentState> currentStates = gtfsRealTimeService.fetchVehicleCurrentState();

            log.info("Successfully retrieved {} vehicle current states", currentStates.size());
            return ResponseEntity.ok(currentStates);

        } catch (IOException e) {
            log.error("Failed to fetch vehicle current state due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching vehicle current state", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Retrieves complete current state of vehicles within a specified radius.
     * Returns comprehensive data combining vehicle locations with their delay status for nearby vehicles.
     *
     * @param latitude User's latitude coordinate
     * @param longitude User's longitude coordinate
     * @param radiusKm Radius in kilometers to search within
     * @return ResponseEntity containing list of nearby vehicle current states
     */
    @GetMapping("/current-state/nearby")
    @Operation(
        summary = "Get current state of nearby vehicles",
        description = "Retrieves comprehensive current state data for vehicles within a specified radius. " +
                     "Combines position and delay information for vehicles near the specified coordinates. " +
                     "Perfect for mobile apps showing nearby transit options with real-time status."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved nearby vehicle current states",
            content = @Content(schema = @Schema(implementation = VehicleCurrentState.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid coordinates or radius parameters"
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch vehicle data"
        )
    })
    public ResponseEntity<List<VehicleCurrentState>> getNearbyCurrentState(
        @Parameter(description = "User's latitude coordinate", example = "50.0647")
        @RequestParam double latitude,
        @Parameter(description = "User's longitude coordinate", example = "19.9450")
        @RequestParam double longitude,
        @Parameter(description = "Search radius in kilometers", example = "2.0")
        @RequestParam double radiusKm
    ) {
        try {
            log.info("Fetching nearby vehicle current states within {}km of coordinates [{}, {}]",
                    radiusKm, latitude, longitude);

            // Validate input parameters
            if (latitude < -90.0 || latitude > 90.0 || longitude < -180.0 || longitude > 180.0) {
                log.warn("Invalid coordinates provided: lat={}, lon={}", latitude, longitude);
                return ResponseEntity.badRequest().build();
            }

            if (radiusKm <= 0 || radiusKm > 100) {
                log.warn("Invalid radius provided: {}km", radiusKm);
                return ResponseEntity.badRequest().build();
            }

            List<VehicleCurrentState> allStates = gtfsRealTimeService.fetchVehicleCurrentState();
            List<VehicleCurrentState> nearbyStates = gtfsRealTimeService.filterVehiclesByRadius(
                allStates, latitude, longitude, radiusKm);

            log.info("Found {} nearby vehicles out of {} total within {}km radius",
                    nearbyStates.size(), allStates.size(), radiusKm);
            return ResponseEntity.ok(nearbyStates);

        } catch (IOException e) {
            log.error("Failed to fetch nearby vehicle current state due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching nearby vehicle current state", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Retrieves vehicle positions within a specified radius.
     * Returns position data for vehicles near the specified coordinates.
     *
     * @param latitude User's latitude coordinate
     * @param longitude User's longitude coordinate
     * @param radiusKm Radius in kilometers to search within
     * @return ResponseEntity containing list of nearby vehicle positions
     */
    @GetMapping("/positions/nearby")
    @Operation(
        summary = "Get nearby vehicle positions",
        description = "Retrieves vehicle positions for vehicles within a specified radius. " +
                     "Returns only position data (coordinates, vehicle ID, trip ID) for nearby vehicles. " +
                     "Useful for map displays showing vehicle locations in a specific area."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved nearby vehicle positions",
            content = @Content(schema = @Schema(implementation = SimpleVehiclePosition.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid coordinates or radius parameters"
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch vehicle data"
        )
    })
    public ResponseEntity<List<SimpleVehiclePosition>> getNearbyPositions(
        @Parameter(description = "User's latitude coordinate", example = "50.0647")
        @RequestParam double latitude,
        @Parameter(description = "User's longitude coordinate", example = "19.9450")
        @RequestParam double longitude,
        @Parameter(description = "Search radius in kilometers", example = "2.0")
        @RequestParam double radiusKm
    ) {
        try {
            log.info("Fetching nearby vehicle positions within {}km of coordinates [{}, {}]",
                    radiusKm, latitude, longitude);

            // Validate input parameters
            if (latitude < -90.0 || latitude > 90.0 || longitude < -180.0 || longitude > 180.0) {
                log.warn("Invalid coordinates provided: lat={}, lon={}", latitude, longitude);
                return ResponseEntity.badRequest().build();
            }

            if (radiusKm <= 0 || radiusKm > 100) {
                log.warn("Invalid radius provided: {}km", radiusKm);
                return ResponseEntity.badRequest().build();
            }

            List<SimpleVehiclePosition> allPositions = gtfsRealTimeService.fetchVehiclePositions();
            List<SimpleVehiclePosition> nearbyPositions = allPositions.stream()
                .filter(position -> {
                    double distance = calculateDistance(latitude, longitude, position.latitude(), position.longitude());
                    return distance <= radiusKm;
                })
                .collect(Collectors.toList());

            log.info("Found {} nearby vehicle positions out of {} total within {}km radius",
                    nearbyPositions.size(), allPositions.size(), radiusKm);
            return ResponseEntity.ok(nearbyPositions);

        } catch (IOException e) {
            log.error("Failed to fetch nearby vehicle positions due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching nearby vehicle positions", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Retrieves trip delays within a specified radius.
     * Returns delay information for trips near the specified coordinates.
     *
     * @param latitude User's latitude coordinate
     * @param longitude User's longitude coordinate
     * @param radiusKm Radius in kilometers to search within
     * @return ResponseEntity containing list of nearby trip delays
     */
    @GetMapping("/delays/nearby")
    @Operation(
        summary = "Get nearby trip delays",
        description = "Retrieves trip delay information for vehicles within a specified radius. " +
                     "Returns delay data for trips near the specified coordinates. " +
                     "Useful for monitoring service disruptions in a specific area."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved nearby trip delays",
            content = @Content(schema = @Schema(implementation = SimpleTripUpdate.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid coordinates or radius parameters"
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error - failed to fetch trip data"
        )
    })
    public ResponseEntity<List<SimpleTripUpdate>> getNearbyDelays(
        @Parameter(description = "User's latitude coordinate", example = "50.0647")
        @RequestParam double latitude,
        @Parameter(description = "User's longitude coordinate", example = "19.9450")
        @RequestParam double longitude,
        @Parameter(description = "Search radius in kilometers", example = "2.0")
        @RequestParam double radiusKm
    ) {
        try {
            log.info("Fetching nearby trip delays within {}km of coordinates [{}, {}]",
                    radiusKm, latitude, longitude);

            // Validate input parameters
            if (latitude < -90.0 || latitude > 90.0 || longitude < -180.0 || longitude > 180.0) {
                log.warn("Invalid coordinates provided: lat={}, lon={}", latitude, longitude);
                return ResponseEntity.badRequest().build();
            }

            if (radiusKm <= 0 || radiusKm > 100) {
                log.warn("Invalid radius provided: {}km", radiusKm);
                return ResponseEntity.badRequest().build();
            }

            // Get all current states (positions + delays) and filter by radius
            List<VehicleCurrentState> nearbyStates = gtfsRealTimeService.filterVehiclesByRadius(
                gtfsRealTimeService.fetchVehicleCurrentState(), latitude, longitude, radiusKm);

            // Convert to SimpleTripUpdate format
            List<SimpleTripUpdate> nearbyDelays = nearbyStates.stream()
                .map(state -> new SimpleTripUpdate(
                    state.tripId(),
                    state.routeId(),
                    state.vehicleId(),
                    state.delay(),
                    state.scheduleRelationship()
                ))
                .collect(Collectors.toList());

            log.info("Found {} nearby trip delays within {}km radius", nearbyDelays.size(), radiusKm);
            return ResponseEntity.ok(nearbyDelays);

        } catch (IOException e) {
            log.error("Failed to fetch nearby trip delays due to I/O error", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();

        } catch (Exception e) {
            log.error("Unexpected error while fetching nearby trip delays", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Helper method to calculate distance between two GPS coordinates using Haversine formula.
     */
    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final int EARTH_RADIUS_KM = 6371;

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS_KM * c;
    }
}
