//
//  ContentView.swift
//  Muhammad_Weather
//
//  Created by MUS on 2020-11-16.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var weatherViewModel = WeatherViewModel()
    @State private var myCoordinates = CLLocationCoordinate2D()
    
    @State var myLocationAddress: String = ""
    @State var lat: Double = 0.0
    @State var lon: Double = 0.0
    
    var body: some View {
        NavigationView{
            VStack{
                if (weatherViewModel.weatherList.count != 0){
                
                    List(weatherViewModel.weatherList){weather in
                    
                    VStack(alignment: .leading, spacing: 30){
                        HStack{
                            Text(String(format: "%@", self.locationManager.address )).font(.largeTitle).foregroundColor(Color.blue)
                        }
                        HStack{
                            Text("Temperature").font(.title)
                            Text(String(format: "%.2f C", self.weatherViewModel.weatherList[0].tempC ?? "None"))
                                .font(.title)
                                .foregroundColor(Color.red)
                        }
                        
                        HStack{
                            Text("Feels like").font(.title)
                            Text(String(format: "%.2f C", weather.feelslikeC ?? "None"))
                                .font(.title)
                                .foregroundColor(Color.red)
                        }
                        
                        HStack{
                            Text("Dewpoint ").font(.title)
                            Text(String(format: "%.2f", weather.dewpointC ?? "None"))
                                .font(.title)
                                .foregroundColor(Color.red)
                        }
                        
                        HStack{
                            Text("Humidity ").font(.title)
                            Text(String(format: "%d", weather.humidity ?? "None"))
                                .font(.title)
                                .foregroundColor(Color.red)
                        }
                        
                        HStack{
                            Text("Wind Speed ").font(.title)
                            Text(String(format: "%d ", weather.windKPH ?? "None"))
                                .font(.title)
                                .foregroundColor(Color.red)
                        }
                        
                        HStack{
                            Text("Visibility ").font(.title)
                            Text(String(format: "%.2f KM", weather.visibilityKM ?? "None"))
                                .font(.title)
                                .foregroundColor(Color.red)
                        }
                        
                        

                    }
                    
                }
                
            }else{
                Text("No weather data. Try stimulating your location then restarting this app")
                
            }
            }
             //Spacer()
            .navigationBarTitle("Muhammad_Shahid")
        }
        
        .onAppear(){
            self.getLocation()
            if (locationManager.lat != 0.0 && locationManager.lon != 0.0){
                weatherViewModel.fetchDataFromAPI( lat: locationManager.lat,  lon: locationManager.lon)
                self.myCoordinates = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
                print(#function, "Coordinates obtained :", self.lat, self.lon)
            }else{

                self.locationManager.getCoordinates(address: self.myLocationAddress, completionHandler: { (coordinates, error) in
                    
                    if (error == nil){
                        self.myCoordinates = coordinates
                        print(#function, "Coordinates obtained :", self.myCoordinates)
                        weatherViewModel.fetchDataFromAPI(lat: coordinates.latitude, lon: coordinates.longitude)
                    }else{

                        print(#function, "error: ", error?.localizedDescription as Any)
                    }
                    
                })
            }
        }
        }
    private func getLocation(){
        print(#function, "Getting the location...")
        self.locationManager.start()
        
        print(#function, "Address: \(self.locationManager.address)")
        print(#function, "Latitude: \(self.locationManager.lat)")
        print(#function, "Longidute: \(self.locationManager.lon)")
        
        self.myLocationAddress = self.locationManager.address
        self.lat = self.locationManager.lat
        self.lon = self.locationManager.lon
        
    }
    }


/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView( weatherViewModel: <#WeatherViewModel#>)
    }
}*/
