package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Agency;
import pl.drunkcom.core.service.AgencyService;

/**
 * REST API controller for managing GTFS transit agencies.
 * Provides endpoints for accessing and managing transit agency information according to the GTFS specification.
 *
 * <p>An agency represents a transit operator that provides public transportation services.
 * Each agency has basic information like name, URL, timezone, and contact details.
 *
 * <p>This controller inherits standard CRUD operations from BaseGtfsController:
 * <ul>
 *   <li>GET /api/gtfs/agencies - List all agencies</li>
 *   <li>GET /api/gtfs/agencies/page - List agencies with pagination</li>
 *   <li>GET /api/gtfs/agencies/{id} - Get specific agency by ID</li>
 *   <li>POST /api/gtfs/agencies - Create new agency</li>
 *   <li>PUT /api/gtfs/agencies/{id} - Update existing agency</li>
 *   <li>DELETE /api/gtfs/agencies/{id} - Delete agency</li>
 *   <li>GET /api/gtfs/agencies/count - Get total agency count</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 * @see Agency
 * @see AgencyService
 * @see <a href="https://gtfs.org/documentation/schedule/reference/#agencytxt">GTFS Agency Reference</a>
 */
@RestController
@RequestMapping("/api/gtfs/agencies")
@CrossOrigin
@Tag(name = "Agencies", description = "GTFS Transit Agency management API. Handles transit operators and their basic information including names, URLs, timezones, and contact details.")
public class AgencyController extends BaseGtfsController<Agency, String, AgencyService> {
}
