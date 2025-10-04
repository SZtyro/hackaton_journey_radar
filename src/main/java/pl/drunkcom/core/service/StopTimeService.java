package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.StopTimeRepository;
import pl.drunkcom.core.model.gtfs.StopTime;

@Service
public class StopTimeService extends BaseGtfsService<StopTime, Long, StopTimeRepository> {
}
