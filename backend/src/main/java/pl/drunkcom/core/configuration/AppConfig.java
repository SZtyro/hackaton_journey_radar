package pl.drunkcom.core.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * Application configuration class for beans and services.
 * Contains configuration for HTTP clients and other application-wide components.
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
@Configuration
public class AppConfig {

    /**
     * Creates a RestTemplate bean for HTTP communication.
     * Used by services to make HTTP requests to external APIs like GTFS-RT feeds.
     *
     * @return configured RestTemplate instance
     */
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
