//
//  NSDate.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation

extension NSDate {
    
    private func dateComponents() -> DateComponents {
        let calander = NSCalendar.current
        let calComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
        return calander.dateComponents(calComponents, from: self as Date, to: Date())
    }
    
    // MARK: - Method to modify NSDate string to be compatible with graph. For tab bar (W,M,Y) selection updates.
    
    public var timeAgoForFeed: String {
        let components = self.dateComponents()
        
        if components.month! > 0 && components.day! >= 25{
            if components.month! < 2 {
                return ("1 month ago")
            } else if components.month!<=6{
                return stringFromFormat(format: "%d months ago", withValue: components.month!)
            } else{
                return "a while ago"
            }
        }
        
        if components.day! >= 7 {
            let week = components.day!/7
            if week < 2 {
                return ("1 week ago")
            } else if week<4 {
                return stringFromFormat(format: "%d weeks ago", withValue: week)
            }
        }
        
        if components.day! > 0 {
            if components.day! < 2 {
                return ("1 day ago")
            } else  {
                return stringFromFormat(format: "%d days ago", withValue: components.day!)
            }
        }
        
        if components.hour! > 0 {
            if components.hour! < 2 {
                return ("1 hour ago")
            } else if components.hour!<=12 {
                return stringFromFormat(format: "%d hours ago", withValue: components.hour!)
            }
        }
        
        if components.minute! < 2 {
            return ("1 minute ago")
        } else {
            return stringFromFormat(format: "%d minutes ago", withValue: components.minute!)
        }
    }
    
    private func stringFromFormat(format: String, withValue value: Int) -> String {
        return String(format: format, value)
    }
}
