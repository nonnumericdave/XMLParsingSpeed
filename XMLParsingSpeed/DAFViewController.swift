//
//  DAFViewController.swift
//  XMLParsingSpeed
//
//  Created by David Flores on 3/15/16.
//  Copyright © 2016 David Flores. All rights reserved.
//

import UIKit

class DAFViewController : UIViewController
{
    private let trialsPerParser = UInt64(100)
    private let libXML2ProgressView =
        DAFProgressView(foregroundColor: UIColor.whiteColor(), backgroundColor: UIColor.blackColor())
    private let nsXMLProgressView =
        DAFProgressView(foregroundColor: UIColor.whiteColor(), backgroundColor: UIColor.blackColor())
    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()
    
    @IBOutlet var performXMLProfilingButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.libXML2ProgressView.hidden = true
        self.view.addSubview(self.libXML2ProgressView)
        self.libXML2ProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        self.nsXMLProgressView.hidden = true
        self.view.addSubview(self.nsXMLProgressView)
        self.nsXMLProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints : [NSLayoutConstraint] = [
            self.libXML2ProgressView.widthAnchor.constraintEqualToAnchor(self.nsXMLProgressView.widthAnchor),
            self.libXML2ProgressView.heightAnchor.constraintEqualToAnchor(self.nsXMLProgressView.heightAnchor),
            self.libXML2ProgressView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor),
            self.libXML2ProgressView.topAnchor.constraintEqualToAnchor(self.view.topAnchor),
            self.nsXMLProgressView.rightAnchor.constraintEqualToAnchor(self.view.rightAnchor),
            self.nsXMLProgressView.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        portraitConstraints = [
            self.libXML2ProgressView.leftAnchor.constraintEqualToAnchor(self.nsXMLProgressView.leftAnchor),
            self.libXML2ProgressView.bottomAnchor.constraintEqualToAnchor(self.nsXMLProgressView.topAnchor, constant: -20)
        ]

        portraitConstraints.forEach
        {
            $0.priority = 750
        }
        
        landscapeConstraints = [
            self.libXML2ProgressView.topAnchor.constraintEqualToAnchor(self.nsXMLProgressView.topAnchor),
            self.libXML2ProgressView.rightAnchor.constraintEqualToAnchor(self.nsXMLProgressView.leftAnchor, constant: -20)
        ]

        landscapeConstraints.forEach
        {
            $0.priority = 750
        }
        
        self.updateConstraintsForSize(self.view.bounds.size)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.updateConstraintsForSize(size)
        
        coordinator.animateAlongsideTransition(
            {
                (_) -> Void in
                
                self.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        let scale =
            min(self.libXML2ProgressView.preferredScale, self.nsXMLProgressView.preferredScale)
     
        self.libXML2ProgressView.scale = scale
        self.nsXMLProgressView.scale = scale
    }
    
    @IBAction
    func performXMLProfiling(sender: AnyObject)
    {
        self.performXMLProfilingButton.hidden = true
        self.libXML2ProgressView.hidden = false
        self.nsXMLProgressView.hidden = false
        
        self.libXML2ProgressView.beginWithTotalNumberOfTrials(self.trialsPerParser)
        self.nsXMLProgressView.beginWithTotalNumberOfTrials(self.trialsPerParser)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0))
        {
            () -> Void in
    
            let xmlParserProfiler = DAFXMLParserProfiler(trialsPerParser: self.trialsPerParser)
            
            xmlParserProfiler.runRandomlyAssortedParserTrials
            {
                (parserResult) -> Void in

                switch (parserResult)
                {
                case let .LibXML2(parsingTime, _):
                    self.performSelectorOnMainThread("didCompleteLibXML2ParseWithParsingTime:",
                        withObject: NSNumber(double: parsingTime),
                        waitUntilDone: false)
                    
                case let .NSXML(parsingTime, _):
                    self.performSelectorOnMainThread("didCompleteNSXMLParseWithParsingTime:",
                        withObject: NSNumber(double: parsingTime),
                        waitUntilDone: false)
                }
            }
        }
    }
    
    @objc(didCompleteLibXML2ParseWithParsingTime:)
    private func didCompleteLibXML2Parse(parsingTime : NSNumber)
    {
        self.libXML2ProgressView.addTrialWithMeasuredValue(parsingTime.doubleValue)
        
        let libXML2Scale = self.libXML2ProgressView.scale
        if libXML2Scale < self.nsXMLProgressView.scale
        {
            self.nsXMLProgressView.scale = libXML2Scale
        }
    }
    
    @objc(didCompleteNSXMLParseWithParsingTime:)
    private func didCompleteNSXMLParse(parsingTime : NSNumber)
    {
        self.nsXMLProgressView.addTrialWithMeasuredValue(parsingTime.doubleValue)

        let nsXMLScale = self.nsXMLProgressView.scale
        if nsXMLScale < self.libXML2ProgressView.scale
        {
            self.libXML2ProgressView.scale = nsXMLScale
        }
    }
    
    private func updateConstraintsForSize(size: CGSize)
    {
        NSLayoutConstraint.deactivateConstraints(portraitConstraints)
        NSLayoutConstraint.deactivateConstraints(landscapeConstraints)
        NSLayoutConstraint.activateConstraints(size.width < size.height ? portraitConstraints : landscapeConstraints)
    }
}
