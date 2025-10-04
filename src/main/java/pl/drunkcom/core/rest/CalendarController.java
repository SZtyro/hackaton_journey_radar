package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Calendar;
import pl.drunkcom.core.service.CalendarService;

@RestController
@RequestMapping("/api/gtfs/calendars")
@CrossOrigin
public class CalendarController extends BaseGtfsController<Calendar, String, CalendarService> {
}
