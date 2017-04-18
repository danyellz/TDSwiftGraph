//
//  ViewController.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import UIKit
import Stevia

class ViewController: UIViewController, TDGraphViewControllerDataSource {
    
    // MARK: - Custom Controllers
    var tdGraphNewViewController = TDGraphNewController()
    
    // MARK: - View objects
    var graphWindow = UIView()
    
    // MARK: - View data
    var lastSection = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tdGraphNewViewController.dataSource = self
        tdGraphNewViewController.userGraph = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupGraph() {
        
        tdGraphNewViewController.view.frame = graphWindow.bounds
        
        view.sv(graphWindow)
        view.layout(
            0,
            |graphWindow| ~ view.frame.height / 2
        )
        
        EmbedChildViewController.embed(viewControllerId: tdGraphNewViewController, containerViewController: self, containerView: graphWindow) // Embed the graph within UIView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataForGraph(section: Int, completionHandler: @escaping ((x: [Double], y: [Double], y1: [Double], balance: [Double]), Bool) -> Void) {
        
//        if lastSection != section {
//            cacheFired = false
//        }
        self.lastSection = section
        print(section)
        
        //         Add some initial data
        var xArr = [Double]()
        var yArr = [Double]()
        var yyArr = [Double]()
        var balanceArr = [Double]()
        for i in 0 ..<  40 { // Plot 40 random data points
            let x = NSDate().timeAgoForFeed
            let y = 1.2 * Double(arc4random()) / Double(UInt32.max) + 1.2
            let bal = Double(arc4random_uniform(UInt32(25.00))) + 2
            xArr.append(NSDate().timeIntervalSince1970)
            yArr.append(y)
            yyArr.append(0.0)
            balanceArr.append(bal)
        }
        
        let dataArr = (x: xArr, y: yArr, y1: yyArr, balance: balanceArr)
        
        completionHandler(dataArr, false)
    }


}

