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
import javax.persistence.Table;

/**
 * Represents GTFS stop_times (from stop_times.txt):
 * According to GTFS specification: https://gtfs.org/documentation/schedule/reference/#stop_timestxt
 */
@Entity
@Table(name = "gtfs_stop_times")
@Getter
@Setter
@NoArgsConstructor
public class StopTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "trip_id", referencedColumnName = "trip_id", nullable = false)
    private Trips trips;

    @Column(name = "stop_sequence")
    private Integer stopSequence;

    @Column(name = "arrival_time")
    private String arrivalTime; // format HH:MM:SS

    @Column(name = "departure_time")
    private String departureTime; // format HH:MM:SS

    @ManyToOne
    @JoinColumn(name = "stop_id", referencedColumnName = "stop_id", nullable = false)
    private Stop stop;

    @Column(name = "stop_headsign")
    private String stopHeadsign;

    @Column(name = "pickup_type")
    private Integer pickupType;

    @Column(name = "drop_off_type")
    private Integer dropOffType;

    @Column(name = "continuous_pickup")
    private Integer continuousPickup;

    @Column(name = "continuous_drop_off")
    private Integer continuousDropOff;

    @Column(name = "shape_dist_traveled")
    private Double shapeDistTraveled;

    @Column(name = "timepoint")
    private Integer timepoint;
}
