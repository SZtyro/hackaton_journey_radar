package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Agency;
import pl.drunkcom.core.service.AgencyService;

@RestController
@RequestMapping("/api/gtfs/agencies")
@CrossOrigin
public class AgencyController extends BaseGtfsController<Agency, String, AgencyService> {
}
