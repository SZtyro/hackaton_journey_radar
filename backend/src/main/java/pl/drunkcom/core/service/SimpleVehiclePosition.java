package pl.drunkcom.core.service;

/**
 * A simple record to hold processed vehicle position data from GTFS Real-Time feeds.
 * This immutable data class provides a clean way to pass vehicle positioning information
 * throughout the application.
 *
 * <p>Contains essential vehicle tracking information:
 * <ul>
 *   <li>vehicleId - Unique identifier for the transit vehicle</li>
 *   <li>tripId - Identifier for the current trip/route assignment</li>
 *   <li>latitude - GPS latitude coordinate</li>
 *   <li>longitude - GPS longitude coordinate</li>
 * </ul>
 *
 * @param vehicleId Unique identifier for the vehicle
 * @param tripId Current trip identifier
 * @param latitude GPS latitude coordinate
 * @param longitude GPS longitude coordinate
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
public record SimpleVehiclePosition(String vehicleId, String tripId, float latitude, float longitude) {

    /**
     * Validates that the vehicle position data is complete and valid.
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
