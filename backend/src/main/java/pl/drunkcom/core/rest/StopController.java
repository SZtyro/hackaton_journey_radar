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
import pl.drunkcom.core.model.gtfs.Stop;
import pl.drunkcom.core.service.StopService;

import java.util.List;

/**
 * REST API controller for managing GTFS stops.
 * Provides endpoints for accessing and managing transit stops and stations where passengers board or alight vehicles.
 *
 * <p>Stops represent physical locations where passengers can board or exit transit vehicles.
 * This includes bus stops, train stations, subway platforms, and other boarding points.
 * Each stop has geographic coordinates, name, accessibility information, and zone data.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/stops - List all stops</li>
 *   <li>GET /api/gtfs/stops/page - List stops with pagination</li>
 *   <li>GET /api/gtfs/stops/{id} - Get specific stop by ID</li>
 *   <li>POST /api/gtfs/stops - Create new stop</li>
 *   <li>PUT /api/gtfs/stops/{id} - Update existing stop</li>
 *   <li>DELETE /api/gtfs/stops/{id} - Delete stop</li>
 *   <li>GET /api/gtfs/stops/count - Get total stop count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see Stop
 * @see StopService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#stopstxt">GTFS Stops Reference</a>
 */
@RestController
@RequestMapping("/api/gtfs/stops")
@CrossOrigin
@Tag(name = "Stops", description = "GTFS Stops management API. Handles transit stops and stations including geographic locations, accessibility information, and boarding points.")
public class StopController extends BaseGtfsController<Stop, String, StopService> {

    @Autowired
    private StopService stopService;

    /**
     * Finds stops within a specified radius of given coordinates.
     * Essential for mobile apps and location-based services.
     *
     * @param latitude The latitude coordinate
     * @param longitude The longitude coordinate
     * @param radius The search radius in meters
     * @return List of nearby stops within the specified radius
     */
    @GetMapping("/nearby")
    @Operation(
        summary = "Find nearby stops",
        description = "Finds all transit stops within a specified radius of given geographic coordinates. " +
                     "This endpoint is essential for mobile applications, trip planning, and location-based services. " +
                     "Results are typically ordered by distance from the query point."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved nearby stops",
            content = @Content(schema = @Schema(implementation = Stop.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid coordinates or radius provided"
        )
    })
    public ResponseEntity<List<Stop>> findNearbyStops(
        @Parameter(description = "Latitude coordinate", example = "50.0647", required = true)
        @RequestParam Double latitude,
        @Parameter(description = "Longitude coordinate", example = "19.9450", required = true)
        @RequestParam Double longitude,
        @Parameter(description = "Search radius in meters", example = "500", required = true)
        @RequestParam Double radius
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }

    /**
     * Retrieves all wheelchair accessible stops.
     * Filters stops based on wheelchair accessibility information.
     *
     * @return List of wheelchair accessible stops
     */
    @GetMapping("/accessible")
    @Operation(
        summary = "Get wheelchair accessible stops",
        description = "Retrieves all stops that are wheelchair accessible according to GTFS accessibility data. " +
                     "This endpoint supports accessibility features and helps passengers with mobility requirements " +
                     "find suitable boarding points."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved accessible stops",
            content = @Content(schema = @Schema(implementation = Stop.class))
        )
    })
    public ResponseEntity<List<Stop>> getAccessibleStops() {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }

    /**
     * Retrieves stops within a specific fare zone.
     * Useful for fare calculation and zone-based pricing systems.
     *
     * @param zoneId The fare zone identifier
     * @return List of stops in the specified zone
     */
    @GetMapping("/by-zone/{zoneId}")
    @Operation(
        summary = "Get stops by fare zone",
        description = "Retrieves all stops within a specific fare zone. This endpoint is useful for " +
                     "fare calculation systems, zone-based pricing, and understanding service coverage areas. " +
                     "Fare zones help determine pricing for multi-zone transit systems."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved stops in the zone",
            content = @Content(schema = @Schema(implementation = Stop.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Zone with specified ID not found"
        )
    })
    public ResponseEntity<List<Stop>> getStopsByZone(
        @Parameter(description = "Fare zone identifier", example = "zone_1", required = true)
        @PathVariable String zoneId
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }
}
