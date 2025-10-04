package pl.drunkcom.core.model.gtfs;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

/**
 * Represents GTFS trips (from trips.txt):
 * According to GTFS specification: https://gtfs.org/documentation/schedule/reference/#tripstxt
 */
@Entity
@Table(name = "gtfs_trips")
@Getter
@Setter
@NoArgsConstructor
public class Trips {

    @Id
    @Column(name = "trip_id")
    private String tripId;

    @ManyToOne
    @JoinColumn(name = "route_id", referencedColumnName = "route_id", nullable = false)
    private Route route;

    @ManyToOne
    @JoinColumn(name = "service_id", referencedColumnName = "service_id", nullable = false)
    private Calendar calendar;

    @Column(name = "trip_headsign")
    private String tripHeadsign;

    @Column(name = "trip_short_name")
    private String tripShortName;

    @Column(name = "direction_id")
    private Integer directionId;

    @ManyToOne
    @JoinColumn(name = "block_id", referencedColumnName = "block_id")
    private Block block;

    @Column(name = "shape_id")
    private String shapeId;

    @Column(name = "wheelchair_accessible")
    private Integer wheelchairAccessible;

    @Column(name = "bikes_allowed")
    private Integer bikesAllowed;
}
