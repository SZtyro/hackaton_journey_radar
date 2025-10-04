package pl.drunkcom.core.model.gtfs;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.FetchType;
import javax.persistence.Table;

/**
 * Simplified CalendarDates entity (no EmbeddedId):
 * service_id,date,exception_type
 */
@Entity
@Table(name = "gtfs_calendar_dates")
@Getter
@Setter
@NoArgsConstructor
public class CalendarDates {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "service_id", nullable = false)
    private String serviceId;

    // optional lazy reference to Calendar (service_id is the FK column)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_id", referencedColumnName = "service_id", insertable = false, updatable = false)
    private Calendar calendar;

    @Column(name = "date", nullable = false)
    private String date; // format YYYYMMDD

    @Column(name = "exception_type", nullable = false)
    private Integer exceptionType; // 1 = service added, 2 = service removed
}
