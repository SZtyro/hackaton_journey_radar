package pl.drunkcom.core.model.gtfs;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import pl.drunkcom.core.model.Raport;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents a GTFS route from the routes.txt file.
 * According to GTFS specification: https://gtfs.org/documentation/schedule/reference/#routestxt
 */
@Entity
@Table(name = "gtfs_routes")
@Getter
@Setter
@NoArgsConstructor
public class Route {

    @Id
    @Column(name = "route_id")
    private String routeId;

    @ManyToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "agency_id", referencedColumnName = "agency_id")
    private Agency agency;

    @Column(name = "route_short_name")
    private String routeShortName;

    @Column(name = "route_long_name")
    private String routeLongName;

    @Column(name = "route_desc")
    private String routeDesc;

    @Column(name = "route_type", nullable = false)
    private Integer routeType; // Required field in GTFS

    @Column(name = "route_url")
    private String routeUrl;

    @Column(name = "route_color")
    private String routeColor;

    @Column(name = "route_text_color")
    private String routeTextColor;

    @Column(name = "route_sort_order")
    private Integer routeSortOrder;

    @Column(name = "continuous_pickup")
    private Integer continuousPickup;

    @Column(name = "continuous_drop_off")
    private Integer continuousDropOff;

    @JsonIgnore
    @OneToMany(mappedBy = "route", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Raport> raports = new ArrayList<>();

    // helper methods to maintain bidirectional relationship with reports
    public void addRaport(Raport raport) {
        if (raport == null) return;
        if (!this.raports.contains(raport)) {
            this.raports.add(raport);
            raport.setRoute(this);
        }
    }

    public void removeRaport(Raport raport) {
        if (raport == null) return;
        if (this.raports.remove(raport)) {
            raport.setRoute(null);
        }
    }
}
