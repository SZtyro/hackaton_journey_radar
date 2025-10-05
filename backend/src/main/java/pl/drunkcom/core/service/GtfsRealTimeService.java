package pl.drunkcom.core.service;

import com.google.transit.realtime.GtfsRealtime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class GtfsRealTimeService {

    private static final Logger log = LoggerFactory.getLogger(GtfsRealTimeService.class);
    private static final String KRAKOW_VEHICLE_POSITIONS_URL = "https://gtfs.ztp.krakow.pl/VehiclePositions.pb";

    private final RestTemplate restTemplate;

    // Use constructor injection for dependencies - it's a best practice.
    public GtfsRealTimeService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    /**
     * Fetches and parses the live vehicle positions.
     * @return A list of simplified vehicle position objects.
     * @throws IOException if the binary data cannot be parsed.
     */
    public List<SimpleVehiclePosition> fetchVehiclePositions() throws IOException {
        log.info("Fetching vehicle positions from: {}", KRAKOW_VEHICLE_POSITIONS_URL);

        // 1. Fetch the raw binary data from the URL.
        byte[] gtfsRtData = restTemplate.getForObject(KRAKOW_VEHICLE_POSITIONS_URL, byte[].class);

        if (gtfsRtData == null || gtfsRtData.length == 0) {
            log.warn("Failed to fetch data, response was empty.");
            return List.of(); // Return an empty list to avoid nulls.
        }

        // 2. Parse the binary data using the GTFS-RT bindings library.
        GtfsRealtime.FeedMessage feedMessage = GtfsRealtime.FeedMessage.parseFrom(gtfsRtData);

        List<SimpleVehiclePosition> positions = new ArrayList<>();

        // 3. Loop through the results and extract the useful information.
        for (GtfsRealtime.FeedEntity entity : feedMessage.getEntityList()) {
            // Check if this entity actually contains vehicle position information.
            if (entity.hasVehicle()) {
                GtfsRealtime.VehiclePosition vehicle = entity.getVehicle();

                String vehicleId = vehicle.getVehicle().getId();
                String tripId = vehicle.getTrip().getTripId();
                float latitude = vehicle.getPosition().getLatitude();
                float longitude = vehicle.getPosition().getLongitude();

                positions.add(new SimpleVehiclePosition(vehicleId, tripId, latitude, longitude));
            }
        }
        log.info("Successfully parsed {} vehicle positions.", positions.size());
        return positions;
    }
}
