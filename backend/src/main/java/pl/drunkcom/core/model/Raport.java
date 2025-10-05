package pl.drunkcom.core.model;

import pl.drunkcom.core.enums.Incidents;
import pl.drunkcom.core.model.gtfs.Route;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.AllArgsConstructor;
import lombok.Builder;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "raports")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Raport extends BaseEntity {

    @Enumerated(EnumType.STRING)
    @Column(name = "type")
    private Incidents type;

    @Column(name = "type_display_name")
    private String typeDisplayName;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "route_id", referencedColumnName = "route_id")
    @JsonIgnore
    private Route route;

    @Column(name = "is_emergency")
    private boolean isEmergency;

    @Column(name = "timestamp")
    private Timestamp timestamp;

    @Column(name = "latitude")
    private Double latitude;

    @Column(name = "longitude")
    private Double longitude;

    // Helper methods for JSON serialization
    @JsonProperty("routeId")
    public String getRouteId() {
        return route != null ? route.getRouteId() : null;
    }

    @JsonProperty("routeId")
    public void setRouteId(String routeId) {
        // This will be handled by the service layer
        // The route object will be set there based on routeId
    }
}
