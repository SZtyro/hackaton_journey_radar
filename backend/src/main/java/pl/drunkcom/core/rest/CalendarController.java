package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Calendar;
import pl.drunkcom.core.service.CalendarService;

/**
 * REST API controller for managing GTFS calendar service periods.
 * Provides endpoints for accessing and managing service calendar definitions that specify when trips run.
 *
 * <p>Calendar entries define service periods using weekly patterns (which days of the week)
 * and date ranges (start and end dates). They specify when transit services operate,
 * such as weekday service, weekend service, or holiday schedules.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/calendar - List all calendar entries</li>
 *   <li>GET /api/gtfs/calendar/page - List calendar entries with pagination</li>
 *   <li>GET /api/gtfs/calendar/{id} - Get specific calendar entry by ID</li>
 *   <li>POST /api/gtfs/calendar - Create new calendar entry</li>
 *   <li>PUT /api/gtfs/calendar/{id} - Update existing calendar entry</li>
 *   <li>DELETE /api/gtfs/calendar/{id} - Delete calendar entry</li>
 *   <li>GET /api/gtfs/calendar/count - Get total calendar entry count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see Calendar
 * @see CalendarService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#calendartxt">GTFS Calendar Reference</a>
 */
@RestController
@RequestMapping("/api/gtfs/calendar")
@CrossOrigin
@Tag(name = "Calendar", description = "GTFS Calendar management API. Handles service periods and schedules that define when transit services operate using weekly patterns and date ranges.")
public class CalendarController extends BaseGtfsController<Calendar, String, CalendarService> {
}
