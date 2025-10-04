package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Stop;
import pl.drunkcom.core.service.StopService;

@RestController
@RequestMapping("/api/gtfs/stops")
@CrossOrigin
public class StopController extends BaseGtfsController<Stop, String, StopService> {
}
