//
//  ViewController.swift
//  Stormy
//
//  Created by Camron Schwoegler on 10/8/14.
//  Copyright (c) 2014 metafour.org. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    private let apiKey = "c8275c60c9c11847262516910d7e0c6b"
    let debug: Bool = false
    let currentLocation = "33.959799,-118.420154"
    
    @IBOutlet weak var weatherIconLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var currentPrecipLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true
        
        getCurrentWeatherData(currentLocation)
        
    }
    
    func getCurrentWeatherData(location: String) -> Void {
        
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: location, relativeToURL: baseURL)
        //        let forecastData = NSData(contentsOfURL: forecastURL!, options: nil, error: nil)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                var urlContents = NSString(contentsOfURL: location, encoding: NSUTF8StringEncoding, error: nil)
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                if self.debug {
                    println(currentWeather.currentTime!)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.weatherIconLabel.text = currentWeather.icon
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is..."
                    self.currentTempLabel.text = "\(currentWeather.temperature)"
                    self.currentHumidityLabel.text = "\(currentWeather.humidity)"
                    self.feelsLikeLabel.text = "\(currentWeather.feelsLike)"
                    self.currentPrecipLabel.text = "\(currentWeather.precipProbability)"
                    self.currentSummaryLabel.text = "\(currentWeather.summary)"
                    
                    // stop refresh animation and show button
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.weatherIconLabel.hidden = false
                    self.currentTimeLabel.hidden = false
                    self.currentTempLabel.hidden = false
                    self.currentHumidityLabel.hidden = false
                    self.feelsLikeLabel.hidden = false
                    self.currentPrecipLabel.hidden = false
                    self.currentSummaryLabel.hidden = false
                    self.refreshButton.hidden = false
                })
                
                
            } else {
                let alertController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity Error", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okButton)
                let continueButton = UIAlertAction(title: "Refresh", style: .Cancel, handler: { (UIAlertAction) -> Void in
                    self.getCurrentWeatherData(self.currentLocation)
                })
                alertController.addAction(continueButton)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                // UI updates need to happen on the main queue
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // stop refresh animation and show button
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.weatherIconLabel.hidden = false
                    self.currentTimeLabel.hidden = false
                    self.currentTempLabel.hidden = false
                    self.currentHumidityLabel.hidden = false
                    self.feelsLikeLabel.hidden = false
                    self.currentPrecipLabel.hidden = false
                    self.currentSummaryLabel.hidden = false
                    self.refreshButton.hidden = false
                })
            }
        })
        downloadTask.resume()
    }
    
    @IBAction func refreshWeatherData(sender: AnyObject) {
        refreshButton.hidden = true
        weatherIconLabel.hidden = true
        currentTimeLabel.hidden = true
        currentTempLabel.hidden = true
        currentHumidityLabel.hidden = true
        feelsLikeLabel.hidden = true
        currentPrecipLabel.hidden = true
        currentSummaryLabel.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        
        getCurrentWeatherData(currentLocation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Find included font names
//        for object in UIFont.familyNames() {
//            let family = object as String
//            println(family)
//            for object2 in UIFont.fontNamesForFamilyName(family) {
//                let name = object2 as String
//                println(name)
//            }
//        }


