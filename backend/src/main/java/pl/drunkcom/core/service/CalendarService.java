package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.CalendarRepository;
import pl.drunkcom.core.model.gtfs.Calendar;

@Service
public class CalendarService extends BaseGtfsService<Calendar, String, CalendarRepository> {
}
