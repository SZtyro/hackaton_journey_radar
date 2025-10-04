package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.TripsRepository;
import pl.drunkcom.core.model.gtfs.Trips;

@Service
public class TripsService extends BaseGtfsService<Trips, String, TripsRepository> {
}
