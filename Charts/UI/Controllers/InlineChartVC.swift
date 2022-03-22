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
    
    private let colors: [UIColor] = [.chartBlue, .chartRed, .chartPink, .chartPurple, .chartYellow]
    private var workLayer: CAShapeLayer!
    
    private var values: [CGFloat] = [100] {
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
        switch sender.value {
        case 0...0.1: values = [CGFloat.random(100)]
        case 0.2...0.4: values = [CGFloat.random(100), CGFloat.random(100)]
        case 0.5...0.7: values = [CGFloat.random(100), CGFloat.random(100), CGFloat.random(100)]
        default: values = [CGFloat.random(100), CGFloat.random(100), CGFloat.random(100), CGFloat.random(100)]
        }
    }
    
    private func drawChart(_ values: [CGFloat]) {
        let values = values.sorted(by: >)
        let spacing = 0.8
        let animTotalDuration = CGFloat(1)
        let animItemDuration = animTotalDuration / CGFloat(values.count)
        let total = values.reduce(0, +)
        var yOffset = CGFloat(0)
        
        workLayer = CAShapeLayer()
        workLayer.frame = chartView.layer.bounds
        workLayer.fillColor = UIColor.clear.cgColor
        chartView.layer.addSublayer(workLayer)

        for (index, value) in values.enumerated() {

            let percent = CGFloat(value / (total / 100))
            let availableWidth = workLayer.bounds.width - (spacing * CGFloat(index))
            let width = availableWidth * (percent / 100)
            let height = workLayer.bounds.height

            let startPath = UIBezierPath(rect: .init(x: yOffset, y: 0, width: 0, height: height))
            let path = UIBezierPath(rect: .init(x: yOffset, y: 0, width: width, height: height))

            let layer = CAShapeLayer()
            layer.path = startPath.cgPath

            layer.fillColor = colors[index].cgColor

            workLayer.addSublayer(layer)
            
            layer.animatePath(endPath: path.cgPath,
                              duration: animItemDuration,
                              delay: animItemDuration * CGFloat(index))

            yOffset += width + spacing
        }
    }
}
