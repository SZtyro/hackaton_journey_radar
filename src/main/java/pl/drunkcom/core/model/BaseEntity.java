package pl.drunkcom.core.model;


import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import java.util.Date;

@Data
@JsonIgnoreProperties(value = {"entityType"}, allowGetters = true)
@MappedSuperclass
public abstract class BaseEntity {
    @Id
    @GeneratedValue
    private Long id;

    @Column(name = "created", updatable = false)
    private final Date createdDate = new Date();

    @Column(nullable = false)
    private Integer version = 0;

    @Column
    private boolean draft = true;

    public boolean isDraft() {
        return draft;
    }

    @JsonProperty
    public String getEntityType(){
        return getClass().getName();
    }

}
