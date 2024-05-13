//
//  LocationManager.swift
//  Muhammad_Weather
//
//  Created by MUS on 2020-11-17.
//

import Foundation
import CoreLocation
import Contacts
import MapKit

class LocationManager: NSObject, ObservableObject{
    @Published var address : String = ""
    @Published var lat: Double = 0.0
    @Published var lon: Double = 0.0
    //@ObservedObject var weatherViewModel : WeatherViewModel
    
    private let manager = CLLocationManager()
    private var lastKnownLocation: CLLocationCoordinate2D?
    private let regionRadius: CLLocationDistance = 300
    
    override init() {
        super.init()
        //weatherViewModel =
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        
        self.start()
    }
    
    func start(){
        manager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            manager.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .authorizedAlways:
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.lastKnownLocation = locations.first?.coordinate
        
        if locations.last != nil{
            print(#function, "location: \(locations)")
            self.lat = (locations.last!.coordinate.latitude)
            self.lon = (locations.last!.coordinate.longitude)
           // let weatherViewModel = WeatherViewModel()

           // WeatherViewModel().fetchDataFromAPI( lat: self.lat,  lon: self.lon)
            
            
        }
        
        self.lat = (manager.location?.coordinate.latitude)!
        self.lon = (manager.location?.coordinate.longitude)!
        
    //   weatherViewModel.fetchDataFromAPI( lat: self.lat,  lon: self.lon)
    // not possible!

        self.getPlacemark()
    }
    
    func getPlacemark(){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: self.lat, longitude: self.lon)
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {placemarks, error -> Void in
            guard let placemark = placemarks?.first else{
                print(#function, "Unable to obtain placemark from LatLon")
                return
            }

            self.address = CNPostalAddressFormatter.string(from: placemark.postalAddress!, style: .mailingAddress)
            print(#function, "address : \(self.address)")
        })
    }
    
    
    func getCoordinates(address: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void){
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address){(placemarks, error) in
            if error == nil {
                if let placemark = placemarks?.first{
                    let location = placemark.location!
                    
                    print(#function, "location: ", location)
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
}
