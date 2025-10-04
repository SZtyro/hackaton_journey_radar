package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.StopTime;
import pl.drunkcom.core.service.StopTimeService;

@RestController
@RequestMapping("/api/gtfs/stop-times")
@CrossOrigin
public class StopTimeController extends BaseGtfsController<StopTime, Long, StopTimeService> {
}
