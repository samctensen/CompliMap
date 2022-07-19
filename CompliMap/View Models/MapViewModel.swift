//
//  MapViewModel.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    @Published var user: User
    
    var locationManager: CLLocationManager?
    
    init(user: User) {
        self.user = user
    }
    
    func checkLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
        }
        else {
            print("fuck")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }

        switch locationManager.authorizationStatus {
            
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
            case .restricted:
                print("location is restricted from parental controls")
            case .denied:
                print("Change CompliMap's location permissions in Settings")
            case .authorizedAlways, .authorizedWhenInUse:
                if locationManager.location != nil {
                    region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
                }
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
