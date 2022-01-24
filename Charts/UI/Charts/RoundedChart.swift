//
//  RoundedChart.swift
//  Charts
//
//  Created by Alex Kolchedantsev on 24.01.2022.
//

import UIKit

class RoundedChart: UIView {
    
    private var chartLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        setup()
    }
    
    private func setup() {
        contentMode = .redraw
        backgroundColor = .clear
        isOpaque = false
    }
    
    func setup(values: [(CGFloat, UIColor)]) {
        clear()
        
        let values = values.filter({ $0.0 > 0 })
        chartLayer.frame = layer.bounds
        
        let bounds = self.bounds
        let radius = min(bounds.size.width, bounds.size.height) / 2
        let summ = values.map({ $0.0 }).reduce(0, +)
        let space = values.count > 1 ? (CGFloat.pi * 0.025) : 0
        let allSpace = CGFloat(values.count) * space
        var lastAgle = space
        
        for value in values {
            let percent = CGFloat(100 / (summ / value.0))
            let lineAgle = ((CGFloat.pi * 2) - allSpace) * (percent / 100)
            let finishAgle = lastAgle + lineAgle
            
            let path = UIBezierPath()
            path.addArc(withCenter: .zero, radius: radius, startAngle: lastAgle,
                        endAngle: finishAgle, clockwise: true)
            path.addArc(withCenter: .zero, radius: radius - 15, startAngle: finishAgle,
                        endAngle: lastAgle, clockwise: false)
            
            
            path.apply(CGAffineTransform(translationX: bounds.midX, y: bounds.midY))
            
            let layer       = CAShapeLayer()
            layer.path      = path.cgPath
            layer.fillColor = value.1.cgColor

            chartLayer.addSublayer(layer)
            lastAgle = finishAgle + space
        }
        
        let rotarion = 270 * (CGFloat.pi / 180)
        let tt = CATransform3DMakeRotation(rotarion, 0, 0, 1)
        chartLayer.transform = tt
        
        
        layer.addSublayer(chartLayer)
        
        chartLayer.applyClockWipeMaskAnimation(duration: 1.7)
    }
    
    func clear() {
        chartLayer.removeFromSuperlayer()
        chartLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}



