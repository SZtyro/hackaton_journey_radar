package pl.drunkcom.core.service;

import com.sun.istack.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.drunkcom.core.interfaces.BaseRepository;
import pl.drunkcom.core.model.BaseEntity;

import java.util.List;

@Service
public abstract class BaseService<T extends BaseEntity, R extends BaseRepository<T>>{

    @Autowired
    private R repository;

    public T get(@NotNull Long id){
        return repository.findById(id).orElseThrow();
    }

    public List<T> getAll(){
        return repository.findAll();
    }

    public T save(@NotNull T entity){
        return repository.save(entity);
    }

    public long deleteDrafts(){
        return repository.deleteByDraft(true);
    }

    public void delete(Long id) {
        this.repository.deleteById(id);
    }
}
