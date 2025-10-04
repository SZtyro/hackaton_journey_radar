package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pl.drunkcom.core.model.gtfs.Block;

public interface BlockRepository extends JpaRepository<Block, String>, JpaSpecificationExecutor<Block> {
}
