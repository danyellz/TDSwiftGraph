//
//  ViewController.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tdGraphNewViewController = TDGraphNewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tdGraphNewViewController.dataSource = self
        tdGraphNewViewController.userGraph = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

