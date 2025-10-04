package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.StopRepository;
import pl.drunkcom.core.model.gtfs.Stop;

@Service
public class StopService extends BaseGtfsService<Stop, String, StopRepository> {
}
