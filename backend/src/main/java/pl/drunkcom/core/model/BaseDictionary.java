package pl.drunkcom.core.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.*;

@Setter
@Getter
@ToString
@MappedSuperclass
public abstract class BaseDictionary extends BaseEntity {

    @Column
    private String name;

    @Column
    private Boolean enabled = true;

}
