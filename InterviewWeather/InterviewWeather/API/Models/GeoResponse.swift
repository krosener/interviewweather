//
//  GeoResponse.swift
//  ChaseWeather
//
//  Created by Kenneth Rosener on 5/11/23.
//

import Foundation
import CoreLocation

struct GeoResponse : Codable, Hashable{
    let name: String
    // let local_names -> we'd want this for localization, but that's a bit out of scope for this right now
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    
}
