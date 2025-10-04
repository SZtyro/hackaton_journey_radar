package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pl.drunkcom.core.model.gtfs.Calendar;

public interface CalendarRepository extends JpaRepository<Calendar, String>, JpaSpecificationExecutor<Calendar> {
}
