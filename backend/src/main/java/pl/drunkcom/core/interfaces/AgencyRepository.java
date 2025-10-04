package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pl.drunkcom.core.model.gtfs.Agency;

public interface AgencyRepository extends JpaRepository<Agency, String>, JpaSpecificationExecutor<Agency> {
}
