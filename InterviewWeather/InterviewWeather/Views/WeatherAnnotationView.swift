//
//  WeatherAnnotationView.swift
//  InterviewWeather
//
//  Created by Kenneth Rosener on 5/11/23.
//

import Foundation
import UIKit

class WeatherAnnotationView: UIStackView {
    
    var imageLoader: ImageLoader?
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    
    func updateWeatherIconToImage(_ imageName:String) {
        self.imageLoader?.imageForName(imageName, queue: DispatchQueue.main, completion: {
            [weak self] image in
            if let image = image {
                self?.weatherIcon.image = image
            }
        })
    }
    
}
