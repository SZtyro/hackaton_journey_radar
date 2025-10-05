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
     * Returns a human-readable delay description rounded to full minutes.
     * Shows "On time" for delays under 30 seconds, otherwise rounds to nearest minute.
     *
     * @return delay description in minutes only
     */
    public String getDelayDescription() {
        int delayInMinutes = getDelayInMinutes();

        if (delayInMinutes == 0) {
            return "On time";
        } else if (delayInMinutes > 0) {
            return delayInMinutes + " min delayed";
        } else {
            return Math.abs(delayInMinutes) + " min early";
        }
    }

    /**
     * Checks if the trip is significantly delayed (more than 5 minutes).
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
        // Round to nearest minute, but treat delays under 30 seconds as "on time"
        if (Math.abs(delay) < 30) {
            return 0;
        }
        return Math.round(delay / 60.0f);
    }
}
