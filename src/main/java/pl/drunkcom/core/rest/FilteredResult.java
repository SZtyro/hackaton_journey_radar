package pl.drunkcom.core.rest;

import java.util.List;

public class FilteredResult<T> {
    private List<T> results;
    private Long totalCount;

    public FilteredResult(List<T> results, Long totalCount) {
        this.results = results;
        this.totalCount = totalCount;
    }

    public List<T> getResults() {
        return results;
    }

    public void setResults(List<T> results) {
        this.results = results;
    }

    public Long getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(Long totalCount) {
        this.totalCount = totalCount;
    }
}
