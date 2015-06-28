//
//  FileUtil.swift
//  iLoc
//
//  Created by Zongjian He on 6/25/15.
//  Copyright (c) 2015 Tongji University. All rights reserved.
//

import Foundation
import CoreLocation


struct FileUtil {
    
    static var filemgr = NSFileManager.defaultManager()
    
    
    static func appendLocation(locations : [CLLocation]) {
        println("Writing file")
        
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
}