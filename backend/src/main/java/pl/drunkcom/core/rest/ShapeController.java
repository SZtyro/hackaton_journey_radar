package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Shape;
import pl.drunkcom.core.service.ShapeService;

@RestController
@RequestMapping("/api/gtfs/shapes")
@CrossOrigin
public class ShapeController extends BaseGtfsController<Shape, Long, ShapeService> {
}
