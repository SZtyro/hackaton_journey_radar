package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Trips;
import pl.drunkcom.core.service.TripsService;

import java.util.List;

/**
 * REST API controller for managing GTFS trips.
 * Provides endpoints for accessing and managing individual trips along routes with specific schedules.
 *
 * <p>Trips represent individual journeys along a route at specific times. Each trip defines the sequence
 * of stops visited and the schedule for a single vehicle journey. Trips are associated with routes,
 * service calendars, and may have specific shapes defining the geographic path.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/trips - List all trips</li>
 *   <li>GET /api/gtfs/trips/page - List trips with pagination</li>
 *   <li>GET /api/gtfs/trips/{id} - Get specific trip by ID</li>
 *   <li>POST /api/gtfs/trips - Create new trip</li>
 *   <li>PUT /api/gtfs/trips/{id} - Update existing trip</li>
 *   <li>DELETE /api/gtfs/trips/{id} - Delete trip</li>
 *   <li>GET /api/gtfs/trips/count - Get total trip count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see Trips
 * @see TripsService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#tripstxt">GTFS Trips Reference</a>
 */
@RestController
@RequestMapping("/api/gtfs/trips")
@CrossOrigin
@Tag(name = "Trips", description = "GTFS Trips management API. Handles individual vehicle journeys along routes with specific schedules and stop sequences.")
public class TripsController extends BaseGtfsController<Trips, String, TripsService> {

    @Autowired
    private TripsService tripsService;

    /**
     * Retrieves all trips for a specific route.
     * Returns all scheduled trips that operate along a particular route.
     *
     * @param routeId The GTFS route identifier
     * @return List of trips for the specified route
     */
    @GetMapping("/by-route/{routeId}")
    @Operation(
        summary = "Get trips by route ID",
        description = "Retrieves all scheduled trips for a specific GTFS route. This includes all service " +
                     "variations, directions, and time periods for the route. Essential for displaying " +
                     "complete route schedules and service patterns to passengers."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved trips for the route",
            content = @Content(schema = @Schema(implementation = Trips.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Route with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid route ID format provided"
        )
    })
    public ResponseEntity<List<Trips>> getTripsByRoute(
        @Parameter(description = "GTFS route identifier", example = "route_001", required = true)
        @PathVariable String routeId
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }

    /**
     * Retrieves trips filtered by service calendar.
     * Returns trips that operate on specific service days/periods.
     *
     * @param serviceId The GTFS service identifier
     * @return List of trips operating under the specified service
     */
    @GetMapping("/by-service/{serviceId}")
    @Operation(
        summary = "Get trips by service ID",
        description = "Retrieves all trips that operate under a specific GTFS service calendar. " +
                     "Service calendars define when trips run (weekdays, weekends, holidays, etc.). " +
                     "This endpoint helps filter trips by operational schedule patterns."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved trips for the service",
            content = @Content(schema = @Schema(implementation = Trips.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Service with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid service ID format provided"
        )
    })
    public ResponseEntity<List<Trips>> getTripsByService(
        @Parameter(description = "GTFS service identifier", example = "service_weekday", required = true)
        @PathVariable String serviceId
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }

    /**
     * Retrieves trips filtered by direction.
     * Returns trips traveling in a specific direction along the route.
     *
     * @param routeId The GTFS route identifier
     * @param directionId The direction identifier (0 or 1)
     * @return List of trips in the specified direction
     */
    @GetMapping("/by-route/{routeId}/direction/{directionId}")
    @Operation(
        summary = "Get trips by route and direction",
        description = "Retrieves trips for a specific route traveling in a particular direction. " +
                     "Direction ID is typically 0 for one direction (e.g., outbound) and 1 for the opposite " +
                     "direction (e.g., inbound). This helps separate service patterns by travel direction."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved trips for route and direction",
            content = @Content(schema = @Schema(implementation = Trips.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Route with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid route ID or direction ID provided"
        )
    })
    public ResponseEntity<List<Trips>> getTripsByRouteAndDirection(
        @Parameter(description = "GTFS route identifier", example = "route_001", required = true)
        @PathVariable String routeId,
        @Parameter(description = "Direction identifier (0 or 1)", example = "0", required = true)
        @PathVariable Integer directionId
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }
}
