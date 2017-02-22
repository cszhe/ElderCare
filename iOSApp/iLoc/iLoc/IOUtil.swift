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
    static var filemgr = FileManager.default
    
    static func appendLocation(_ locations : [CLLocation]) {
        
        let dir : URL = filemgr.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last as URL!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fname = "\(dateFormatter.string(from: Date())).txt"
        let fileurl =  dir.appendingPathComponent(fname)

        
        // put content to a string named data
        var strdata = ""
        for loc in locations {
            let tmpstr = "\(loc.timestamp), \(loc.coordinate.latitude), \(loc.coordinate.longitude)\r\n"
            strdata += tmpstr
        }
        print(strdata)
        let data = strdata.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        if filemgr.fileExists(atPath: fileurl.path) {
            var err:NSError?
            do {
                let fileHandle = try FileHandle(forWritingTo: fileurl)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } catch let error as NSError {
                err = error
                print("Can't open fileHandle \(err)")
            }
        }
        else {
            var err:NSError?
            do {
                try data.write(to: fileurl, options: .atomic)
            } catch let error as NSError {
                err = error
                print("Can't write \(err)")
            }
        }
    }
    
    // Network Operations
    
    static func appendLocationDB(_ curloc : CLLocation) {
        
        var locrecord : [String: String] = ["NAME": "Zongjian","CONNECTION":"1"]
        locrecord["LOCATION_X"] = curloc.coordinate.longitude.description
        locrecord["LOCATION_Y"] = curloc.coordinate.latitude.description
        locrecord["EQID"] = UIDevice.current.identifierForVendor!.uuidString
        
        let body = try? JSONSerialization.data(withJSONObject: locrecord, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        // print(NSString(data: body!, encoding: String.Encoding.utf8.rawValue))
        
        let urlPath = "http://180.168.144.190:35821/Ageing_service.asmx/insertCargoInfo"
        let url: URL = URL(string: urlPath)!
        
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body!
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            print(String(data: data!, encoding: String.Encoding.utf8)!)
        }) 
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
    
    static func appendLocationDB2(_ curloc : CLLocation) {
        
        var locrecord : [String: String] = ["NAME": "iPhone","CONNECTION":"1"]
        //date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:SS"
        locrecord["TIME"] = dateFormatter.string(from: Date())
        locrecord["LOCATION_X"] = curloc.coordinate.longitude.description
        locrecord["LOCATION_Y"] = curloc.coordinate.latitude.description
        locrecord["EQID"] = UIDevice.current.identifierForVendor!.uuidString
        locrecord["SCREEN_ON"] = "1"
        
        // battery
        UIDevice.current.isBatteryMonitoringEnabled = true
        locrecord["BATTERY"] = "\(UIDevice.current.batteryLevel * 100)"

        
        let body = try! JSONSerialization.data(withJSONObject: locrecord, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        print(NSString(data: body, encoding: String.Encoding.utf8.rawValue)!)
        
        let urlPath = "http://180.168.144.190:35821/Ageing_service.asmx/insertCargoInfo"
        let url: URL = URL(string: urlPath)!
        
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            print(String(data: data!, encoding: String.Encoding.utf8)!)
        })
        task.resume()
    }
    
    
    static func appendLocationDBTest(_ curloc : CLLocation) {
        
        var locrecord : [String: String] = ["NAME": "iPhone","CONNECTION":"1"]
        locrecord["TIME"] = "2005"
        locrecord["LOCATION_X"] = "1"
        locrecord["LOCATION_Y"] = "1"
        locrecord["EQID"] = "133"
        locrecord["SCREEN_ON"] = "true"
        locrecord["BATTERY"] = "33"
        
        
        let body = try! JSONSerialization.data(withJSONObject: locrecord, options: JSONSerialization.WritingOptions(rawValue: 0))
        
        print(NSString(data: body, encoding: String.Encoding.utf8.rawValue)!)
        
        let urlPath = "http://180.168.144.190:35821/Ageing_service.asmx/insertCargoInfo"
        let url: URL = URL(string: urlPath)!
        
        let request = NSMutableURLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = body
        request.httpMethod = "POST"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            print(String(data: data!, encoding: String.Encoding.utf8)!)
        }) 
        task.resume()
    }
    
    
    
    
}
