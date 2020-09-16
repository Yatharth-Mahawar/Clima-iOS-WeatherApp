//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var coreLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreLocationManager.delegate = self
        weatherManager.delegate = self
        userTextField.delegate = self
        coreLocationManager.requestWhenInUseAuthorization()
        coreLocationManager.requestLocation()
       
    }
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        coreLocationManager.requestLocation()
    }
    
}

//MARK: -UIText

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchButton(_ sender: UIButton) {
    
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else {
            textField.placeholder = "Type City Name"
            return false
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userTextField.endEditing(true)
        print(userTextField.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.fetchWeather(cityName: textField.text!)
        userTextField.text = ""
    }
}

//MARK: -WeatherManager

extension WeatherViewController: WeatherManagerDelegate {
    
    func dipUpdateWeather(weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            
        }
    }
}

//MARK: -CoreLocationData

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            coreLocationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(lat: lat, lon: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

