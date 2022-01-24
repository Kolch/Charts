//
//  Animations.swift
//  Charts
//
//  Created by Alex Kolchedantsev on 21.03.2021.
//

import UIKit

struct Animation {
    
    static func transform(from fromValue: CGFloat = 1.0, to toValue: CGFloat) -> CABasicAnimation {
        let transformAnimation       = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(fromValue, fromValue, fromValue))
        transformAnimation.toValue   = NSValue(caTransform3D: CATransform3DMakeScale(toValue, toValue, toValue))
        
        return transformAnimation
    }
    
    static func transform(times: [NSNumber] = [0.0, 0.8, 1.0], values: [CGFloat] = [0.0, 1.1, 1.0], duration: CFTimeInterval = 0.7) -> CAKeyframeAnimation {
        var transformValues = [NSValue]()
        values.forEach {
            transformValues.append(NSValue(caTransform3D: CATransform3DMakeScale($0, $0, 1.0)))
        }
        let transformAnimation                   = CAKeyframeAnimation(keyPath: "transform")
        transformAnimation.duration              = duration
        transformAnimation.values                = transformValues
        transformAnimation.keyTimes              = times
        transformAnimation.fillMode              = CAMediaTimingFillMode.forwards
        transformAnimation.isRemovedOnCompletion = false
        
        return transformAnimation
    }
    
    static func hide() -> CABasicAnimation {
        let hideAnimation = transform(to: 0)
        return hideAnimation
    }
    
    public static func opacity(from fromValue: CGFloat, to toValue: CGFloat) -> CABasicAnimation {
        let opacityAnimation       = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = fromValue
        opacityAnimation.toValue   = toValue
        return opacityAnimation
    }
}
