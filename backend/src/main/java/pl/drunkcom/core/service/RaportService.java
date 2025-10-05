package pl.drunkcom.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import pl.drunkcom.core.enums.Incidents;
import pl.drunkcom.core.interfaces.RaportRepository;
import pl.drunkcom.core.model.Raport;

import java.sql.Timestamp;
import java.util.List;

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
 * </ul>
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
@Service
public class RaportService extends BaseGtfsService<Raport, Long, RaportRepository> {

    /**
     * Find all reports by incident type.
     *
     * @param type The incident type to filter by
     * @return List of reports matching the incident type
     */
    public List<Raport> findByType(Incidents type) {
        return repository.findByType(type);
    }

    /**
     * Find all emergency reports.
     *
     * @param isEmergency True to find emergency reports, false for non-emergency
     * @return List of reports filtered by emergency status
     */
    public List<Raport> findByEmergencyStatus(boolean isEmergency) {
        return repository.findByIsEmergency(isEmergency);
    }

    /**
     * Find all reports for a specific route.
     *
     * @param routeId The route identifier
     * @return List of reports for the specified route
     */
    public List<Raport> findByRouteId(String routeId) {
        return repository.findByRouteId(routeId);
    }

    /**
     * Find reports within a specific time range.
     *
     * @param startTime Start of the time range
     * @param endTime End of the time range
     * @return List of reports within the specified time range
     */
    public List<Raport> findByTimeRange(Timestamp startTime, Timestamp endTime) {
        return repository.findByTimestampBetween(startTime, endTime);
    }

    /**
     * Find emergency reports for a specific route.
     *
     * @param routeId The route identifier
     * @param isEmergency Emergency status filter
     * @return List of emergency reports for the specified route
     */
    public List<Raport> findByRouteAndEmergencyStatus(String routeId, boolean isEmergency) {
        return repository.findByRouteIdAndIsEmergency(routeId, isEmergency);
    }

    /**
     * Find reports by incident type with pagination support.
     *
     * @param type The incident type to filter by
     * @param pageable Pagination parameters
     * @return Page of reports matching the incident type
     */
    public Page<Raport> findByType(Incidents type, Pageable pageable) {
        return repository.findByType(type, pageable);
    }

    /**
     * Count reports by incident type.
     *
     * @param type The incident type
     * @return Number of reports with the specified incident type
     */
    public long countByType(Incidents type) {
        return repository.countByType(type);
    }

    /**
     * Count reports by emergency status.
     *
     * @param isEmergency Emergency status filter
     * @return Number of reports with the specified emergency status
     */
    public long countByEmergencyStatus(boolean isEmergency) {
        return repository.countByIsEmergency(isEmergency);
    }

    /**
     * Get all emergency reports.
     * Convenience method for finding all reports marked as emergency.
     *
     * @return List of all emergency reports
     */
    public List<Raport> findAllEmergencyReports() {
        return findByEmergencyStatus(true);
    }

    /**
     * Get recent reports within the last specified hours.
     *
     * @param hours Number of hours to look back
     * @return List of reports from the last specified hours
     */
    public List<Raport> findRecentReports(int hours) {
        Timestamp endTime = new Timestamp(System.currentTimeMillis());
        Timestamp startTime = new Timestamp(System.currentTimeMillis() - (hours * 60 * 60 * 1000L));
        return findByTimeRange(startTime, endTime);
    }

    /**
     * Create a new report with current timestamp.
     * Automatically sets the timestamp to current time if not provided.
     *
     * @param raport The report to create
     * @return The created report with generated ID and timestamp
     */
    @Override
    public Raport save(Raport raport) {
        if (raport.getTimestamp() == null) {
            raport.setTimestamp(new Timestamp(System.currentTimeMillis()));
        }
        return super.save(raport);
    }
}
