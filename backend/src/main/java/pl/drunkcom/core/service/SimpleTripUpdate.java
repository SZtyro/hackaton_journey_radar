package pl.drunkcom.core.service;

/**
 * A simple record to hold processed trip update data from GTFS Real-Time feeds.
 * This immutable data class provides a clean way to pass trip delay and update information
 * throughout the application.
 *
 * <p>Contains essential trip update information:
 * <ul>
 *   <li>tripId - Identifier for the trip/route assignment</li>
 *   <li>routeId - Identifier for the route</li>
 *   <li>vehicleId - Unique identifier for the transit vehicle (if available)</li>
 *   <li>delay - Delay in seconds (positive = late, negative = early, 0 = on time)</li>
 *   <li>scheduleRelationship - Relationship to the static schedule</li>
 * </ul>
 *
 * @param tripId Identifier for the trip
 * @param routeId Identifier for the route
 * @param vehicleId Unique identifier for the vehicle (can be null)
 * @param delay Delay in seconds
 * @param scheduleRelationship Schedule relationship status
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
public record SimpleTripUpdate(String tripId, String routeId, String vehicleId, int delay, String scheduleRelationship) {

    /**
     * Validates that the trip update data is complete and valid.
     *
     * @return true if all required fields are present
     */
    public boolean isValid() {
        return tripId != null && !tripId.trim().isEmpty()
                && routeId != null && !routeId.trim().isEmpty();
    }

    /**
     * Returns a human-readable delay description.
     *
     * @return delay description in minutes and seconds
     */
    public String getDelayDescription() {
        if (delay == 0) {
            return "On time";
        } else if (delay > 0) {
            int minutes = delay / 60;
            int seconds = delay % 60;
            return String.format("%d min %d sec late", minutes, seconds);
        } else {
            int minutes = Math.abs(delay) / 60;
            int seconds = Math.abs(delay) % 60;
            return String.format("%d min %d sec early", minutes, seconds);
        }
    }

    /**
     * Checks if the trip is significantly delayed (more than 5 minutes).
     *
     * @return true if delay is greater than 5 minutes
     */
    public boolean isSignificantlyDelayed() {
        return delay > 300; // 5 minutes in seconds
    }

    /**
     * Gets delay in minutes (rounded).
     *
     * @return delay in minutes
     */
    public int getDelayInMinutes() {
        return Math.round(delay / 60.0f);
    }
}
