package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

/**
 * Generic wrapper class for filtered API results with pagination information.
 * Used to return filtered data along with total count metadata for pagination purposes.
 *
 * <p>This class encapsulates filtered query results and provides count information
 * that enables clients to implement proper pagination controls and display total result counts.
 *
 * @param <T> The type of entities contained in the results
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
@Schema(description = "Wrapper for filtered results containing data and pagination metadata")
public class FilteredResult<T> {

    @Schema(description = "List of filtered entities matching the query criteria")
    private List<T> results;

    @Schema(description = "Total count of entities matching the filter criteria (before pagination)", example = "150")
    private Long totalCount;

    /**
     * Constructs a FilteredResult with results and total count.
     *
     * @param results The list of filtered entities
     * @param totalCount The total number of entities matching the filter criteria
     */
    public FilteredResult(List<T> results, Long totalCount) {
        this.results = results;
        this.totalCount = totalCount;
    }

    /**
     * Gets the filtered results.
     *
     * @return List of entities matching the filter criteria
     */
    public List<T> getResults() {
        return results;
    }

    /**
     * Sets the filtered results.
     *
     * @param results List of entities to set as results
     */
    public void setResults(List<T> results) {
        this.results = results;
    }

    /**
     * Gets the total count of entities matching the filter criteria.
     *
     * @return Total count of entities (before pagination)
     */
    public Long getTotalCount() {
        return totalCount;
    }

    /**
     * Sets the total count of entities.
     *
     * @param totalCount Total count of entities matching the criteria
     */
    public void setTotalCount(Long totalCount) {
        this.totalCount = totalCount;
    }
}
