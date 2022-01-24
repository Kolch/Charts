//
//  RoundedChartVC.swift
//  Charts
//
//  Created by Alex Kolchedantsev on 22.01.2022.
//

import UIKit

class RoundedChartVC: UIViewController {
    
    @IBOutlet weak var roundedChart: RoundedChart!
    
    private var randomValue: CGFloat { CGFloat.random(7) }
    private var segmentsCount = 2
    private let colors: [UIColor] = [.chartBlue, .chartPink, .chartYellow,
                                     .chartRed, .chartGreen, .chartPurple]
    
    private var values: [(CGFloat, UIColor)]! {
        didSet {
            roundedChart.setup(values: values)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues(for: segmentsCount)
    }
    
    private func setValues(for count: Int) {
        values = (0...count - 1).map { (randomValue, colors[$0]) }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        setValues(for: segmentsCount)
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        segmentsCount = sender.selectedSegmentIndex + 2
        setValues(for: segmentsCount)
    }
}
