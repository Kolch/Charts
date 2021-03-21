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
}
