package pl.drunkcom.core.service;

/**
 * A simplified record representing real-time vehicle position data from GTFS Real-Time feeds.
 * This immutable data class contains the essential location information for a transit vehicle.
 *
 * <p>Contains vehicle position information:
 * <ul>
 *   <li>vehicleId - Unique identifier for the transit vehicle</li>
 *   <li>tripId - Identifier for the current trip/route assignment</li>
 *   <li>latitude - GPS latitude coordinate</li>
 *   <li>longitude - GPS longitude coordinate</li>
 * </ul>
 *
 * @param vehicleId Unique identifier for the vehicle
 * @param tripId Identifier for the trip
 * @param latitude GPS latitude coordinate
 * @param longitude GPS longitude coordinate
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
public record SimpleVehiclePosition(
    String vehicleId,
    String tripId,
    float latitude,
    float longitude
) {
    /**
     * Validates that the position data is complete and coordinates are valid.
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
     * Returns a formatted string representation of the coordinates.
     *
     * @return coordinates in "lat,lng" format
     */
    public String getCoordinatesString() {
        return String.format("%.6f,%.6f", latitude, longitude);
    }
}
