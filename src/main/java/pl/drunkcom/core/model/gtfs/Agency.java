package pl.drunkcom.core.model.gtfs;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.OneToMany;
import javax.persistence.CascadeType;
import javax.persistence.FetchType;
import java.util.List;
import java.util.ArrayList;

/**
 * Represents a transit agency from the GTFS agency.txt file.
 */
@Entity
@Table(name = "gtfs_agencies")
@Getter
@Setter
@NoArgsConstructor
public class Agency {

    @Id
    @Column(name = "agency_id")
    private String agencyId; // e.g., "agency_1"

    @Column(name = "agency_name", nullable = false)
    private String agencyName; // e.g., "MPK S.A. w Krakowie"

    @Column(name = "agency_url", nullable = false)
    private String agencyUrl; // e.g., "http://www.mpk.krakow.pl/"

    @Column(name = "agency_timezone", nullable = false)
    private String agencyTimezone; // e.g., "Europe/Warsaw"

    @Column(name = "agency_lang")
    private String agencyLang; // e.g., "pl"

    @Column(name = "agency_phone")
    private String agencyPhone;

    @Column(name = "agency_fare_url")
    private String agencyFareUrl;

    @JsonIgnore
    @OneToMany(mappedBy = "agency", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Route> routes = new ArrayList<>();

    // helper methods to maintain bidirectional relationship
    public void addRoute(Route route) {
        if (route == null) return;
        if (!this.routes.contains(route)) {
            this.routes.add(route);
            route.setAgency(this);
        }
    }

    public void removeRoute(Route route) {
        if (route == null) return;
        if (this.routes.remove(route)) {
            route.setAgency(null);
        }
    }
}
