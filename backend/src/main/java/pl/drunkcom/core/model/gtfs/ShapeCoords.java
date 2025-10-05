package pl.drunkcom.core.model.gtfs;

import lombok.Generated;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Getter
@Table(name = "gtfs_shapeCoords")

@Setter
public class ShapeCoords {

    @Id
    @GeneratedValue(strategy=GenerationType.SEQUENCE)
    private Long id;

    @Column(name = "shape_pt_sequence")
    private Integer shapePtSequence; // Required - changed to Integer for consistency

    @Column(name = "shape_pt_lat", nullable = false)
    private Double shapePtLat; // Required

    @Column(name = "shape_pt_lon", nullable = false)
    private Double shapePtLon; // Required

}
