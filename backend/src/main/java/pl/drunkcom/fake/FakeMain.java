package pl.drunkcom.fake;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = {"pl.drunkcom"})
@EnableJpaRepositories({"pl.drunkcom.fake"})
@EntityScan({"pl.drunkcom.fake"})
@ComponentScan({"pl.drunkcom"})
@AutoConfiguration
public class FakeMain {

    public static void main(String[] args) {
        SpringApplication.run(FakeMain.class, args);
    }
}
