package pl.drunkcom.core.rest;

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
     * Get all entities
     *
     * @return list of entities
     */
    @GetMapping()
    @SuppressWarnings("unchecked")
    public ResponseEntity<T> getAll(@RequestParam Map<String, String> allParams) throws IOException {
        List<T> entities = this.service.getAll();
        return new ResponseEntity(entities, HttpStatus.OK);
    }

    /**
     * Get entity by id
     *
     * @param id entity id
     * @return found entity
     * @throws ResponseStatusException 404 if not found
     */
    @GetMapping("/{id}")
    public ResponseEntity<T> get(@PathVariable("id") Long id) throws ResponseStatusException, IOException {
        try{
            return new ResponseEntity<>(this.service.get(id), HttpStatus.OK);
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Document not found");
        }
    }

    /**
     * Create entity
     *
     * @param entity initial values
     * @return new created entity
     */
    @PostMapping()
    public ResponseEntity<T> create(@RequestBody(required = false) T entity) throws IOException {
        T e = createEntity(entity);
        return new ResponseEntity<>(this.service.save(e), HttpStatus.CREATED);
    }


    /**
     * Update entity
     *
     * @param id      id of entity to update
     * @param changes object containing changed values
     * @return updated entity
     */
    @PutMapping("/{id}")
    public ResponseEntity<T> update(@PathVariable("id") Long id, @RequestBody T changes) throws IOException {
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
     * Delete entity by id
     *
     * @param id entity id
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<T> delete(@PathVariable("id") Long id) {
       this.service.delete(id);
       return new ResponseEntity<>(HttpStatus.OK);
    }

    public void beforeUpdateEntity(T dbEntity, T changes) throws IOException {}
    public void afterUpdateEntity(T updatedEntity) throws IOException {}

    /**
     * Creates a new entity.
     *
     * @param init optional initial entity object.
     * @return created instance.
     */
    abstract public T createEntity(T init);

    @GetMapping("/enum/{path}")
    public List<Map<String, Object>> getEnum(@PathVariable("path") String path) throws ClassNotFoundException, NoSuchMethodException, InvocationTargetException, IllegalAccessException {

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