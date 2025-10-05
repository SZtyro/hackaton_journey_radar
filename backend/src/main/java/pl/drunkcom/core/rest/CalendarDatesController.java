package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.CalendarDates;
import pl.drunkcom.core.service.CalendarDatesService;

/**
 * REST API controller for managing GTFS calendar date exceptions.
 * Provides endpoints for accessing and managing specific date exceptions to regular service patterns.
 *
 * <p>Calendar dates define exceptions to the regular service pattern defined in calendar.txt.
 * They specify dates when service is added (exception_type=1) or removed (exception_type=2)
 * from the normal schedule. This handles holidays, special events, and service disruptions.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/calendar-dates - List all calendar date exceptions</li>
 *   <li>GET /api/gtfs/calendar-dates/page - List calendar dates with pagination</li>
 *   <li>GET /api/gtfs/calendar-dates/{id} - Get specific calendar date by ID</li>
 *   <li>POST /api/gtfs/calendar-dates - Create new calendar date exception</li>
 *   <li>PUT /api/gtfs/calendar-dates/{id} - Update existing calendar date</li>
 *   <li>DELETE /api/gtfs/calendar-dates/{id} - Delete calendar date exception</li>
 *   <li>GET /api/gtfs/calendar-dates/count - Get total calendar date count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see CalendarDates
 * @see CalendarDatesService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#calendar_datestxt">GTFS Calendar Dates Reference</a>
 */
@RestController
@RequestMapping("/api/gtfs/calendar-dates")
@CrossOrigin
@Tag(name = "Calendar Dates", description = "GTFS Calendar Dates management API. Handles specific date exceptions for service additions or removals from regular schedules.")
public class CalendarDatesController extends BaseGtfsController<CalendarDates, Long, CalendarDatesService> {
}
