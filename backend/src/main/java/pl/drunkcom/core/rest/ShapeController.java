package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Shape;
import pl.drunkcom.core.service.ShapeService;

/**
 * REST API controller for managing GTFS shapes.
 * Provides endpoints for accessing and managing geographic shapes that define the path vehicles travel along routes.
 *
 * <p>Shapes define the geographic path that a vehicle travels along a route. They consist of a sequence
 * of geographic coordinates that, when connected, show the actual path of travel on a map.
 * Shapes help display accurate route paths and calculate travel distances.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/shapes - List all shapes</li>
 *   <li>GET /api/gtfs/shapes/page - List shapes with pagination</li>
 *   <li>GET /api/gtfs/shapes/{id} - Get specific shape by ID</li>
 *   <li>POST /api/gtfs/shapes - Create new shape</li>
 *   <li>PUT /api/gtfs/shapes/{id} - Update existing shape</li>
 *   <li>DELETE /api/gtfs/shapes/{id} - Delete shape</li>
 *   <li>GET /api/gtfs/shapes/count - Get total shape count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see Shape
 * @see ShapeService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#shapestxt">GTFS Shapes Reference</a>
 */
@RestController
@RequestMapping("/api/gtfs/shapes")
@CrossOrigin
@Tag(name = "Shapes", description = "GTFS Shapes management API. Handles geographic paths and route geometries that define the actual travel paths of vehicles.")
public class ShapeController extends BaseGtfsController<Shape, Long, ShapeService> {
}
