package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pl.drunkcom.core.model.gtfs.Trips;

public interface TripsRepository extends JpaRepository<Trips, String>, JpaSpecificationExecutor<Trips> {
}
