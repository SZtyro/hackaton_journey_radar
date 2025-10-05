package pl.drunkcom.core.service;

/**
 * A comprehensive record combining vehicle position and trip update data from GTFS Real-Time feeds.
 * This immutable data class provides a complete view of a vehicle's current state including
 * location, delay information, and operational status.
 *
 * <p>Contains complete vehicle state information:
 * <ul>
 *   <li>vehicleId - Unique identifier for the transit vehicle</li>
 *   <li>tripId - Identifier for the current trip/route assignment</li>
 *   <li>routeId - Identifier for the route</li>
 *   <li>latitude - GPS latitude coordinate</li>
 *   <li>longitude - GPS longitude coordinate</li>
 *   <li>delay - Delay in seconds (positive = late, negative = early, 0 = on time)</li>
 *   <li>scheduleRelationship - Relationship to the static schedule</li>
 *   <li>delayDescription - Human-readable delay description</li>
 * </ul>
 *
 * @param vehicleId Unique identifier for the vehicle
 * @param tripId Identifier for the trip
 * @param routeId Identifier for the route
 * @param latitude GPS latitude coordinate
 * @param longitude GPS longitude coordinate
 * @param delay Delay in seconds
 * @param scheduleRelationship Schedule relationship status
 * @param delayDescription Human-readable delay description
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
public record VehicleCurrentState(
    String vehicleId,
    String tripId,
    String routeId,
    float latitude,
    float longitude,
    int delay,
    String scheduleRelationship,
    String delayDescription
) {
    /**
     * Validates that the vehicle state data is complete and valid.
     *
     * @return true if all required fields are present and coordinates are valid
     */
    public boolean isValid() {
        return vehicleId != null && !vehicleId.trim().isEmpty()
                && tripId != null && !tripId.trim().isEmpty()
                && latitude >= -90.0f && latitude <= 90.0f
                && longitude >= -180.0f && longitude <= 180.0f;
    }

    /**
     * Checks if the vehicle is significantly delayed (more than 5 minutes).
     *
     * @return true if delay is greater than 5 minutes
     */
    public boolean isSignificantlyDelayed() {
        return getDelayInMinutes() > 5;
    }

    /**
     * Gets delay in minutes (rounded to nearest minute).
     * Delays under 30 seconds are considered "on time" (0 minutes).
     *
     * @return delay in minutes
     */
    public int getDelayInMinutes() {
        if (Math.abs(delay) < 30) {
            return 0;
        }
        return Math.round(delay / 60.0f);
    }

    /**
     * Returns a formatted string representation of the coordinates.
     *
     * @return coordinates in "lat,lng" format
     */
    public String getCoordinatesString() {
        return String.format("%.6f,%.6f", latitude, longitude);
    }

    /**
     * Creates a VehicleCurrentState from separate position and trip update data.
     *
     * @param position The vehicle position data
     * @param tripUpdate The trip update data (can be null if no delay info available)
     * @return Combined vehicle current state
     */
    public static VehicleCurrentState from(SimpleVehiclePosition position, SimpleTripUpdate tripUpdate) {
        if (tripUpdate != null) {
            return new VehicleCurrentState(
                position.vehicleId(),
                position.tripId(),
                tripUpdate.routeId(),
                position.latitude(),
                position.longitude(),
                tripUpdate.delay(),
                tripUpdate.scheduleRelationship(),
                tripUpdate.getDelayDescription()
            );
        } else {
            // No trip update data available, assume on time
            return new VehicleCurrentState(
                position.vehicleId(),
                position.tripId(),
                "", // No route info available
                position.latitude(),
                position.longitude(),
                0, // No delay info
                "UNKNOWN",
                "On time"
            );
        }
    }
}
