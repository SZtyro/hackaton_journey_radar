package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pl.drunkcom.core.model.gtfs.CalendarDates;

public interface CalendarDatesRepository extends JpaRepository<CalendarDates, Long>, JpaSpecificationExecutor<CalendarDates> {
}
