package pl.drunkcom.core.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import pl.drunkcom.core.enums.Incidents;
import pl.drunkcom.core.interfaces.RaportRepository;
import pl.drunkcom.core.model.Raport;
import pl.drunkcom.core.model.gtfs.Route;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;

/**
 * Service class for managing Raport entities.
 * Provides business logic and operations for handling incident reports in the transit system.
 *
 * <p>This service extends BaseGtfsService to inherit standard CRUD operations and adds
 * specialized methods for report management including filtering by incident type,
 * emergency status, routes, and time periods.
 *
 * <p>Key functionalities:
 * <ul>
 *   <li>Standard CRUD operations (Create, Read, Update, Delete)</li>
 *   <li>Filter reports by incident type and emergency status</li>
 *   <li>Find reports associated with specific routes</li>
 *   <li>Time-based report queries</li>
 *   <li>Statistical operations and counting</li>
 *   <li>Route ID validation and mapping</li>
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
@Service
public class RaportService extends BaseGtfsService<Raport, Long, RaportRepository> {

    @Autowired
    private RouteService routeService;

    public List<Raport> findByType(Incidents type) {
        return repository.findByType(type);
    }

    public List<Raport> findByEmergencyStatus(boolean isEmergency) {
        return repository.findByIsEmergency(isEmergency);
    }

    public List<Raport> findByRouteId(String routeId) {
        return repository.findByRouteId(routeId);
    }

    public List<Raport> findByTimeRange(Timestamp startTime, Timestamp endTime) {
        return repository.findByTimestampBetween(startTime, endTime);
    }

    public List<Raport> findByRouteAndEmergencyStatus(String routeId, boolean isEmergency) {
        return repository.findByRouteIdAndIsEmergency(routeId, isEmergency);
    }

    public Page<Raport> findByType(Incidents type, Pageable pageable) {
        return repository.findByType(type, pageable);
    }

    public long countByType(Incidents type) {
        return repository.countByType(type);
    }

    public long countByEmergencyStatus(boolean isEmergency) {
        return repository.countByIsEmergency(isEmergency);
    }

    public List<Raport> findAllEmergencyReports() {
        return findByEmergencyStatus(true);
    }

    public List<Raport> findRecentReports(int hours) {
        Timestamp endTime = new Timestamp(System.currentTimeMillis());
        Timestamp startTime = new Timestamp(System.currentTimeMillis() - (hours * 60 * 60 * 1000L));
        return findByTimeRange(startTime, endTime);
    }

    /**
     * Create or update a report with current timestamp and route validation.
     * Automatically sets the timestamp to current time if not provided.
     * Maps routeId to Route object and validates that the route exists.
     *
     * @param raport The report to create or update
     * @return The saved report with generated ID and timestamp
     * @throws IllegalArgumentException if routeId is invalid or route doesn't exist
     */
    @Override
    public Raport save(Raport raport) {
        // Handle routeId mapping - check if we need to set route from routeId
        String routeIdFromJson = raport.getRouteId();
        if (routeIdFromJson != null && !routeIdFromJson.trim().isEmpty()) {
            Optional<Route> route = routeService.findById(routeIdFromJson);
            if (route.isEmpty()) {
                throw new IllegalArgumentException("Route with ID '" + routeIdFromJson + "' does not exist");
            }
            raport.setRoute(route.get());
        }

        // Set timestamp if not provided
        if (raport.getTimestamp() == null) {
            raport.setTimestamp(new Timestamp(System.currentTimeMillis()));
        }

        return super.save(raport);
    }

    /**
     * Validate if a route ID exists in the system.
     *
     * @param routeId The route identifier to validate
     * @return true if route exists, false otherwise
     */
    public boolean isValidRouteId(String routeId) {
        if (routeId == null || routeId.trim().isEmpty()) {
            return false;
        }
        return routeService.findById(routeId).isPresent();
    }
}
