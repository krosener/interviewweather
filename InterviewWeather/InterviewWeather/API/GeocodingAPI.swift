//
//  GeocodingAPI.swift
//  ChaseWeather
//
//  Created by Kenneth Rosener on 5/11/23.
//

import Foundation

class GeocodingAPI {
    
    typealias geoCompletion = (([GeoResponse]) -> Void)
    
    let network: NetworkAPI
    
    let tool = "/geo"
    let apiVer = "/1.0"
    let request = "/direct"
    
    init(network:NetworkAPI) {
        self.network = network
    }
    
    func geoResponsesForQuery(_ query:String, completion: @escaping geoCompletion) {
        var urlRequest = URLComponents(string: network.baseURL)!
        urlRequest.path = "\(tool)\(apiVer)\(request)"
        urlRequest.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: network.APIKey) // TODO REMOVE THIS
        ]
        guard let url = urlRequest.url else {return} // put error handling with more time
        network.load(url) { data in
            if let data = data {
                let decoder = JSONDecoder()
                if let response = try? decoder.decode([GeoResponse].self, from: data) {
                    completion(response)
                    return
                }
            }
            completion([GeoResponse]())
        }
    }
}
