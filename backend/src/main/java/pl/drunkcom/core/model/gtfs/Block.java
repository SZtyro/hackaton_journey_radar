package pl.drunkcom.core.model.gtfs;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Represents a block (sequence of trips served by the same vehicle) — created from a CSV
 * with columns block_id and shift.
 */
@Entity
@Table(name = "gtfs_blocks")
@Getter
@Setter
@NoArgsConstructor
public class Block {

    @Id
    @Column(name = "block_id")
    private String blockId; // e.g., "block_1"

    @Column(name = "shift", nullable = false)
    private String shift; // e.g., "102-01"
}

