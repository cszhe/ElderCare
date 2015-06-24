//
//  ViewController.swift
//  iLoc
//
//  Created by Zongjian He on 6/23/15.
//  Copyright (c) 2015 Tongji University. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var labelGPS: UILabel!
    
    @IBOutlet weak var switchLog: UISwitch!
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Init location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func isTrackingChanged(sender: UISwitch) {
        if sender.on {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        labelGPS.text = locations.last?.description
        println(locations.last?.description)
        
        // current application state
        println(UIApplication.sharedApplication().applicationState.rawValue )
    }

}

