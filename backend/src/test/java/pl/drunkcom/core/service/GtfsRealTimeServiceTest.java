package pl.drunkcom.core.service;

import com.google.transit.realtime.GtfsRealtime.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.client.RestTemplate;

import java.io.IOException;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class GtfsRealTimeServiceTest {

    @Mock
    private RestTemplate restTemplate;

    @InjectMocks
    private GtfsRealTimeService gtfsService;

    @Test
    void fetchVehiclePositions_shouldParseDataCorrectly() throws IOException {
        // 1. ARRANGE: Create a fake binary response to simulate the .pb file

        // FIX: The GTFS-RT spec requires a header. Let's build one.
        FeedHeader fakeHeader = FeedHeader.newBuilder()
                .setGtfsRealtimeVersion("2.0") // This is a required field in the spec
                .setTimestamp(System.currentTimeMillis() / 1000L) // Set a current timestamp
                .build();

        // Now, build the full message, including the required header
        FeedMessage fakeFeedMessage = FeedMessage.newBuilder()
                .setHeader(fakeHeader) // <-- Add the header to the message
                .addEntity(FeedEntity.newBuilder()
                        .setId("vehicle-1")
                        .setVehicle(VehiclePosition.newBuilder()
                                .setVehicle(VehicleDescriptor.newBuilder().setId("test-bus-01"))
                                .setTrip(TripDescriptor.newBuilder().setTripId("trip-abc"))
                                .setPosition(Position.newBuilder().setLatitude(50.0f).setLongitude(20.0f))
                        )
                ).build(); // Now this build() will succeed

        byte[] fakePbData = fakeFeedMessage.toByteArray();

        // 2. ARRANGE: Tell the fake RestTemplate to return our fake data when called
        when(restTemplate.getForObject(anyString(), eq(byte[].class))).thenReturn(fakePbData);

        // 3. ACT: Call the actual method we want to test
        List<SimpleVehiclePosition> positions = gtfsService.fetchVehiclePositions();

        // 4. ASSERT: Check that the method behaved as expected
        assertNotNull(positions);
        assertEquals(1, positions.size());

        SimpleVehiclePosition firstPosition = positions.get(0);
        assertEquals("test-bus-01", firstPosition.vehicleId());
        assertEquals("trip-abc", firstPosition.tripId());
        assertEquals(50.0f, firstPosition.latitude());
        assertEquals(20.0f, firstPosition.longitude());
    }
}