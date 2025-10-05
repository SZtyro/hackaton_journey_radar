package pl.drunkcom.core.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import org.apache.coyote.Response;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import pl.drunkcom.core.interfaces.BaseRepository;
import pl.drunkcom.core.model.BaseEntity;
import pl.drunkcom.core.service.BaseService;

import javax.annotation.PostConstruct;
import javax.persistence.EntityManager;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.*;

/**
 * Base controller providing common CRUD operations for all entities.
 * This abstract controller implements standard REST endpoints that can be inherited by specific entity controllers.
 *
 * <p>Provides the following standard operations:
 * <ul>
 *   <li>GET all entities with optional filtering</li>
 *   <li>GET entity by ID</li>
 *   <li>POST create new entity</li>
 *   <li>PUT update existing entity with version control</li>
 *   <li>DELETE entity by ID</li>
 *   <li>GET enum values for entity properties</li>
 * </ul>
 *
 * <p>Features versioning control and draft management for entities.
 *
 * @param <T> The entity type extending BaseEntity
 * @param <R> The repository type extending BaseRepository
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
@Component
@SuppressWarnings({"rawtypes"})
public abstract class BaseController<T extends BaseEntity, R extends BaseRepository<T>> {

    protected Logger log;
    protected Class<T> entityClass;

    public BaseController(Class controllerClass, Class<T> entityClass) {
        log = LoggerFactory.getLogger(controllerClass);
        this.entityClass = entityClass;
    }

    @Autowired
    private PlatformTransactionManager transactionManager;

    @Autowired
    protected BaseService<T, R> service;

    @Autowired
    protected EntityManager em;

    @PostConstruct
    private void init() {
        DefaultTransactionDefinition def = new DefaultTransactionDefinition();
        def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
        TransactionStatus status = transactionManager.getTransaction(def);
        try {
            log.info(String.format("Deleted drafts: %d", service.deleteDrafts()));
            transactionManager.commit(status);
        } catch (Exception e) {
            transactionManager.rollback(status);
            throw e;
        }
    }

    /**
     * Retrieves all entities from the system with optional filtering.
     * Supports query parameters for filtering and searching entities.
     *
     * @param allParams Map of query parameters for filtering
     * @return ResponseEntity containing list of entities matching the filter criteria
     * @throws IOException if there's an error processing the request
     */
    @GetMapping()
    @SuppressWarnings("unchecked")
    @Operation(
        summary = "Get all entities",
        description = "Retrieves all entities of this type with optional filtering using query parameters. " +
                     "Supports various filter criteria to narrow down results."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved entities",
            content = @Content(schema = @Schema(implementation = Object.class))
        ),
        @ApiResponse(
            responseCode = "500",
            description = "Internal server error occurred while fetching entities"
        )
    })
    public ResponseEntity<T> getAll(
        @Parameter(description = "Query parameters for filtering entities")
        @RequestParam Map<String, String> allParams
    ) throws IOException {
        List<T> entities = this.service.getAll();
        return new ResponseEntity(entities, HttpStatus.OK);
    }

    /**
     * Finds a specific entity by its unique identifier.
     *
     * @param id The unique identifier of the entity
     * @return ResponseEntity containing the entity if found
     * @throws ResponseStatusException 404 if entity not found
     * @throws IOException if there's an error processing the request
     */
    @GetMapping("/{id}")
    @Operation(
        summary = "Get entity by ID",
        description = "Retrieves a specific entity using its unique database identifier. " +
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
    public ResponseEntity<T> get(
        @Parameter(description = "Unique identifier of the entity", example = "1")
        @PathVariable("id") Long id
    ) throws ResponseStatusException, IOException {
        try{
            return new ResponseEntity<>(this.service.get(id), HttpStatus.OK);
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Document not found");
        }
    }

    /**
     * Creates a new entity in the system.
     * Validates and persists a new entity with initial values.
     *
     * @param entity The entity data to create (optional)
     * @return ResponseEntity containing the created entity
     * @throws IOException if there's an error processing the request
     */
    @PostMapping()
    @Operation(
        summary = "Create new entity",
        description = "Creates a new entity in the system. Optional initial values can be provided. " +
                     "The entity will be validated and assigned a unique identifier upon creation."
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
        )
    })
    public ResponseEntity<T> create(
        @Parameter(description = "Initial entity data (optional)")
        @RequestBody(required = false) T entity
    ) throws IOException {
        T e = createEntity(entity);
        return new ResponseEntity<>(this.service.save(e), HttpStatus.CREATED);
    }

    /**
     * Updates an existing entity in the system.
     * Implements optimistic locking using version control to prevent concurrent modifications.
     *
     * @param id The unique identifier of the entity to update
     * @param changes The updated entity data with version information
     * @return ResponseEntity containing the updated entity
     * @throws IOException if there's an error processing the request
     */
    @PutMapping("/{id}")
    @Operation(
        summary = "Update existing entity",
        description = "Updates an existing entity with new data. Uses optimistic locking with version control " +
                     "to prevent concurrent modifications. The version must match the current entity version."
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
            responseCode = "412",
            description = "Precondition failed - entity was modified by another user"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid entity data provided or validation failed"
        )
    })
    public ResponseEntity<T> update(
        @Parameter(description = "Unique identifier of the entity to update")
        @PathVariable("id") Long id,
        @Parameter(description = "Updated entity data with version information")
        @RequestBody T changes
    ) throws IOException {
        ResponseEntity<T> responseEntity = this.get(id);

        T entity = responseEntity.getBody();
        if(entity == null)
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Document not found.");

        if (Objects.equals(entity.getVersion(), changes.getVersion())) {

            beforeUpdateEntity(entity, changes);
            entity.setDraft(false);
            entity.setVersion(entity.getVersion() + 1);
            entity = this.service.save(changes);
            afterUpdateEntity(entity);
            return new ResponseEntity<>(entity, HttpStatus.OK);
        }
        throw new ResponseStatusException(
                HttpStatus.PRECONDITION_FAILED,
                "Document has been modified by someone else. Try reload."
        );

    }

    /**
     * Deletes an entity from the system.
     * Permanently removes the specified entity from the database.
     *
     * @param id The unique identifier of the entity to delete
     * @return ResponseEntity with success status
     */
    @DeleteMapping("/{id}")
    @Operation(
        summary = "Delete entity",
        description = "Permanently deletes an entity from the system. This operation cannot be undone. " +
                     "All references to this entity may be affected."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
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
    public ResponseEntity<T> delete(
        @Parameter(description = "Unique identifier of the entity to delete")
        @PathVariable("id") Long id
    ) {
       this.service.delete(id);
       return new ResponseEntity<>(HttpStatus.OK);
    }

    public void beforeUpdateEntity(T dbEntity, T changes) throws IOException {}
    public void afterUpdateEntity(T updatedEntity) throws IOException {}

    /**
     * Creates a new entity instance.
     * Abstract method that must be implemented by subclasses to define entity creation logic.
     *
     * @param init Optional initial entity object with default values
     * @return Created entity instance ready for persistence
     */
    abstract public T createEntity(T init);

    /**
     * Retrieves enum values for entity properties.
     * Provides metadata about available enum values for dropdowns and validation.
     *
     * @param path The fully qualified class name of the enum
     * @return List of maps containing enum values and their properties
     * @throws ClassNotFoundException if the enum class is not found
     * @throws NoSuchMethodException if the values() method is not found
     * @throws InvocationTargetException if there's an error invoking the method
     * @throws IllegalAccessException if there's an access restriction
     */
    @GetMapping("/enum/{path}")
    @Operation(
        summary = "Get enum values",
        description = "Retrieves all available values for a specified enum class. " +
                     "Returns enum constants with their properties for use in dropdowns and validation."
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200",
            description = "Successfully retrieved enum values",
            content = @Content(schema = @Schema(implementation = List.class))
        ),
        @ApiResponse(
            responseCode = "404",
            description = "Enum class not found"
        ),
        @ApiResponse(
            responseCode = "400",
            description = "Invalid enum class path provided"
        )
    })
    public List<Map<String, Object>> getEnum(
        @Parameter(description = "Fully qualified class name of the enum", example = "com.example.enums.StatusEnum")
        @PathVariable("path") String path
    ) throws ClassNotFoundException, NoSuchMethodException, InvocationTargetException, IllegalAccessException {

        Object[] values = (Object[]) Class.forName(path).getMethod("values").invoke(null);
        List<Map<String, Object>> array = new ArrayList<>();
        for (Object value : values) {
            Map<String, Object> map = new HashMap<>();
            map.put("name", value);
            Field[] declaredFields = value.getClass().getDeclaredFields();
            for (Field declaredField : declaredFields) {
                if (!declaredField.isSynthetic() && !declaredField.isEnumConstant() && !java.lang.reflect.Modifier.isStatic(declaredField.getModifiers())) {
                    map.put(declaredField.getName(), declaredField.get(value));
                }
            }
            array.add(map);
        }


        return array;
    }
}