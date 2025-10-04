package pl.drunkcom.core.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.NoRepositoryBean;
import pl.drunkcom.core.model.BaseEntity;

@NoRepositoryBean
public interface BaseRepository<T extends BaseEntity> extends  JpaRepository<T, Long>, JpaSpecificationExecutor<T>  {
    long deleteByDraft(boolean draft);
}
