package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pl.drunkcom.core.model.gtfs.Stop;

public interface StopRepository extends JpaRepository<Stop, String>, JpaSpecificationExecutor<Stop> {
}
