//
//  WeatherData.swift
//  Clima
//
//  Created by Yatharth Mahawar on 13/08/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData:Decodable {
    let name:String
    let main:temperature
    let weather:[weatherDescription]
    
}

struct temperature:Decodable{
    let temp:Double
    
}

struct weatherDescription:Decodable{
    let id:Int
}

