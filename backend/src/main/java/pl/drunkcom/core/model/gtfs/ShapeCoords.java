package pl.drunkcom.core.model.gtfs;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;

@Entity
@Getter
@Setter
public class ShapeCoords {

    @Column(name = "shape_pt_sequence")
    private Integer shapePtSequence; // Required - changed to Integer for consistency

    @Column(name = "shape_pt_lat", nullable = false)
    private Double shapePtLat; // Required

    @Column(name = "shape_pt_lon", nullable = false)
    private Double shapePtLon; // Required

}
