//
//  Network.swift
//  ChaseWeather
//
//  Created by Kenneth Rosener on 5/11/23.
//

import Foundation

class WeatherAPI {
    
    typealias weatherCompletion = ((WeatherResponse?) -> Void)
    
    let network: NetworkAPI
    
    let tool = "/data"
    let apiVer = "/2.5" // strange that this isn't the same version between apis
    let request = "/weather"
    
    
    init(network:NetworkAPI) {
        self.network = network
    }
    
    func weatherForLocation(_ lat:Double, _ lon:Double, completion: @escaping weatherCompletion) {
        var urlRequest = URLComponents(string: network.baseURL)!
        urlRequest.path = "\(tool)\(apiVer)\(request)"
        urlRequest.queryItems = [
            URLQueryItem(name: "lat", value: "\(lat)"),
            URLQueryItem(name: "lon", value: "\(lon)"),
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: "appid", value: network.APIKey) // TODO REMOVE THIS
        ]
        guard let url = urlRequest.url else {return} // put error handling with more time
        network.load(url) { data in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(WeatherResponse.self, from: data)
                    completion(response)
                    return
                } catch {
                    print(error)
                }
            }
            completion(nil)
        }
    }
}
