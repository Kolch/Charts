//
//  CALayer+Ext.swift
//  Charts
//
//  Created by Alex Kolchedantsev on 21.03.2021.
//

import UIKit

enum LayerAnimation: String {
    case opacity   = "opacity"
    case transform = "transform"
    case strokeEnd = "strokeEnd"
    case fillColor = "fillColor"
}

extension CALayer {
    
    func hideAndHow(with keyPath: LayerAnimation, delay: Double = 0.3, duration: Double = 1.3) {
        let animation       = CABasicAnimation(keyPath : keyPath.rawValue)
        animation.fromValue = 0
        animation.duration  = duration
        animation.beginTime = CACurrentMediaTime() + delay
        
        let hide = Animation.hide()
        hide.duration = animation.beginTime - CACurrentMediaTime()
        
        add(hide, forKey: nil)
        add(animation, forKey: nil)
    }
    
    func hide() {
        let hide = Animation.hide()
        add(hide, forKey: nil)
    }
    
    func show(delay: Double = 0.3, duration: Double = 1.3) {
        let animation       = Animation.transform(to: 1)
        animation.fromValue = 0
        animation.duration  = duration
        animation.beginTime = CACurrentMediaTime() + delay
        add(animation, forKey: nil)
    }
    
    func removeSublayers() {
        sublayers?.forEach({ $0.removeFromSuperlayer() })
    }
    
    func addSublayers(_ layers: [CALayer]) {
        layers.forEach({ addSublayer($0) })
    }
    
    func animatePath(endPath: CGPath, duration: Double = 1, delay: Double = 0) {
        let animation = CABasicAnimation()
        animation.keyPath = "path"
        animation.duration = duration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.toValue = endPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        add(animation, forKey: "line")
    }
    
    func applyClockWipeMaskAnimation(duration: CFTimeInterval = 1) {
        let shapeLayer = CAShapeLayer()
        let maskHeight = bounds.height
        let maskWidth  = bounds.width
        
        let centerPoint = CGPoint( x: bounds.midX, y: bounds.midY)
        let radius = (maskWidth * maskWidth + maskHeight * maskHeight).squareRoot() / 2.0
        
        shapeLayer.strokeColor = UIColor.black.cgColor
        
       
        shapeLayer.lineWidth = radius
        
        let startAngle = 2 * CGFloat.pi
        let endAngle   = 0.0
        let path       = CGMutablePath()
        
        path.addArc(center: centerPoint,
                    radius: radius/2,
                    startAngle: startAngle ,
                    endAngle: endAngle,
                    clockwise: true)
        shapeLayer.path = path
        
        shapeLayer.strokeEnd = 0
        
        mask = shapeLayer
        
        let clockWipe = CABasicAnimation(keyPath: LayerAnimation.strokeEnd.rawValue)
        
        clockWipe.duration              = duration
        clockWipe.toValue               = 1
        clockWipe.isRemovedOnCompletion = false
        clockWipe.fillMode              = .forwards
        clockWipe.timingFunction        = CAMediaTimingFunction(name: .easeIn)
        
        shapeLayer.add(clockWipe, forKey: "clockWipe")
    }
}
