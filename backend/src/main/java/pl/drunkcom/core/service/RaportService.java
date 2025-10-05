package pl.drunkcom.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import pl.drunkcom.core.enums.Incidents;
import pl.drunkcom.core.interfaces.RaportRepository;
import pl.drunkcom.core.model.Raport;

import java.sql.Timestamp;
import java.util.List;

@Service
public class RaportService extends BaseGtfsService<Raport, Long, RaportRepository> {

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

    @Override
    public Raport save(Raport raport) {
        if (raport.getTimestamp() == null) {
            raport.setTimestamp(new Timestamp(System.currentTimeMillis()));
        }
        return super.save(raport);
    }
}
