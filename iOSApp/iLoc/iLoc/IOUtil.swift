//
//  FileUtil.swift
//  iLoc
//
//  Created by Zongjian He on 6/25/15.
//  Copyright (c) 2015 Tongji University. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


struct IOUtil {
    
    // File Operations
    static var filemgr = NSFileManager.defaultManager()
    
    static func appendLocation(locations : [CLLocation]) {
        
        let dir : NSURL = filemgr.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as! NSURL
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fname = "\(dateFormatter.stringFromDate(NSDate())).txt"
        let fileurl =  dir.URLByAppendingPathComponent(fname)

        
        // put content to a string named data
        var strdata = ""
        for loc in locations {
            var tmpstr = "\(loc.timestamp), \(loc.coordinate.latitude), \(loc.coordinate.longitude)\r\n"
            strdata += tmpstr
        }
        println(strdata)
        var data = strdata.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        if filemgr.fileExistsAtPath(fileurl.path!) {
            var err:NSError?
            if let fileHandle = NSFileHandle(forWritingToURL: fileurl, error: &err) {
                fileHandle.seekToEndOfFile()
                fileHandle.writeData(data)
                fileHandle.closeFile()
            }
            else {
                println("Can't open fileHandle \(err)")
            }
        }
        else {
            var err:NSError?
            if !data.writeToURL(fileurl, options: .DataWritingAtomic, error: &err) {
                println("Can't write \(err)")
            }
        }
    }
    
    // Network Operations
    
    static func appendLocationDB(curloc : CLLocation) {
        
        var locrecord : [String: String] = ["NAME": "Zongjian","CONNECTION":"1"]
        locrecord["LOCATION_X"] = curloc.coordinate.latitude.description
        locrecord["LOCATION_Y"] = curloc.coordinate.longitude.description
        locrecord["EQID"] = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        let body = NSJSONSerialization.dataWithJSONObject(locrecord, options: NSJSONWritingOptions(0), error: nil)
        
        println(NSString(data: body!, encoding: NSUTF8StringEncoding))
        
        let urlPath = "http://180.168.144.190:35821/Ageing_service.asmx/insertCargoInfo"
        let url: NSURL = NSURL(string: urlPath)!
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = body!
        request.HTTPMethod = "POST"
        
        let session = NSURLSession.sharedSession()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    
    // V2 Network Operations
    /*
    <insertCargoInfo xmlns="http://tempuri.org/">
    <NAME>string</NAME>
    <EQID>string</EQID>
    <TIME>string</TIME>
    <LOCATION_X>string</LOCATION_X>
    <LOCATION_Y>string</LOCATION_Y>
    <CONNECTION>string</CONNECTION>
    <SCREEN_ON>string</SCREEN_ON>
    <BATTERY>string</BATTERY>
    </insertCargoInfo>
    */
    
    static func appendLocationDB2(curloc : CLLocation) {
        
        var locrecord : [String: String] = ["NAME": "iPhone","CONNECTION":"1"]
        locrecord["TIME"] = NSDate().description
        locrecord["LOCATION_X"] = curloc.coordinate.latitude.description
        locrecord["LOCATION_Y"] = curloc.coordinate.longitude.description
        locrecord["EQID"] = UIDevice.currentDevice().identifierForVendor.UUIDString
        locrecord["SCREEN_ON"] = "true"
        
        // battery
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        locrecord["BATTERY"] = "\(UIDevice.currentDevice().batteryLevel * 100)"

        
        let body = NSJSONSerialization.dataWithJSONObject(locrecord, options: NSJSONWritingOptions(0), error: nil)!
        
        println(NSString(data: body, encoding: NSUTF8StringEncoding)!)
        
        let urlPath = "http://180.168.144.190:35821/Ageing_service.asmx/insertCargoInfo"
        let url: NSURL = NSURL(string: urlPath)!
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = body
        request.HTTPMethod = "POST"
        
        let session = NSURLSession.sharedSession()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding)!)
        }
        task.resume()
    }
    
    
    static func appendLocationDBTest(curloc : CLLocation) {
        
        var locrecord : [String: String] = ["NAME": "iPhone","CONNECTION":"1"]
        locrecord["TIME"] = "2005"
        locrecord["LOCATION_X"] = "1"
        locrecord["LOCATION_Y"] = "1"
        locrecord["EQID"] = "133"
        locrecord["SCREEN_ON"] = "true"
        locrecord["BATTERY"] = "33"
        
        
        let body = NSJSONSerialization.dataWithJSONObject(locrecord, options: NSJSONWritingOptions(0), error: nil)!
        
        println(NSString(data: body, encoding: NSUTF8StringEncoding)!)
        
        let urlPath = "http://180.168.144.190:35821/Ageing_service.asmx/insertCargoInfo"
        let url: NSURL = NSURL(string: urlPath)!
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPBody = body
        request.HTTPMethod = "POST"
        
        let session = NSURLSession.sharedSession()
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding)!)
        }
        task.resume()
    }
    
    
    
    
}