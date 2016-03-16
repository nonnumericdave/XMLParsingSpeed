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
     Parser results for testing.
     
     - LibXML2: The LibXML2 SAX parser.
     - NSXML: The NSXMLParser SAX parser.
     */
    enum ParserResult
    {
        case LibXML2(parsingTime: NSTimeInterval, elementCount: UInt64)
        case NSXML(parsingTime: NSTimeInterval, elementCount: UInt64)
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
     
        - Parameter parser: The parser result for this trial.
     */
    typealias TrialClosure =
        (parserResult : ParserResult) -> Void
    
    /**
        Runs randomly-assorted trials for the parsers.
     
        - Parameter trialClosure: The closure used as the callback for the trial results.
     
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
        
        for trialIndex in randomPermuationRange
        {
            let parserResult =
                trialIndex % 2 == 0 ?
                    ParserResult.LibXML2(libXML2Parser.parseXMLFileAtPath(nasaFileURL)) :
                    ParserResult.NSXML(nsXMLParser.parseXMLFileAtPath(nasaFileURL))
            
           trialClosure(parserResult: parserResult)
        }
        
        return true
    }
}
