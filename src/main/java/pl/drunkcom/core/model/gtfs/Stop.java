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
 * Represents GTFS stop (from stops.txt):
 * According to GTFS specification: https://gtfs.org/documentation/schedule/reference/#stopstxt
 */
@Entity
@Table(name = "gtfs_stops")
@Getter
@Setter
@NoArgsConstructor
public class Stop {

    @Id
    @Column(name = "stop_id")
    private String stopId;

    @Column(name = "stop_code")
    private String stopCode;

    @Column(name = "stop_name")
    private String stopName;

    @Column(name = "stop_desc")
    private String stopDesc;

    @Column(name = "stop_lat")
    private Double stopLat;

    @Column(name = "stop_lon")
    private Double stopLon;

    @Column(name = "zone_id")
    private String zoneId;

    @Column(name = "stop_url")
    private String stopUrl;

    @Column(name = "location_type")
    private Integer locationType;

    @ManyToOne
    @JoinColumn(name = "parent_station", referencedColumnName = "stop_id")
    private Stop parentStation;

    @Column(name = "stop_timezone")
    private String stopTimezone;

    @Column(name = "wheelchair_boarding")
    private Integer wheelchairBoarding;

    @Column(name = "level_id")
    private String levelId;

    @Column(name = "platform_code")
    private String platformCode;
}
