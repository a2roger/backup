


import java.net.URL;

// https://github.com/google/gtfs-realtime-bindings/blob/master/java/README.md
import com.google.transit.realtime.*;


void setup() {
  
  GtfsRealtime g;

  URL url = new URL("URL OF YOUR GTFS-REALTIME SOURCE GOES HERE");
  GtfsRealtime.FeedMessage feed = GtfsRealtime.FeedMessage.parseFrom(url.openStream());
  for (FeedEntity entity : feed.getEntityList()) {
    if (entity.hasTripUpdate()) {
      System.out.println(entity.getTripUpdate());
    }
  }
}