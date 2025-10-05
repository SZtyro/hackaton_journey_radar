package pl.drunkcom.core.model;

import pl.drunkcom.core.enums.Incidents;
import pl.drunkcom.core.model.gtfs.Route;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.AllArgsConstructor;
import lombok.Builder;

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
    private Route route;

    @Column(name = "is_emergency")
    private boolean isEmergency;

    @Column(name = "timestamp")
    private Timestamp timestamp;

    @Column(name = "latitude")
    private Double latitude;

    @Column(name = "longitude")
    private Double longitude;
}
