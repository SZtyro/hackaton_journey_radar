package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Route;
import pl.drunkcom.core.service.RouteService;

@RestController
@RequestMapping("/api/gtfs/routes")
@CrossOrigin
public class RouteController extends BaseGtfsController<Route, String, RouteService> {
}
