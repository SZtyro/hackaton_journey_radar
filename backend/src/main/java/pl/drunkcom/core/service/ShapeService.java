package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.ShapeRepository;
import pl.drunkcom.core.model.gtfs.Shape;

@Service
public class ShapeService extends BaseGtfsService<Shape, Long, ShapeRepository> {
}
