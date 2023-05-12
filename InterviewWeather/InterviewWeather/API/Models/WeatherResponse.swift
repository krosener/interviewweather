//
//  WeatherResponse.swift
//  ChaseWeather
//
//  Created by Kenneth Rosener on 5/11/23.
//

import Foundation

struct WeatherResponse : Codable {
    
    let weather: [WeatherBlock]
    
    let main: MainBlock
    
}

struct WeatherBlock: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainBlock: Codable {
    let temp: Double
}

/**
 {
   "coord": {
     "lon": -122.4199,
     "lat": 37.779
   },
   "weather": [
     {
       "id": 801,
       "main": "Clouds",
       "description": "few clouds",
       "icon": "02n"
     }
   ],
   "base": "stations",
   "main": {
     "temp": 53.71,
     "feels_like": 52.77,
     "temp_min": 50.41,
     "temp_max": 57.9,
     "pressure": 1016,
     "humidity": 85
   },
   "visibility": 10000,
   "wind": {
     "speed": 17,
     "deg": 315,
     "gust": 20
   },
   "clouds": {
     "all": 20
   },
   "dt": 1683868006,
   "sys": {
     "type": 2,
     "id": 2017837,
     "country": "US",
     "sunrise": 1683810214,
     "sunset": 1683860917
   },
   "timezone": -25200,
   "id": 5391959,
   "name": "San Francisco",
   "cod": 200
 }
 */
