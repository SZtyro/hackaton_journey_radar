package pl.drunkcom.core.model.gtfs;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Date;

/**
 * Represents GTFS calendar (from calendar.txt):
 * According to GTFS specification: https://gtfs.org/documentation/schedule/reference/#calendartxt
 * service_id,monday,tuesday,wednesday,thursday,friday,saturday,sunday,start_date,end_date
 */
@Entity
@Table(name = "gtfs_calendars")
@Getter
@Setter
@NoArgsConstructor
public class Calendar {

    @Id
    @Column(name = "service_id")
    private String serviceId;

    @Column(name = "monday", nullable = false)
    private Integer monday; // 0 or 1

    @Column(name = "tuesday", nullable = false)
    private Integer tuesday; // 0 or 1

    @Column(name = "wednesday", nullable = false)
    private Integer wednesday; // 0 or 1

    @Column(name = "thursday", nullable = false)
    private Integer thursday; // 0 or 1

    @Column(name = "friday", nullable = false)
    private Integer friday; // 0 or 1

    @Column(name = "saturday", nullable = false)
    private Integer saturday; // 0 or 1

    @Column(name = "sunday", nullable = false)
    private Integer sunday; // 0 or 1

    @Column(name = "start_date", nullable = false)
    private Date startDate; // format YYYYMMDD

    @Column(name = "end_date", nullable = false)
    private Date endDate;   // format YYYYMMDD
}
