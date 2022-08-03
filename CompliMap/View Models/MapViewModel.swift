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
    public var userLocationsRef: CollectionReference
    
    var locationManager: CLLocationManager?
    
    
    
    init(user: User) {
        self.user = user
        latitude = 0
        longitude = 0
        userLocationsRef = Firestore.firestore().collection("userLocationData").document(user.id).collection("pins")
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
                    if checkTimeDifference() {
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
                }
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func checkTimeDifference() -> Bool {
        var isTime: Bool = true
        let query = userLocationsRef.order(by: "timestamp", descending: true).limit(to: 1)
        query.getDocuments { snapshot, error in
            guard error == nil else {
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let locationData = document.data()
                    let timestamp = locationData["timestamp"] as? Timestamp ?? Timestamp()
                    let epochSeconds = timestamp.seconds
                    let pinDate = Date(timeIntervalSince1970: TimeInterval(epochSeconds))
                    let minuteDifference = Calendar.current.dateComponents([.minute], from: pinDate, to: Date.now).minute ?? 11
                    if minuteDifference > 10 {
                        isTime = true
                    }
                    else {
                        isTime = false
                    }
                }
            }
        }
        return isTime
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if checkTimeDifference() {
            let location: CLLocation = locations.last ?? CLLocation(latitude: latitude, longitude: longitude)
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            let userLocationData = UserLocationData(user: self.user, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, timestamp: Date.now)
            let document = self.userLocationsRef.document(userLocationData.id.uuidString)
            do {
                try document.setData(from: userLocationData)
            }
            catch {
                
            }
        }
    }
}
