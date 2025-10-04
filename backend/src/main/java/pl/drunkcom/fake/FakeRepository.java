package pl.drunkcom.fake;

import org.springframework.stereotype.Repository;
import pl.drunkcom.core.interfaces.BaseRepository;

@Repository
public interface FakeRepository extends BaseRepository<FakeModel> {
}
