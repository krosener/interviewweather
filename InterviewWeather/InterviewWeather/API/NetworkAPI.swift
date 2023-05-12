//
//  NetworkAPI.swift
//  ChaseWeather
//
//  Created by Kenneth Rosener on 5/11/23.
//

import Foundation

class NetworkAPI {
    let baseURL = "https://api.openweathermap.org"
    let imageBaseURL = "https://openweathermap.org"
    let APIKey:String = { // Hi, I won't commit my api key for the interview.  You guys can add it here
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path)!
            return keys["APIKey"] as! String
        }
        return "putkeyhere"
    }()
    
    let queue = DispatchQueue(label: "Network")
    
    func load(_ url: URL, completion: @escaping (Data?) -> Void) {
        queue.async {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let response = response {
                    print("!!!NetworkResponse \(response)")
                }
                if let error = error {
                    print("!!!NetworkError \(error)")
                }
                completion(data)
            }
            task.resume() // with more time, add cancel logic and more error handling
        }
    }
}
