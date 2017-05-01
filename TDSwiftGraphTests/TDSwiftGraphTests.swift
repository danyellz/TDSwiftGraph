//
//  TDSwiftGraphTests.swift
//  TDSwiftGraphTests
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import XCTest
@testable import TDSwiftGraph

class TDSwiftGraphTests: XCTestCase {
    
    var newGraph = TDGraphNewController()
    var data: (x:[Double], y:[Double], y1:[Double], balance:[Double]) = (x:[], y:[], y1:[], balance:[]) {
        didSet {
            testAdequatePlotData() // Run this XCtest once data is available
        }
    }
    
    override func setUp() {
        super.setUp()
        
        newGraph.dataSource = self
        newGraph.getData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAdequatePlotData() {
        
        XCTAssertGreaterThan(data.x.count, 0, "Adequate timeAgo values for graph configuration")
        XCTAssertGreaterThan(data.y.count, 0, "Adequate +/- values for graph configuration")
        XCTAssertGreaterThan(data.y1.count, 0, "Adequate Y1 values for graph configuration")
        XCTAssertGreaterThan(data.balance.count, 0, "Adequate balance values for graph configuration")
    }
    
}

extension TDSwiftGraphTests: TDGraphViewControllerDataSource {
    
    func dataForGraph(section: Int, completionHandler: @escaping ((x: [Double],
        y: [Double],
        y1: [Double],
        balance: [Double]),
        Bool) -> Void) {
        
        // NOTE: - Spoofed data
        
        var xArr = [Double]()
        var yArr = [Double]()
        var yyArr = [Double]()
        var balanceArr = [Double]()
        for _ in 0..<40 { // Plot 40 random data points
            let x = NSDate().timeAgoForFeed
            let y = 1 * Double(arc4random()) / Double(UInt32.max)
            let bal = Double(arc4random_uniform(UInt32(25.00)))
            xArr.append(NSDate().timeIntervalSince1970)
            yArr.append(y)
            yyArr.append(0.0)
            balanceArr.append(bal)
            
            print("COORD: x:\(x), y:\(y), bal: \(bal)")
        }
        
        let dataArr = (x: xArr, y: yArr, y1: yyArr, balance: balanceArr)
        data = dataArr
    }
}
