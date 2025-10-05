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
import pl.drunkcom.core.model.gtfs.StopTime;
import pl.drunkcom.core.service.StopTimeService;

import java.util.List;

/**
 * REST API controller for managing GTFS stop times.
 * Provides endpoints for accessing and managing scheduled arrival and departure times for vehicles at specific stops.
 *
 * <p>Stop times represent the scheduled times when a vehicle arrives at and departs from individual stops
 * along a trip route. This is core schedule data that enables real-time tracking and passenger information.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/stop-times - List all stop times</li>
 *   <li>GET /api/gtfs/stop-times/page - List stop times with pagination</li>
 *   <li>GET /api/gtfs/stop-times/{id} - Get specific stop time by ID</li>
 *   <li>POST /api/gtfs/stop-times - Create new stop time</li>
 *   <li>PUT /api/gtfs/stop-times/{id} - Update existing stop time</li>
 *   <li>DELETE /api/gtfs/stop-times/{id} - Delete stop time</li>
 *   <li>GET /api/gtfs/stop-times/count - Get total stop time count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see StopTime
 * @see StopTimeService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#stop_timestxt">GTFS Stop Times Reference</a>
 */
@RestController
@RequestMapping("/api/gtfs/stop-times")
@CrossOrigin
@Tag(name = "Stop Times", description = "GTFS Stop Times management API. Handles scheduled arrival and departure times for vehicles at specific stops along trip routes.")
public class StopTimeController extends BaseGtfsController<StopTime, Long, StopTimeService> {

    @Autowired
    private StopTimeService stopTimeService;

    /**
     * Retrieves all stop times for a specific trip.
     * Returns stop times ordered by stop sequence for a complete trip schedule.
     *
     * @param tripId The GTFS trip identifier
     * @return List of stop times for the specified trip
     */
    @GetMapping("/by-trip/{tripId}")
    @Operation(
        summary = "Get stop times by trip ID",
        description = "Retrieves all scheduled stop times for a specific GTFS trip. " +
                     "Results are ordered by stop_sequence to show the chronological order of stops along the route. " +
                     "This endpoint is essential for displaying complete trip schedules and calculating travel times."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved stop times for the trip",
            content = @Content(schema = @Schema(implementation = StopTime.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Trip with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid trip ID format provided"
        )
    })
    public ResponseEntity<List<StopTime>> getStopTimesByTrip(
        @Parameter(description = "GTFS trip identifier", example = "trip_001", required = true)
        @PathVariable String tripId
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }

    /**
     * Retrieves all stop times for a specific stop.
     * Returns all scheduled arrivals and departures at a particular stop across all routes.
     *
     * @param stopId The GTFS stop identifier
     * @return List of stop times for the specified stop
     */
    @GetMapping("/by-stop/{stopId}")
    @Operation(
        summary = "Get stop times by stop ID",
        description = "Retrieves all scheduled stop times for a specific GTFS stop across all trips and routes. " +
                     "Useful for displaying departure boards and real-time information at transit stops. " +
                     "Results include all services that visit this stop throughout the day."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved stop times for the stop",
            content = @Content(schema = @Schema(implementation = StopTime.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Stop with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid stop ID format provided"
        )
    })
    public ResponseEntity<List<StopTime>> getStopTimesByStop(
        @Parameter(description = "GTFS stop identifier", example = "stop_001", required = true)
        @PathVariable String stopId
    ) {
        // Implementation would go here - for now returning empty list
        return ResponseEntity.ok(List.of());
    }
}
