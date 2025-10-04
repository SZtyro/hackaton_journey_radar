package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.BlockRepository;
import pl.drunkcom.core.model.gtfs.Block;

@Service
public class BlockService extends BaseGtfsService<Block, String, BlockRepository> {
}
