//
//  DAFProgressView.swift
//  XMLParsingSpeed
//
//  Created by David Flores on 3/18/16.
//  Copyright © 2016 David Flores. All rights reserved.
//

import UIKit

class DAFProgressView : UIView
{
    private var trialCount = UInt64(0)
    private var trialIndex = UInt64(0)
    private let trialPath = UIBezierPath()
    
    private var preferredScale : CGFloat
    {
        typealias ScaleContextType = (maxX: CGFloat, maxY: CGFloat, preferredScale: CGFloat)
        
        var scaleContext : ScaleContextType = (self.bounds.midX, self.bounds.midY, CGFloat.max)
        
        CGPathApply(trialPath.CGPath, &scaleContext)
        {
            (contextPointer: UnsafeMutablePointer<Void>, pathElementPointer: UnsafePointer<CGPathElement>) -> Void in

            let scaleContextPointer = UnsafeMutablePointer<ScaleContextType>(contextPointer)
            
            if pathElementPointer.memory.type == .AddLineToPoint
            {
                let preferredScale = scaleContextPointer.memory.preferredScale
                
                let x = abs(pathElementPointer.memory.points.memory.x)
                if x > 0
                {
                    let maxX = scaleContextPointer.memory.maxX
                    let proposedPreferredScale = maxX / x
                    if proposedPreferredScale < preferredScale
                    {
                        scaleContextPointer.memory.preferredScale = proposedPreferredScale
                    }
                }
                
                let y = abs(pathElementPointer.memory.points.memory.y)
                if y > 0
                {
                    let maxY = scaleContextPointer.memory.maxY
                    let proposedPreferredScale = maxY / y
                    if proposedPreferredScale < preferredScale
                    {
                        scaleContextPointer.memory.preferredScale = proposedPreferredScale
                    }
                }
            }
        }
        
        return scaleContext.preferredScale
    }
    
    var areTrialsComplete : Bool
    {
        return self.trialIndex == self.trialCount
    }
    
    convenience init(foregroundColor: UIColor, backgroundColor: UIColor)
    {
        self.init()
        
        let layer = self.layer as! CAShapeLayer
        
        layer.fillColor = foregroundColor.CGColor
        layer.strokeColor = layer.fillColor
        layer.backgroundColor = backgroundColor.CGColor
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()

        /*
        var transform = CGAffineTransformMakeScale(0.25, 0.25)
        transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(self.bounds.midX, self.bounds.midY), CGAffineTransformMakeScale(0.25, 0.25))

        self.transform = transform
*/
    }
    
    override class func layerClass() -> AnyClass
    {
        return CAShapeLayer.self
    }
    
    func beginWithTotalNumberOfTrials(trialCount: UInt64)
    {
        self.trialCount = trialCount
        self.trialIndex = 0
        
        self.trialPath.removeAllPoints()
        self.trialPath.moveToPoint(CGPointZero)
    }
    
    func addTrialWithMeasuredValue(measuredValue: Double)
    {
        guard !self.areTrialsComplete else
        {
            return
        }
        
        let hypotenuse = 100.0*measuredValue
        let theta = Double(self.trialIndex) * 2 * M_PI / Double(self.trialCount)
        let point = CGPoint(x: hypotenuse * cos(theta), y: hypotenuse * sin(theta))
        
        self.trialPath.addLineToPoint(point)

        let scale = self.preferredScale
        self.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(self.bounds.midX, self.bounds.midY), CGAffineTransformMakeScale(scale, scale))
        
        (self.layer as! CAShapeLayer).path = self.trialPath.CGPath
        
        /*
        let preferredScale = self.preferredScale
        var transform = CGAffineTransformMakeScale(preferredScale, preferredScale)
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(self.bounds.midX, self.bounds.midY))
        let scaledTrialPath = self.trialPath.copy()
        scaledTrialPath.applyTransform(transform)
        
        
        (self.layer as! CAShapeLayer).path = scaledTrialPath.CGPath
        */
        
/*
        let scaledTrialPath = self.trialPath.copy()
        let preferredScale = self.preferredScale
        scaledTrialPath.applyTransform(CGAffineTransformMakeScale(preferredScale, preferredScale))
        
        (self.layer as! CAShapeLayer).path = scaledTrialPath.CGPath
  */
        
        
        self.trialIndex += 1
    }
}
