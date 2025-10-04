package pl.drunkcom.core.service;

import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.AgencyRepository;
import pl.drunkcom.core.model.gtfs.Agency;

@Service
public class AgencyService extends BaseGtfsService<Agency, String, AgencyRepository> {
}
