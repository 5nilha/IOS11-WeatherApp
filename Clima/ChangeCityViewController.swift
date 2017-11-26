//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit



protocol ChangeCityDelegate {
    func userEnteredANewCityName(city : String)
}


class ChangeCityViewController: UIViewController {
    
    var delegate : ChangeCityDelegate?

    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        //Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        // If we have a delegate set to another VC, we call the method userEnteredANewCityName to pass back the CityName
        delegate?.userEnteredANewCityName(city: cityName)
        
        //dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
