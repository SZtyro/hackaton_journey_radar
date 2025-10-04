package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.RouteRepository;
import pl.drunkcom.core.model.gtfs.Route;

@Service
public class RouteService extends BaseGtfsService<Route, String, RouteRepository> {
}
