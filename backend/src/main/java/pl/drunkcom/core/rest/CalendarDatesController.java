package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.CalendarDates;
import pl.drunkcom.core.service.CalendarDatesService;

@RestController
@RequestMapping("/api/gtfs/calendar-dates")
@CrossOrigin
public class CalendarDatesController extends BaseGtfsController<CalendarDates, Long, CalendarDatesService> {
}
