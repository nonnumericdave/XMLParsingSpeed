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
        
        self.transform = CGAffineTransformMakeTranslation(self.bounds.midX, self.bounds.midY)
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
        
        let hypotenuse = 75*measuredValue
        let theta = Double(self.trialIndex) * 2 * M_PI / Double(self.trialCount)
        let point = CGPoint(x: hypotenuse * cos(theta), y: hypotenuse * sin(theta))
        
        self.trialPath.addLineToPoint(point)
        
        (self.layer as! CAShapeLayer).path = self.trialPath.CGPath

        self.trialIndex += 1
    }
}
