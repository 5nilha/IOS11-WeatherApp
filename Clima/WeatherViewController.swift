//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "37348c1e90d4ae9cff1a89f6d4b9cdff"
    

    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate = self
        
        //Location accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        //Location permission
        locationManager.requestWhenInUseAuthorization()
        
        //Updates the location
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getWeatherData(url: String, parameters: [String : String]) {
        
        //making a http request using alamofire
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error " + (String)(describing: response.result.error))
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    func updateWeatherData(json : JSON) {
       
        // gets the value and Converting the JSON value to double
        if let tempResult = json["main"]["temp"].double {
            print(tempResult)
            
        weatherDataModel.celsiusTemperature = (tempResult - 273) // converting from  Kelvin to celsius
        weatherDataModel.fahenheitTemperature = ((9/5) * (tempResult - 273) + 32)
            print(weatherDataModel.fahenheitTemperature)
            print(tempResult)
            
        weatherDataModel.city = json["name"].stringValue  // Converting the JSON to a String
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue  // Converting the JSON to Int
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            
        updateUIWithWeatherData()
        }
        else {
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    
//    func convertTempToCelsius(temp : Int) {
//        //Converting Fahenheit to Celsius
//        let celsius : Int = ((5/9) * (temp - 32))
//        weatherDataModel.temperature = celsius
//        updateUIWithWeatherData()
//    }
//
//    func convertTempToFahenheit(temp : Int) {
//        // Converting Celsius to Fahenheit
//         let fahrenheit : Int = ((9/5) * (temp) + 32)
//         weatherDataModel.temperature = fahrenheit
//         updateUIWithWeatherData()
//    }
    
    
    @IBAction func switchToggle(_ sender: UISwitch) {
       
        if (sender.isOn) {
            temperatureLabel.text = "\(Int(weatherDataModel.fahenheitTemperature))°"
        }
        else {
            temperatureLabel.text = "\(Int(weatherDataModel.celsiusTemperature))°"
        }
    
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(Int(weatherDataModel.fahenheitTemperature))°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            print("longitude = \(location.coordinate.longitude) , latitude = \(location.coordinate.latitude)")
            
            let latidute = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            /* Create a dictionary Params and stores the values and keys
               * set params accordingly the API to get weather By geographic coordinates
               * API sample call "api.openweathermap.org/data/2.5/weather?lat=35&lon=139"
              */
            let params : [String : String] = ["lat" : latidute, "lon" : longitude, "appid": APP_ID]
            
            getWeatherData(url:WEATHER_URL, parameters: params)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //I use the userEnteredANewCityName Delegate method here to pass back the city entered in the ChangeCityViewControler
    func userEnteredANewCityName(city: String) {
        
        /* set params accordingly the API to get weather by city name
          *  API sample call "api.openweathermap.org/data/2.5/weather?q=London,uk"
          * or "api.openweathermap.org/data/2.5/weather?q=London"
         */
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
    
    
    
}


