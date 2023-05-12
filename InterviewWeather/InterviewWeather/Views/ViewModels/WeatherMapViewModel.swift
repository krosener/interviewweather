//
//  GeocodeViewModel.swift
//  ChaseWeather
//
//  Created by Kenneth Rosener on 5/11/23.
//

import Foundation
import CoreLocation

protocol WeatherMapViewModelDelegate {
    func updateGeocodeSearch(_ location: CLLocationCoordinate2D)
    func updateWeatherResult()
}

class WeatherMapViewModel {
    var weatherView: WeatherMapViewModelDelegate
    var geoResponses = [GeoResponse]() // when we want to get beyond the first response, we'll store them here, seems a little out of scope for this right now
    var weatherResponse: WeatherResponse?
    let geocodingAPI: GeocodingAPI
    let weatherAPI: WeatherAPI
    let storageManager: StorageManager
    
    
    init(geocodingAPI: GeocodingAPI, weatherAPI: WeatherAPI, weatherView: WeatherMapViewModelDelegate, storageManager: StorageManager) {
        self.geocodingAPI = geocodingAPI
        self.weatherAPI = weatherAPI
        self.weatherView = weatherView
        self.storageManager = storageManager
    }
    
}

extension WeatherMapViewModel { // Geocoding API
    
    func searchGeocoding(_ searchTerm: String) {
        geocodingAPI.geoResponsesForQuery(searchTerm) { [weak self] response in
            DispatchQueue.main.async {
                self?.geoResponses = response
                if let firstCity = response.first { // If I had more time, I'd return all the resopnses so the View can display them and user can select a result to load
                    self?.weatherView.updateGeocodeSearch(CLLocationCoordinate2D(latitude: firstCity.lat, longitude: firstCity.lon))
                }
            }
        }
    }
    
    func clearGeoResponses() {
        DispatchQueue.main.async {
            self.geoResponses.removeAll()
        }
    }
    
}

extension WeatherMapViewModel { // Weather API
    
    func weatherForLocation(_ location: CLLocationCoordinate2D) {
        storageManager.setLastSearchedLocation(location)
        weatherAPI.weatherForLocation(location.latitude, location.longitude) { [weak self] response in
            DispatchQueue.main.async {
                self?.weatherResponse = response
                self?.weatherView.updateWeatherResult()
            }
        }
    }
}
