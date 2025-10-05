package pl.drunkcom.core.service;

import com.google.transit.realtime.GtfsRealtime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class GtfsRealTimeService {

    private static final Logger log = LoggerFactory.getLogger(GtfsRealTimeService.class);
    private static final String KRAKOW_VEHICLE_POSITIONS_URL = "https://gtfs.ztp.krakow.pl/VehiclePositions.pb";
    private static final String KRAKOW_TRIP_UPDATES_URL = "https://gtfs.ztp.krakow.pl/TripUpdates.pb";

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

    /**
     * Fetches and parses the live trip updates (delays and schedule changes).
     * @return A list of simplified trip update objects.
     * @throws IOException if the binary data cannot be parsed.
     */
    public List<SimpleTripUpdate> fetchTripUpdates() throws IOException {
        log.info("Fetching trip updates from: {}", KRAKOW_TRIP_UPDATES_URL);

        // 1. Fetch the raw binary data from the URL.
        byte[] gtfsRtData = restTemplate.getForObject(KRAKOW_TRIP_UPDATES_URL, byte[].class);

        if (gtfsRtData == null || gtfsRtData.length == 0) {
            log.warn("Failed to fetch trip updates data, response was empty.");
            return List.of(); // Return an empty list to avoid nulls.
        }

        // 2. Parse the binary data using the GTFS-RT bindings library.
        GtfsRealtime.FeedMessage feedMessage = GtfsRealtime.FeedMessage.parseFrom(gtfsRtData);

        List<SimpleTripUpdate> tripUpdates = new ArrayList<>();

        // 3. Loop through the results and extract the useful information.
        for (GtfsRealtime.FeedEntity entity : feedMessage.getEntityList()) {
            // Check if this entity actually contains trip update information.
            if (entity.hasTripUpdate()) {
                GtfsRealtime.TripUpdate tripUpdate = entity.getTripUpdate();

                String tripId = tripUpdate.getTrip().getTripId();
                String routeId = tripUpdate.getTrip().hasRouteId() ? tripUpdate.getTrip().getRouteId() : "";
                String vehicleId = tripUpdate.hasVehicle() ? tripUpdate.getVehicle().getId() : null;

                // Get the schedule relationship
                String scheduleRelationship = tripUpdate.getTrip().getScheduleRelationship().name();

                // Get the delay from stop time updates - we need at least one stop time update
                int delay = 0;
                if (!tripUpdate.getStopTimeUpdateList().isEmpty()) {
                    // Get the delay from the first stop time update
                    GtfsRealtime.TripUpdate.StopTimeUpdate stopTimeUpdate = tripUpdate.getStopTimeUpdate(0);
                    if (stopTimeUpdate.hasArrival() && stopTimeUpdate.getArrival().hasDelay()) {
                        delay = stopTimeUpdate.getArrival().getDelay();
                    } else if (stopTimeUpdate.hasDeparture() && stopTimeUpdate.getDeparture().hasDelay()) {
                        delay = stopTimeUpdate.getDeparture().getDelay();
                    }
                }

                tripUpdates.add(new SimpleTripUpdate(tripId, routeId, vehicleId, delay, scheduleRelationship));
            }
        }
        log.info("Successfully parsed {} trip updates.", tripUpdates.size());
        return tripUpdates;
    }

    /**
     * Fetches and combines vehicle positions with trip updates to create comprehensive current state data.
     * @return A list of vehicle current state objects combining position and delay information.
     * @throws IOException if the data cannot be fetched or parsed.
     */
    public List<VehicleCurrentState> fetchVehicleCurrentState() throws IOException {
        log.info("Fetching comprehensive vehicle current state data");

        // Fetch both position and trip update data
        List<SimpleVehiclePosition> positions = fetchVehiclePositions();
        List<SimpleTripUpdate> tripUpdates = fetchTripUpdates();

        // Create a map of trip updates indexed by trip ID for fast lookup
        Map<String, SimpleTripUpdate> tripUpdateMap = tripUpdates.stream()
                .collect(Collectors.toMap(SimpleTripUpdate::tripId, update -> update, (existing, replacement) -> existing));

        List<VehicleCurrentState> currentStates = new ArrayList<>();

        // Combine position data with trip update data
        for (SimpleVehiclePosition position : positions) {
            SimpleTripUpdate tripUpdate = tripUpdateMap.get(position.tripId());
            VehicleCurrentState currentState = VehicleCurrentState.from(position, tripUpdate);

            // Only add valid vehicle states
            if (currentState.isValid()) {
                currentStates.add(currentState);
            }
        }

        log.info("Successfully created {} vehicle current states from {} positions and {} trip updates",
                 currentStates.size(), positions.size(), tripUpdates.size());
        return currentStates;
    }

    /**
     * Filters vehicles within a specified radius from given coordinates.
     * @param vehicles List of vehicles to filter
     * @param userLat User's latitude
     * @param userLon User's longitude
     * @param radiusKm Radius in kilometers
     * @return Filtered list of vehicles within the radius
     */
    public List<VehicleCurrentState> filterVehiclesByRadius(List<VehicleCurrentState> vehicles,
                                                           double userLat, double userLon, double radiusKm) {
        return vehicles.stream()
                .filter(vehicle -> {
                    double distance = calculateDistance(userLat, userLon, vehicle.latitude(), vehicle.longitude());
                    return distance <= radiusKm;
                })
                .collect(Collectors.toList());
    }

    /**
     * Calculates the distance between two GPS coordinates using the Haversine formula.
     * @param lat1 First latitude
     * @param lon1 First longitude
     * @param lat2 Second latitude
     * @param lon2 Second longitude
     * @return Distance in kilometers
     */
    private double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
        final int EARTH_RADIUS_KM = 6371;

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        return EARTH_RADIUS_KM * c;
    }
}
