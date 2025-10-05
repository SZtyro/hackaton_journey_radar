package pl.drunkcom.core.interfaces;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pl.drunkcom.core.enums.Incidents;
import pl.drunkcom.core.model.Raport;

import java.sql.Timestamp;
import java.util.List;

/**
 * Repository interface for managing Raport entities.
 * Extends BaseRepository to provide standard CRUD operations plus custom queries for reports.
 *
 * <p>This repository provides specialized methods for querying reports by various criteria
 * such as incident type, emergency status, route, and time periods.
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
@Repository
public interface RaportRepository extends BaseRepository<Raport> {

    /**
     * Find all reports by incident type.
     *
     * @param type The incident type to filter by
     * @return List of reports matching the incident type
     */
    List<Raport> findByType(Incidents type);

    /**
     * Find all emergency reports.
     *
     * @param isEmergency True to find emergency reports, false for non-emergency
     * @return List of reports filtered by emergency status
     */
    List<Raport> findByIsEmergency(boolean isEmergency);

    /**
     * Find reports by route ID.
     *
     * @param routeId The route identifier
     * @return List of reports for the specified route
     */
    @Query("SELECT r FROM Raport r WHERE r.route.routeId = :routeId")
    List<Raport> findByRouteId(@Param("routeId") String routeId);

    /**
     * Find reports within a time range.
     *
     * @param startTime Start of the time range
     * @param endTime End of the time range
     * @return List of reports within the specified time range
     */
    List<Raport> findByTimestampBetween(Timestamp startTime, Timestamp endTime);

    /**
     * Find emergency reports for a specific route.
     *
     * @param routeId The route identifier
     * @param isEmergency Emergency status filter
     * @return List of emergency reports for the specified route
     */
    @Query("SELECT r FROM Raport r WHERE r.route.routeId = :routeId AND r.isEmergency = :isEmergency")
    List<Raport> findByRouteIdAndIsEmergency(@Param("routeId") String routeId, @Param("isEmergency") boolean isEmergency);

    /**
     * Find reports by incident type with pagination.
     *
     * @param type The incident type to filter by
     * @param pageable Pagination parameters
     * @return Page of reports matching the incident type
     */
    Page<Raport> findByType(Incidents type, Pageable pageable);

    /**
     * Count reports by incident type.
     *
     * @param type The incident type
     * @return Number of reports with the specified incident type
     */
    long countByType(Incidents type);

    /**
     * Count emergency reports.
     *
     * @param isEmergency Emergency status filter
     * @return Number of reports with the specified emergency status
     */
    long countByIsEmergency(boolean isEmergency);
}
