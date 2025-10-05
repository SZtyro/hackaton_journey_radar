package pl.drunkcom.core.service;

/**
 * A simplified record representing real-time trip update data from GTFS Real-Time feeds.
 * This immutable data class contains delay and schedule information for transit trips.
 *
 * <p>Contains trip update information:
 * <ul>
 *   <li>tripId - Identifier for the trip</li>
 *   <li>routeId - Identifier for the route</li>
 *   <li>vehicleId - Associated vehicle identifier (optional)</li>
 *   <li>delay - Delay in seconds (positive = late, negative = early, 0 = on time)</li>
 *   <li>scheduleRelationship - Relationship to the static schedule</li>
 * </ul>
 *
 * @param tripId Identifier for the trip
 * @param routeId Identifier for the route
 * @param vehicleId Associated vehicle identifier (can be null)
 * @param delay Delay in seconds
 * @param scheduleRelationship Schedule relationship status
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
public record SimpleTripUpdate(
    String tripId,
    String routeId,
    String vehicleId,
    int delay,
    String scheduleRelationship
) {
    /**
     * Validates that the trip update data is complete.
     *
     * @return true if required fields are present
     */
    public boolean isValid() {
        return tripId != null && !tripId.trim().isEmpty()
                && scheduleRelationship != null && !scheduleRelationship.trim().isEmpty();
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
        if (Math.abs(delay) < 30) {
            return 0;
        }
        return Math.round(delay / 60.0f);
    }

    /**
     * Returns a human-readable description of the delay.
     *
     * @return delay description string
     */
    public String getDelayDescription() {
        int delayMinutes = getDelayInMinutes();

        if (delayMinutes == 0) {
            return "On time";
        } else if (delayMinutes > 0) {
            return delayMinutes == 1 ? "1 min late" : delayMinutes + " mins late";
        } else {
            return Math.abs(delayMinutes) == 1 ? "1 min early" : Math.abs(delayMinutes) + " mins early";
        }
    }
}
