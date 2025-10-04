package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Trips;
import pl.drunkcom.core.service.TripsService;

@RestController
@RequestMapping("/api/gtfs/trips")
@CrossOrigin
public class TripsController extends BaseGtfsController<Trips, String, TripsService> {
}
