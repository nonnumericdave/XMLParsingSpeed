//
//  DAFXMLParserProfiler.swift
//  XMLParsingSpeed
//
//  Created by David Flores on 3/16/16.
//  Copyright © 2016 David Flores. All rights reserved.
//

import Foundation

class DAFXMLParserProfiler
{
    private let trialRange : Range<UInt64>
    private let libXML2Parser = DAFLibXML2Parser()
    private let nsXMLParser = DAFNSXMLParser()

    /**
     Parser used for testing.
     
     - LibXML2: The LibXML2 SAX parser.
     - NSXML: The NSXMLParser SAX parser.
     */
    enum Parser
    {
        case LibXML2
        case NSXML
    }
    
    /**
        Creates a DAFXMLParserProfiler.
     
        - Parameter trialsPerParser: The number of trials to run per parser.
     */
    init(trialsPerParser: UInt64)
    {
        self.trialRange = 1...trialsPerParser
    }

    /**
        The callback used to specify the progress of the parser trials.
     
        - Parameter parser: The parser used during the current trial.
        - Parameter parsingTime: The time the parser took to complete the current trial.
        - Parameter elementCount: The number of elements parsed during current trial.
     */
    typealias TrialClosure =
        (parser: Parser, parsingTime: NSTimeInterval, elementCount: UInt64) -> Void
    
    /**
        Runs randomly-assorted trials for the parsers.
     
        - Parameter trialsPerParser: The number of trials to run per parser.
     
        - Returns: If all trials were attempted, returns true, otherwise returns false.
     */
    func runRandomlyAssortedParserTrials(@noescape trialClosure: TrialClosure) -> Bool
    {
        guard let nasaFileURL = NSBundle.mainBundle().URLForResource("nasa", withExtension: "xml")
        else
        {
            return false
        }
        
        var randomPermuationRange = Array<UInt64>(trialRange)
        for (index, value) in randomPermuationRange.reverse().enumerate()
        {
            let swapIndex = Int(arc4random()) % (index + 1)
            randomPermuationRange[index] = randomPermuationRange[swapIndex]
            randomPermuationRange[swapIndex] = value
        }
        
        var (parsingTime, elementCount, parser) : (NSTimeInterval, UInt64, Parser)
        for trialIndex in randomPermuationRange
        {
            if ( trialIndex % 2 == 0 )
            {
                parser = .LibXML2
                (parsingTime, elementCount) = libXML2Parser.parseXMLFileAtPath(nasaFileURL)
            }
            else
            {
                parser = .NSXML
                (parsingTime, elementCount) = nsXMLParser.parseXMLFileAtPath(nasaFileURL)
            }
            
            trialClosure(parser: parser, parsingTime: parsingTime, elementCount: elementCount)
        }
        
        return true
    }
}
