package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pl.drunkcom.core.model.gtfs.Route;

public interface RouteRepository extends JpaRepository<Route, String>, JpaSpecificationExecutor<Route> {
}
