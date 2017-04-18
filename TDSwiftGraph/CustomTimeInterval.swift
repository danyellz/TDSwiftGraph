//
//  CustomTimeInterval.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit

enum CustomTimeInterval : Int, CustomStringConvertible {
    case Day = 0
    case Month = 1
    case Month3 = 2
    case Month6 = 3
    case Year = 4
    case All = 5
    
    var description : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .Day: return "1d";
        case .Month: return "1m";
        case .Month3: return "3m";
        case .Month6: return "6m";
        case .Year: return "1y";
        case .All: return "All";
        }
    }
}
