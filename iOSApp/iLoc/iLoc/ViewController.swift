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
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        
        // Ask User to start GPS.
        println(CLLocationManager.locationServicesEnabled())
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

    @IBAction func isTrackingChanged(sender: UISwitch) {
        if sender.on {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    // major location update
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        labelGPS.text = locations.last?.description
        println(locations.last?.description)
        
        // current application state
        println(UIApplication.sharedApplication().applicationState.rawValue )
    }
    
    // user changed the location authorization
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            println("always authorized")
            // ...
        }
    }

}

