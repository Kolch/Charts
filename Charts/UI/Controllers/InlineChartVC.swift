//
//  InlineChartVC.swift
//  Charts
//
//  Created by Alex Kolchedantsev on 22.03.2022.
//

import Foundation
import UIKit

class InlineChartVC: UIViewController {
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var slider: UISlider!
    
    private var workLayer: CAShapeLayer!
    
    private var values: [DataPoint] = [.init(value: 1, color: .lightGray.withAlphaComponent(0.3))] {
        didSet {
            workLayer?.removeFromSuperlayer()
            drawChart(values)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.layer.cornerRadius = 10
        chartView.layer.masksToBounds = true
        
        slider.isContinuous = false
        
        drawChart(values)
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        let emptyValue = CGFloat(1 - sender.value)
        let value = CGFloat(sender.value)
        
        switch sender.value {
        case 0...0.2:
            values = [.init(value: value, color: .chartRed),
                      .init(value: emptyValue, color: .lightGray.withAlphaComponent(0.3))]
        case 0.2...0.5:
            values = [.init(value: 0.2, color: .chartRed),
                      .init(value: value - 0.2, color: .chartBlue),
                      .init(value: emptyValue, color: .lightGray.withAlphaComponent(0.3))]
        case 0.5...0.8:
            values = [.init(value: 0.2, color: .chartRed),
                      .init(value: 0.3, color: .chartBlue),
                      .init(value: value - 0.5, color: .chartPink),
                      .init(value: emptyValue, color: .lightGray.withAlphaComponent(0.3))]
        default:
            values = [.init(value: 0.2, color: .chartRed),
                      .init(value: 0.3, color: .chartBlue),
                      .init(value: 0.3, color: .chartPink),
                      .init(value: value - 0.8, color: .chartGreen),
                      .init(value: emptyValue, color: .lightGray.withAlphaComponent(0.3))]
        }
    }
    
    private func drawChart(_ values: [DataPoint]) {
        let spacing = 0.8
        let total = values.map({ $0.value }).reduce(0, +)
        
        workLayer = CAShapeLayer()
        workLayer.frame = chartView.layer.bounds
        workLayer.fillColor = UIColor.clear.cgColor
        chartView.layer.addSublayer(workLayer)
        
        var yOffset = CGFloat(0)
        var combinedDelay = CGFloat(0)

        for (index, value) in values.enumerated() {

            let percent = CGFloat(value.value / (total / 100))
            let availableWidth = workLayer.bounds.width - (spacing * CGFloat(index))
            let width = availableWidth * (percent / 100)
            let height = workLayer.bounds.height

            let startPath = UIBezierPath(rect: .init(x: yOffset, y: 0, width: 0, height: height))
            let path = UIBezierPath(rect: .init(x: yOffset, y: 0, width: width, height: height))

            let layer = CAShapeLayer()
            layer.path = startPath.cgPath

            layer.fillColor = value.color.cgColor

            workLayer.addSublayer(layer)
            
            layer.animatePath(endPath: path.cgPath,
                              duration: value.value,
                              delay: combinedDelay)

            combinedDelay += value.value
            yOffset += width + spacing
        }
    }
}

extension InlineChartVC {
    struct DataPoint {
        var value: CGFloat
        var color: UIColor
    }
}
