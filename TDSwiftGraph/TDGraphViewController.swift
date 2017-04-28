//
//  TDGraphViewController.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/26/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation
import UIKit

class TDGraphViewController: UIViewController {
    
    lazy fileprivate var tdBaseGraph: TDGraphView = {
        let graph = TDGraphView()
//        graph.delegate = self
        graph.mainLineColor = UIColor.red
        return graph
    }()
}
