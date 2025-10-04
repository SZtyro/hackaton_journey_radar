package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.CalendarDatesRepository;
import pl.drunkcom.core.model.gtfs.CalendarDates;

@Service
public class CalendarDatesService extends BaseGtfsService<CalendarDates, Long, CalendarDatesRepository> {
}
