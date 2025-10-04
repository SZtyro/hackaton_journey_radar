package pl.drunkcom.core.model.gtfs;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Represents GTFS shapes (from shapes.txt):
 * According to GTFS specification: https://gtfs.org/documentation/schedule/reference/#shapestxt
 * shape_id,shape_pt_lat,shape_pt_lon,shape_pt_sequence,shape_dist_traveled
 */
@Entity
@Table(name = "gtfs_shapes")
@Getter
@Setter
@NoArgsConstructor
public class Shape {

    @Id
    @Column(name = "shape_id")
    private String shapeId; // Required

    @Column(name = "shape_pt_sequence")
    private Integer shapePtSequence; // Required - changed to Integer for consistency

    @Column(name = "shape_pt_lat", nullable = false)
    private Double shapePtLat; // Required

    @Column(name = "shape_pt_lon", nullable = false)
    private Double shapePtLon; // Required

    @Column(name = "shape_dist_traveled")
    private Double shapeDistTraveled; // Optional
}
