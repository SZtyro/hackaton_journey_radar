package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pl.drunkcom.core.service.BaseGtfsService;

import java.util.List;
import java.util.Optional;

/**
 * Base controller providing common CRUD operations for all GTFS entities.
 * This abstract controller implements standard REST endpoints that are inherited by all specific GTFS controllers.
 *
 * <p>Provides the following standard operations:
 * <ul>
 *   <li>GET all entities (with optional pagination)</li>
 *   <li>GET entity by ID</li>
 *   <li>POST create new entity</li>
 *   <li>PUT update existing entity</li>
 *   <li>DELETE entity by ID</li>
 *   <li>GET count of all entities</li>
 * </ul>
 *
 * @param <T> The GTFS entity type
 * @param <ID> The entity identifier type
 * @param <S> The service type extending BaseGtfsService
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
public abstract class BaseGtfsController<T, ID, S extends BaseGtfsService<T, ID, ?>> {

    @Autowired
    protected S service;

    /**
     * Retrieves all entities from the system.
     * Returns a complete list of all entities of the specific GTFS type.
     *
     * @return ResponseEntity containing list of all entities
     */
    @GetMapping
    @Operation(
        summary = "Get all entities",
        description = "Retrieves a complete list of all entities of this GTFS type. " +
                     "Use pagination endpoint for large datasets to improve performance."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved all entities",
            content = @Content(schema = @Schema(implementation = Object.class))
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error occurred while fetching entities"
        )
    })
    public ResponseEntity<List<T>> getAll() {
        List<T> entities = service.findAll();
        return ResponseEntity.ok(entities);
    }

    /**
     * Retrieves entities with pagination support.
     * Provides efficient access to large datasets by returning results in pages.
     *
     * @param pageable Pagination parameters (page number, size, sorting)
     * @return ResponseEntity containing paginated results with metadata
     */
    @GetMapping("/page")
    @Operation(
        summary = "Get entities with pagination",
        description = "Retrieves entities with pagination support. Includes page metadata such as total elements, " +
                     "total pages, and current page information. Supports sorting and custom page sizes."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved paginated entities",
            content = @Content(schema = @Schema(implementation = Page.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid pagination parameters provided"
        )
    })
    public ResponseEntity<Page<T>> getAllPaged(
        @Parameter(description = "Pagination parameters including page number, size, and sort criteria")
        Pageable pageable
    ) {
        Page<T> entities = service.findAll(pageable);
        return ResponseEntity.ok(entities);
    }

    /**
     * Finds a specific entity by its unique identifier.
     *
     * @param id The unique identifier of the entity
     * @return ResponseEntity containing the entity if found, or 404 if not found
     */
    @GetMapping("/{id}")
    @Operation(
        summary = "Get entity by ID",
        description = "Retrieves a specific GTFS entity using its unique identifier. " +
                     "Returns detailed information for a single entity."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Entity found and returned successfully",
            content = @Content(schema = @Schema(implementation = Object.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Entity with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid ID format provided"
        )
    })
    public ResponseEntity<T> getById(
        @Parameter(description = "Unique identifier of the entity", example = "1")
        @PathVariable ID id
    ) {
        Optional<T> entity = service.findById(id);
        return entity.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Creates a new entity in the system.
     * Validates and persists a new GTFS entity according to the GTFS specification.
     *
     * @param entity The entity data to create
     * @return ResponseEntity containing the created entity with generated ID
     */
    @PostMapping
    @Operation(
        summary = "Create new entity",
        description = "Creates a new GTFS entity in the system. The entity will be validated according to " +
                     "GTFS specifications before being persisted. Returns the created entity with generated identifier."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "201",
            description = "Entity created successfully",
            content = @Content(schema = @Schema(implementation = Object.class))
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid entity data provided or validation failed"
        ),
        @ApiResponse(
            responseCode = "409",
            description = "Entity with this identifier already exists"
        )
    })
    public ResponseEntity<T> create(
        @Parameter(description = "Entity data to create")
        @RequestBody T entity
    ) {
        T savedEntity = service.save(entity);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedEntity);
    }

    /**
     * Updates an existing entity in the system.
     * Replaces the existing entity data with the provided data.
     *
     * @param id The unique identifier of the entity to update
     * @param entity The updated entity data
     * @return ResponseEntity containing the updated entity, or 404 if entity not found
     */
    @PutMapping("/{id}")
    @Operation(
        summary = "Update existing entity",
        description = "Updates an existing GTFS entity with new data. The entire entity will be replaced " +
                     "with the provided data. Entity must exist or a 404 error will be returned."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Entity updated successfully",
            content = @Content(schema = @Schema(implementation = Object.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Entity with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid entity data provided or validation failed"
        )
    })
    public ResponseEntity<T> update(
        @Parameter(description = "Unique identifier of the entity to update")
        @PathVariable ID id,
        @Parameter(description = "Updated entity data")
        @RequestBody T entity
    ) {
        if (!service.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        T savedEntity = service.save(entity);
        return ResponseEntity.ok(savedEntity);
    }

    /**
     * Deletes an entity from the system.
     * Permanently removes the specified entity and all its associated data.
     *
     * @param id The unique identifier of the entity to delete
     * @return ResponseEntity with no content if successful, or 404 if entity not found
     */
    @DeleteMapping("/{id}")
    @Operation(
        summary = "Delete entity",
        description = "Permanently deletes a GTFS entity from the system. This operation cannot be undone. " +
                     "All references to this entity will be affected."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "204",
            description = "Entity deleted successfully"
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Entity with specified ID not found"
        ),
        @ApiResponse(
            responseCode = "409",
            description = "Entity cannot be deleted due to existing references"
        )
    })
    public ResponseEntity<Void> delete(
        @Parameter(description = "Unique identifier of the entity to delete")
        @PathVariable ID id
    ) {
        if (!service.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        service.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Returns the total count of entities in the system.
     * Provides a quick way to get the total number of entities without retrieving all data.
     *
     * @return ResponseEntity containing the total count of entities
     */
    @GetMapping("/count")
    @Operation(
        summary = "Get entity count",
        description = "Returns the total number of entities of this type in the system. " +
                     "Useful for pagination calculations and system monitoring."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved entity count",
            content = @Content(schema = @Schema(implementation = Long.class))
        )
    })
    public ResponseEntity<Long> count() {
        long count = service.count();
        return ResponseEntity.ok(count);
    }
}
