//
//  MapViewModel.swift
//  CompliMap
//
//  Created by Sam Christensen on 7/18/22.
//

import MapKit
import Firebase
import FirebaseFirestore

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var user: User
    @Published var region = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    public var latitude: Double
    public var longitude: Double
    
    var locationManager: CLLocationManager?
    
    var userLocationsRef = Firestore.firestore().collection("userLocationData")
    
    init(user: User) {
        self.user = user
        latitude = 0
        longitude = 0
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
                locationManager.startMonitoringSignificantLocationChanges()
                locationManager.allowsBackgroundLocationUpdates = true
                if locationManager.location != nil {
                    region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.defaultSpan)
                    latitude = locationManager.location!.coordinate.latitude
                    longitude = locationManager.location!.coordinate.longitude
                    let userLocationData = UserLocationData(user: user, latitude: latitude, longitude: longitude, timestamp: Date.now)
                    let document = userLocationsRef.document(userLocationData.id.uuidString)
                    do {
                        try document.setData(from: userLocationData)
                    }
                    catch {
                        
                    }
                }
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last ?? CLLocation(latitude: latitude, longitude: longitude)
        if location.coordinate.latitude != latitude && location.coordinate.longitude != longitude {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            let userLocationData = UserLocationData(user: user, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: Date.now)
            let document = userLocationsRef.document(userLocationData.id.uuidString)
            do {
                try document.setData(from: userLocationData)
            }
            catch {
                
            }
        }
    }
}
