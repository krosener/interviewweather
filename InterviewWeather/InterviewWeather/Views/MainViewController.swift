//
//  ViewController.swift
//  InterviewWeather
//
//  Created by Kenneth Rosener on 5/11/23.
//

import UIKit
import MapKit

class MainViewController: UIViewController, WeatherMapViewModelDelegate, CLLocationManagerDelegate {
    
    var weatherMapViewModel: WeatherMapViewModel?
    var storageManager: StorageManager?
    var imageLoader: ImageLoader?
    var weatherModule: WeatherAnnotationView?

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func searchLocation(_ sender: Any) {
        if let text = searchBar.text {
            weatherMapViewModel?.searchGeocoding(text)
        }
    }
    
    func updateGeocodeSearch(_ location: CLLocationCoordinate2D) {
        mapView.setCenter(location, animated: true)
        weatherMapViewModel?.weatherForLocation(location)
    }
    
    func updateWeatherResult() {
        if let weatherName = weatherMapViewModel?.weatherResponse?.weather.first?.main {
            self.weatherModule?.temperature.text = weatherName + "\n"
        } else {
            self.weatherModule?.temperature.text = ""
        }
        
        if let temp = weatherMapViewModel?.weatherResponse?.main.temp {
            self.weatherModule?.temperature.text! += "\(temp) F"
        }
        
        if let weatherIcon = weatherMapViewModel?.weatherResponse?.weather.first?.icon {
            self.weatherModule?.updateWeatherIconToImage(weatherIcon)
        }
        
        self.weatherModule?.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let storedLocation:CLLocationCoordinate2D = {
            if let location = storageManager?.lastSearchedLocation() {
                if location.latitude != 0 && location.longitude != 0 {
                    return location
                }
            }
            return CLLocationCoordinate2D(latitude: 40.7127281, longitude: -74.0060152)  //Default is New York
        }()
        mapView.setRegion(MKCoordinateRegion(center: storedLocation, latitudinalMeters: 50000, longitudinalMeters: 50000), animated: false)
        
        let module = Bundle.main.loadNibNamed("WeatherAnnotationViewNib", owner: self)![0] as! WeatherAnnotationView
        module.translatesAutoresizingMaskIntoConstraints = false
        module.backgroundColor = .systemBackground
        module.isHidden = true
        module.imageLoader = self.imageLoader
        
        
        self.weatherModule = module
        self.view.addSubview(weatherModule!)
        
        NSLayoutConstraint.activate(
            [module.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
             module.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 100)])
        
        // just get location one time at start, I'd pull this out into a separate location manager with more time
        let location = CLLocationManager()
        location.delegate = self
        if location.authorizationStatus != .authorizedWhenInUse {
            updateGeocodeSearch(storedLocation)
        }
        location.requestLocation()
    }
    
    // CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            updateGeocodeSearch(location.coordinate) // I'm aware location is a bit sensitive of data to be storing in UserDefaults, with more time I'd think about putting it in the keychain or some other encryption
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(manager.authorizationStatus)
        if manager.authorizationStatus != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

