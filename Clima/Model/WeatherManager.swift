//
//  WeatherManager.swift
//  Clima
//
//  Created by Yatharth Mahawar on 12/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func dipUpdateWeather(weather:WeatherModel)
}

struct WeatherManager {
    
    let weatherurl = "https://api.openweathermap.org/data/2.5/weather?appid=6224bd48cbbaebc38e8d4dac34e4f2b5&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        let url = "\(weatherurl)&q=\(cityName)"
        performRequest(urlString: url)
        
    }
    
    func fetchWeather(lat:CLLocationDegrees,lon:CLLocationDegrees){
        let url = "\(weatherurl)&lat=\(lat)&lon=\(lon)"
        print(url)
        performRequest(urlString: url)
        
    }
    
    func performRequest(urlString:String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, urlstring, error) in
                if error != nil {
                    print(error)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.dipUpdateWeather(weather: weather)
                        
                        
                    }
                    
                }
            }
            
            task.resume()
            
        }
     
    }
    
    func parseJSON(weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do { let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decoderData.weather[0].id
            let name = decoderData.name
            let temperature = decoderData.main.temp
            
            let weatherDataModel = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            return weatherDataModel
            
        }
        catch{
            print(error)
            return nil
        }
    }
    
}
    
    


