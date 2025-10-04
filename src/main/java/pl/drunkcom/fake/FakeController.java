package pl.drunkcom.fake;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import pl.drunkcom.core.rest.BaseController;

@Controller
@RequestMapping("/api/fake")
public class FakeController extends BaseController<FakeModel, FakeRepository> {

    public FakeController() {
        super(FakeController.class, FakeModel.class);
    }

    @Override
    public FakeModel createEntity(FakeModel init) {
        return init != null ? init : new FakeModel();
    }
}
