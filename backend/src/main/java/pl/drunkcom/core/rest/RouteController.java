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
import pl.drunkcom.core.model.gtfs.Route;
import pl.drunkcom.core.service.RouteService;

import java.util.List;

/**
 * REST API controller for managing GTFS routes.
 * Provides endpoints for accessing and managing transit routes operated by agencies.
 *
 * <p>Routes represent transit lines or services operated by an agency. Each route has a unique identifier,
 * short and long names, type (bus, rail, etc.), color coding, and agency association.
 * Routes group trips that display to passengers as a single service.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/routes - List all routes</li>
 *   <li>GET /api/gtfs/routes/page - List routes with pagination</li>
 *   <li>GET /api/gtfs/routes/{id} - Get specific route by ID</li>
 *   <li>POST /api/gtfs/routes - Create new route</li>
 *   <li>PUT /api/gtfs/routes/{id} - Update existing route</li>
 *   <li>DELETE /api/gtfs/routes/{id} - Delete route</li>
 *   <li>GET /api/gtfs/routes/count - Get total route count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see Route
 * @see RouteService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#routestxt">GTFS Routes Reference</a>
 */
@RestController
@RequestMapping("/api/gtfs/routes")
@CrossOrigin
@Tag(name = "Routes", description = "GTFS Routes management API. Handles transit routes and lines operated by agencies, including route types, names, and visual identification.")
public class RouteController extends BaseGtfsController<Route, String, RouteService> {

    @Autowired
    private RouteService routeService;

    /**
     * Retrieves all routes operated by a specific agency.
     * Returns routes filtered by agency for organizational purposes.
     *
     * @param agencyId The GTFS agency identifier
     * @return List of routes operated by the specified agency
     */
    @GetMapping("/by-agency/{agencyId}")
    @Operation(
        summary = "Get routes by agency ID",
        description = "Retrieves all transit routes operated by a specific GTFS agency. " +
                     "This endpoint is useful for organizing routes by operator and displaying " +
                     "agency-specific service information to passengers."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved routes for the agency",
            content = @Content(schema = @Schema(implementation = Route.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Agency with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid agency ID format provided"
        )
    })
    public ResponseEntity<List<Route>> getRoutesByAgency(
        @Parameter(description = "GTFS agency identifier", example = "agency_001", required = true)
        @PathVariable String agencyId
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }

    /**
     * Retrieves routes filtered by route type.
     * Returns routes of a specific transportation mode (bus, rail, ferry, etc.).
     *
     * @param routeType The GTFS route type (0=Tram, 1=Subway, 2=Rail, 3=Bus, etc.)
     * @return List of routes of the specified type
     */
    @GetMapping("/by-type/{routeType}")
    @Operation(
        summary = "Get routes by route type",
        description = "Retrieves all routes filtered by GTFS route type. Route types include: " +
                     "0=Tram/Streetcar, 1=Subway/Metro, 2=Rail, 3=Bus, 4=Ferry, 5=Cable Tram, " +
                     "6=Aerial Lift, 7=Funicular, 11=Trolleybus, 12=Monorail. " +
                     "This helps categorize services by transportation mode."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved routes of the specified type",
            content = @Content(schema = @Schema(implementation = Route.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid route type provided"
        )
    })
    public ResponseEntity<List<Route>> getRoutesByType(
        @Parameter(description = "GTFS route type (0=Tram, 1=Subway, 2=Rail, 3=Bus, 4=Ferry, etc.)",
                  example = "3", required = true)
        @PathVariable Integer routeType
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }
}
