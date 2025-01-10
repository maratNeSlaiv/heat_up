import SwiftUI
import MapKit

struct MapView: View {
    let manager = CLLocationManager()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        Map(position: $position){
            UserAnnotation()
        }
        .mapControls{
            MapUserLocationButton()
            MapPitchToggle()
        }
        .onAppear{
            manager.requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    MapView()
}
