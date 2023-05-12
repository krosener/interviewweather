//
//  StorageManager.swift
//  InterviewWeather
//
//  Created by Kenneth Rosener on 5/12/23.
//

import Foundation
import CoreLocation
import UIKit

class StorageManager {
    
    private let locationLatKey = "location.lat"
    private let locationLonKey = "location.lon"
    private let imageCacheKeyPrefix = "image."
    
    // probably don't need to make this thread safe for such a small app, but doing it to show I think it should be in a larger one
    private let queue = DispatchQueue(label: "Storage", attributes: .concurrent)
    
    
    func setLastSearchedLocation(_ location: CLLocationCoordinate2D) {
        queue.async(flags:.barrier) {
            UserDefaults.standard.set(location.latitude, forKey: self.locationLatKey)
            UserDefaults.standard.set(location.longitude, forKey: self.locationLonKey)
        }
    }
    
    func lastSearchedLocation() -> CLLocationCoordinate2D {
        queue.sync {
            let lat = UserDefaults.standard.double(forKey: self.locationLatKey)
            let lon = UserDefaults.standard.double(forKey: self.locationLonKey)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
    
    func imageForName(_ name:String) -> UIImage? {
        queue.sync {
            let image = UserDefaults.standard.data(forKey: self.imageCacheKeyPrefix + name)
            if let image = image, let result = UIImage(data: image) {
                return result
            }
            return nil
        }
    }
    
    func setImage(_ image:UIImage, forName name:String) {
        queue.async(flags:.barrier) {
            if let data = image.pngData() {
                UserDefaults.standard.set(data, forKey: self.imageCacheKeyPrefix + name)
            }
        }
    }
}
