package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Block;
import pl.drunkcom.core.service.BlockService;

/**
 * REST API controller for managing GTFS blocks.
 * Provides endpoints for accessing and managing blocks that group trips operated by the same vehicle.
 *
 * <p>Blocks represent a sequence of trips that are operated by the same vehicle during a service day.
 * This helps optimize vehicle scheduling and enables better real-time tracking by associating
 * multiple trips with a single vehicle's duty cycle.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/blocks - List all blocks</li>
 *   <li>GET /api/gtfs/blocks/page - List blocks with pagination</li>
 *   <li>GET /api/gtfs/blocks/{id} - Get specific block by ID</li>
 *   <li>POST /api/gtfs/blocks - Create new block</li>
 *   <li>PUT /api/gtfs/blocks/{id} - Update existing block</li>
 *   <li>DELETE /api/gtfs/blocks/{id} - Delete block</li>
 *   <li>GET /api/gtfs/blocks/count - Get total block count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see Block
 * @see BlockService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#tripstxt">GTFS Trips Reference (block_id field)</a>
 */
@RestController
@RequestMapping("/api/gtfs/blocks")
@CrossOrigin
@Tag(name = "Blocks", description = "GTFS Blocks management API. Handles vehicle duty cycles that group sequential trips operated by the same vehicle during a service day.")
public class BlockController extends BaseGtfsController<Block, String, BlockService> {
}
