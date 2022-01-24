//
//  BarChart.swift
//  Charts
//
//  Created by Alex Kolchedantsev on 21.03.2021.
//

import UIKit


class BarChart: UIView {
    
    enum PeriodType: Int, CaseIterable {
        case day, week, month, month3, year
        var spacing: CGFloat { [0.0064308682, 0.0432647059, 0.0145772595, 0.0094308682, 0.0352647059 ][rawValue] }
    }
    
    enum ScheduleType { case doubleColor([DataPoint]), multiColor([DataPoint]) }
    
    var dataPoints: [DataPoint] = []
    
    func setup(type: ScheduleType, period: PeriodType) {
        layer.removeSublayers()
        
        switch type {
        case .doubleColor(let data):
            dataPoints = data
            scheduleDoubleColor(period: period, dataPoints: data)
        case .multiColor(let data):
            dataPoints = data
            scheduleMultiColor(period: period, dataPoints: data)
        }
    }
    
    private func scheduleDoubleColor(period: PeriodType, dataPoints: [DataPoint]) {

        let values      = dataPoints.map { $0.value }
        let space       = bounds.width * period.spacing
        let allSpace    = CGFloat(values.count - 1) * space
        let lineWidth   = (bounds.width - allSpace) / CGFloat(values.count)
        
        for (index, value) in values.enumerated() {
            
            guard let max = values.max() else { return }
            let percent = 100 / CGFloat(max / value)
            
            let lineHeight = bounds.height * ((percent > 0 ? percent : 2) / 100)
            
            let traveled = lineWidth * CGFloat(index) + space * CGFloat(index)
            
            let startPathRect = CGRect(x: traveled, y: bounds.height, width: lineWidth, height: 0)
            let startPath = UIBezierPath(roundedRect: startPathRect, cornerRadius: 2)
            
            let endPathRect = CGRect(x: traveled, y: bounds.height - lineHeight, width: lineWidth, height: lineHeight)
            let endPath = UIBezierPath(roundedRect: endPathRect, cornerRadius: 2)
            
            self.dataPoints[index].rect = endPathRect
            
            let lineLayer = CAShapeLayer()
            
            lineLayer.path = startPath.cgPath
            lineLayer.fillColor = dataPoints[index].color.ui.cgColor
            layer.addSublayer(lineLayer)
            lineLayer.animatePath(endPath: endPath.cgPath, duration: 0.7)

            
            if let redData = dataPoints[index].complexValues.first {
                let redLineHeight = lineHeight * min(redData.0 / value, 0.999)
                
                let redLayer = CAShapeLayer()
                let redEndPathRect = CGRect(x: traveled, y: bounds.height - redLineHeight,
                                            width: lineWidth, height: redLineHeight)
                let redEndPath = UIBezierPath(roundedRect: redEndPathRect, cornerRadius: 2)
                
                redLayer.fillColor = UIColor.chartRed.cgColor
            
                redLayer.path = startPath.cgPath
                lineLayer.addSublayer(redLayer)
                
                redLayer.animatePath(endPath: redEndPath.cgPath, duration: 0.7)
            }
        }
    }
    
    private func scheduleMultiColor(period: PeriodType, dataPoints: [DataPoint]) {
        
        let values = dataPoints.map { $0.value }
        let space = bounds.width * period.spacing
        let allSpace = CGFloat(values.count - 1) * space
        let lineWidth = (bounds.width - allSpace) / CGFloat(values.count)
        for (index, value) in values.enumerated() {
            
            guard let max = values.max() else { return }
            let percent = 100 / CGFloat(max / value)
            
            let lineHeight = bounds.height * ((percent > 0 ? percent : 2) / 100)
            
            let traveled = lineWidth * CGFloat(index) + space * CGFloat(index)
            
            let startPathRect = CGRect(x: traveled, y: bounds.height, width: lineWidth, height: 0)
            let startPath = UIBezierPath(roundedRect: startPathRect, cornerRadius: 2)
            
            let endPathRect = CGRect(x: traveled, y: bounds.height - lineHeight, width: lineWidth, height: lineHeight)
            let endPath = UIBezierPath(roundedRect: endPathRect, cornerRadius: 2)
            
            self.dataPoints[index].rect = endPathRect
            
            let lineLayer = CAShapeLayer()
            
            lineLayer.path = startPath.cgPath
            lineLayer.fillColor = dataPoints[index].color.ui.cgColor
            layer.addSublayer(lineLayer)
            lineLayer.animatePath(endPath: endPath.cgPath, duration: 0.7)
            
            if value == 0 { continue }
            
            var extraLayerYOffset = CGFloat(0)
            for (index, _value) in dataPoints[index].complexValues.enumerated() {
                
                let extraLayer = CAShapeLayer()
                let extraLayerLineHeight = lineHeight * min(_value.0 / value, 0.999)
                
                let cornerRadii = CGSize(width: index == 0 ? 2 : 0, height: index == 0 ? 2 : 0)
                let _y = bounds.height - lineHeight + extraLayerYOffset
                
                
                let _endPathRect = CGRect(x: traveled, y: _y, width: lineWidth, height: extraLayerLineHeight)
                
                let _endPath = UIBezierPath(roundedRect: _endPathRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerRadii)

                let _startPathRect = CGRect(x: traveled, y: _endPathRect.minY, width: lineWidth, height: 0)
                let _startPath =  UIBezierPath(roundedRect: _startPathRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerRadii)

                extraLayer.fillColor = _value.1.ui.cgColor
                extraLayer.path = _startPath.cgPath
                lineLayer.addSublayer(extraLayer)
                extraLayer.animatePath(endPath: _endPath.cgPath, duration: 0.4, delay: 0.5)
                
                extraLayerYOffset += extraLayerLineHeight
            }
        }
    }
}

extension BarChart {
    
    enum Color: Int, CaseIterable { case blue, yellow, red, pink, violet, green
        var ui: UIColor { [.chartBlue, .chartYellow, .chartRed, .chartPink, .chartPurple, .chartGreen][rawValue]}
    }
    
    struct DataPoint: Equatable {
        var label: Any?
        var value: CGFloat
        var rect: CGRect?
        var color: Color = .blue
        var complexValues = [(CGFloat, Color)]() {
            didSet { complexValues = complexValues.sorted(by: { $0.1.rawValue > $1.1.rawValue })} }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.value == rhs.value
        }
    }
}
