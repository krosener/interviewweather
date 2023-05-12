//
//  ImageLoader.swift
//  InterviewWeather
//
//  Created by Kenneth Rosener on 5/12/23.
//

import Foundation
import UIKit

class ImageLoader {
    
    let network: NetworkAPI
    let storage: StorageManager
    
    let imagePath = "/img/wn/"
    let imageSuffix = "@2x.png"
    
    init(network:NetworkAPI, storageManager: StorageManager) {
        self.network = network
        self.storage = storageManager
    }
    
    func imageForName(_ name:String, queue: DispatchQueue, completion:@escaping (UIImage?) -> Void) {
        if let image = self.storage.imageForName(name) {
            queue.async {
                completion(image)
            }
        }
        
        var urlComponents = URLComponents(string: network.imageBaseURL)!
        let path = imagePath+name+imageSuffix
        urlComponents.path = path
        
        guard let url = urlComponents.url else {return}
        self.network.load(url) { data in
            if let data = data {
                if let image = UIImage(data: data) {
                    self.storage.setImage(image, forName: name)
                    queue.async {
                        completion(image)
                    }
                } else {
                    print("image data could not be converted to UIImage")
                }
            } else {
                print("no data received")
            }
        }
    }
}
