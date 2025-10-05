package pl.drunkcom.core.configuration;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.context.annotation.Configuration;

/**
 * OpenAPI configuration for GTFS Transit Management API.
 * Configures Swagger documentation with project information and API details.
 *
 * <p>This configuration provides comprehensive API documentation for all GTFS endpoints
 * including transit agencies, routes, stops, trips, schedules, and real-time information.
 * The API follows GTFS specification standards for maximum compatibility.
 *
 * @author Development Team
 * @version 1.0
 * @since 1.0
 */
@Configuration
@OpenAPIDefinition(
    info = @Info(
        title = "Journey Radar - GTFS Transit Management API",
        version = "1.0.0",
        description = """
            **Journey Radar GTFS API** - A comprehensive REST API for managing GTFS (General Transit Feed Specification) data.
            
            This API provides complete access to transit schedules, stops, routes, real-time information, and all GTFS standard entities.
            Perfect for integration with:
            - Transit planning applications
            - Passenger information systems  
            - Route optimization tools
            - Mobile transit apps
            - Real-time tracking systems
            
            **Key Features:**
            - Full GTFS specification compliance
            - Real-time data support
            - Geographic search capabilities
            - Accessibility information
            - Comprehensive filtering options
            - Pagination support for large datasets
            
            **API Endpoints are organized by GTFS entity types:**
            - **Agencies** - Transit operators and service providers
            - **Routes** - Transit lines and services
            - **Stops** - Physical boarding locations
            - **Trips** - Individual vehicle journeys
            - **Stop Times** - Scheduled arrival/departure times
            - **Calendar** - Service period definitions
            - **Shapes** - Geographic route paths
            - **Blocks** - Vehicle duty cycles
            
            For more information about GTFS specification, visit: https://gtfs.org/
            """,
        contact = @Contact(
            name = "Journey Radar Development Team",
            email = "dev@journeyradar.com",
            url = "https://github.com/drunkcom/journey-radar"
        ),
        license = @License(
            name = "MIT License",
            url = "https://opensource.org/licenses/MIT"
        )
    ),
    servers = {
        @Server(
            url = "http://localhost:8080",
            description = "Local Development Server"
        ),
        @Server(
            url = "https://api.journeyradar.com",
            description = "Production Server"
        )
    },
    tags = {
        @Tag(
            name = "Agencies",
            description = "Transit operators and service providers. Manage agency information including names, URLs, timezones, and contact details."
        ),
        @Tag(
            name = "Routes",
            description = "Transit routes and lines. Handle route information including names, types, colors, and agency associations."
        ),
        @Tag(
            name = "Stops",
            description = "Physical transit stops and stations. Manage stop locations, accessibility, and geographic information."
        ),
        @Tag(
            name = "Trips",
            description = "Individual vehicle journeys along routes. Handle trip schedules, directions, and service patterns."
        ),
        @Tag(
            name = "Stop Times",
            description = "Scheduled arrival and departure times. Core schedule data for real-time tracking and passenger information."
        ),
        @Tag(
            name = "Calendar",
            description = "Service period definitions. Define when transit services operate using weekly patterns and date ranges."
        ),
        @Tag(
            name = "Calendar Dates",
            description = "Service exceptions and special dates. Handle holidays, service disruptions, and schedule exceptions."
        ),
        @Tag(
            name = "Shapes",
            description = "Geographic route paths and geometries. Define the actual travel paths of vehicles along routes."
        ),
        @Tag(
            name = "Blocks",
            description = "Vehicle duty cycles and operational blocks. Group sequential trips operated by the same vehicle."
        )
    }
)
public class OpenApiConfig {
}
