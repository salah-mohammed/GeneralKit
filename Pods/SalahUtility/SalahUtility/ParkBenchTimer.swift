//
//  ParkBenchTimer.swift
//  SalahUtility
//
//  Created by Salah on 3/30/21.
//  Copyright © 2021 Salah. All rights reserved.
//

import Foundation
import CoreFoundation

public class ParkBenchTimer {
    
    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?
    
    public init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }
    
    public func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()
        
        return duration!
    }
    
    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
    public func stopAndDurationInSeconds()->String{
        let value = self.stop();
        let stringValue = "The task took \(value) seconds.";
        print(stringValue)
        return stringValue;
    }
    public func printDurationInSeconds()->String{
        let stringValue = "The task took \(duration) seconds.";
        return stringValue;
    }
}
/*
 let timer = ParkBenchTimer()
 
 // ... a long runnig task ...
 
 println("The task took \(timer.stop()) seconds.")
 */
