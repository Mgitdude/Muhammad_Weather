//
//  WeatherViewModel.swift
//  Muhammad_Weather
//
//  Created by MUS on 2020-11-17.
//

import Foundation

class WeatherViewModel : ObservableObject{
    @Published var weatherList = [Weather]()
    @Published var aerisURLString: String = #"https://api.aerisapi.com/observations/%f,%f?query&client_id=%@&client_secret=%@"#
    let access_id: String = "(REDACTED)"
    let secret_key: String = "(REDACTED)"

    func fetchDataFromAPI(lat: Double, lon: Double){
        
        aerisURLString = String(format: aerisURLString, lat, lon, self.access_id, self.secret_key)
        
        print(#function, "url is \(aerisURLString)")
        
        guard let apiURL = URL(string: aerisURLString) else{
            return
        }
        
        URLSession.shared.dataTask(with: apiURL){
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let er = error{
                print(#function, "Error \(er.localizedDescription)")
            }else{

                DispatchQueue.global().async {
                    do{
                        if let jsonData = data{

                            
                            let decodedResponse = try JSONDecoder().decode(Weather.self, from: jsonData)
                            
                            let decodedList : [Weather] = [decodedResponse]
                            
                            DispatchQueue.main.async {
                                self.weatherList = decodedList
                                print(#function, self.weatherList)
                            }
                            
                            
                        }else{
                            print(#function, "Empty JSON data :(")
                        }
                    }catch let error{
                        print(#function, "Error decoding the data \(error)")
                    }
                }
            }
            
        }.resume()
    }
}
