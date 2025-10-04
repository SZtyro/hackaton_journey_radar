package pl.drunkcom.core.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;
import java.util.Optional;

public abstract class BaseGtfsService<T, ID, R extends JpaRepository<T, ID> & JpaSpecificationExecutor<T>> {

    @Autowired
    protected R repository;

    public T save(T entity) {
        return repository.save(entity);
    }

    public List<T> saveAll(List<T> entities) {
        return repository.saveAll(entities);
    }

    public Optional<T> findById(ID id) {
        return repository.findById(id);
    }

    public T getById(ID id) {
        return repository.findById(id).orElseThrow(() ->
            new RuntimeException("Entity not found with id: " + id));
    }

    public List<T> findAll() {
        return repository.findAll();
    }

    public Page<T> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    public Page<T> findAll(Specification<T> specification, Pageable pageable) {
        return repository.findAll(specification, pageable);
    }

    public List<T> findAll(Specification<T> specification) {
        return repository.findAll(specification);
    }

    public boolean existsById(ID id) {
        return repository.existsById(id);
    }

    public long count() {
        return repository.count();
    }

    public long count(Specification<T> specification) {
        return repository.count(specification);
    }

    public void deleteById(ID id) {
        repository.deleteById(id);
    }

    public void delete(T entity) {
        repository.delete(entity);
    }

    public void deleteAll() {
        repository.deleteAll();
    }

    public void deleteAll(List<T> entities) {
        repository.deleteAll(entities);
    }
}
