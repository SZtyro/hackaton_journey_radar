package pl.drunkcom.core.rest;

import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.model.gtfs.Block;
import pl.drunkcom.core.service.BlockService;

@RestController
@RequestMapping("/api/gtfs/blocks")
@CrossOrigin
public class BlockController extends BaseGtfsController<Block, String, BlockService> {
}
