//
//  ViewController.swift
//  Charts
//
//  Created by Alex Kolchedantsev on 21.03.2021.
//

import UIKit

class BarChartsVC: UIViewController {
    
    @IBOutlet weak var barChart: BarChart!
    @IBOutlet weak var segmentCtrl: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.setup(type: .multiColor(randomDataPoints(30)), period: .day)
    }
    
    @IBAction func segmentAction(_ sedner: UISegmentedControl) {
        switch sedner.selectedSegmentIndex {
        case 0: barChart.setup(type: .multiColor(randomDataPoints(24)), period: .day)
        case 1: barChart.setup(type: .multiColor(randomDataPoints(7)), period: .week)
        case 2: barChart.setup(type: .multiColor(randomDataPoints(30)), period: .month)
        case 3: barChart.setup(type: .multiColor(randomDataPoints(12)), period: .year)
        default: break
        }
    }
    
    private func randomDataPoints(_ count: Int) -> [BarChart.DataPoint] {
        (0..<count).map({ _ -> BarChart.DataPoint in
            let randomValue = CGFloat.random()
            
            return BarChart.DataPoint(value: randomValue,
                               complexValues: [(randomValue / 4, .red),
                                               (randomValue / 6, .pink),
                                               (randomValue / 8, .violet)])
        })
    }
}

extension CGFloat {
    static func random(_ top: CGFloat = 20) -> CGFloat { CGFloat.random(in: 0...top) }
}

