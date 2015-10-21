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
    
    var locationStatus : NSString = "Not Started"
    
    var cachedLocation = [CLLocation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Init location manager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        // Ask User to start GPS.
        print(CLLocationManager.locationServicesEnabled())
//        if CLLocationManager.locationServicesEnabled() == false {
//            let alertController = UIAlertController(
//                title: "位置服务被关闭",
//                message: "您需要打开手机上的位置服务来使用本程序",
//                preferredStyle: .Alert)
//            
//            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            
//            let openAction = UIAlertAction(title: "现在就去打开", style: .Default) { (action) in
//                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
//                    UIApplication.sharedApplication().openURL(url)
//                }
//            }
//            alertController.addAction(openAction)
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func callWS(sender: UIButton) {
        
        
    }

    @IBAction func isTrackingChanged(sender: UISwitch) {
        if sender.on {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    // major location update
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        

        var locationObj = locations.last as! CLLocation
        
        self.cachedLocation.append(locationObj)
        
        // write file
        if self.cachedLocation.count >= 16 {
            IOUtil.appendLocation(self.cachedLocation)
            self.cachedLocation = []    // remove all
        }
        
        print(self.cachedLocation.count)
        // current application state
        //println("AppState = \(UIApplication.sharedApplication().applicationState.rawValue)")
        
        
        // Call web serivce
        IOUtil.appendLocationDB2(locationObj)
        //IOUtil.appendLocationDBTest(locationObj)
        
    }
    
    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                //locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            }
    }

}

