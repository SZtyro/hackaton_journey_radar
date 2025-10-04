package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pl.drunkcom.core.model.gtfs.StopTime;

public interface StopTimeRepository extends JpaRepository<StopTime, Long>, JpaSpecificationExecutor<StopTime> {
}
