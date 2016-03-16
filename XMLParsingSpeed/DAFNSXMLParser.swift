//
//  DAFNSXMLParser.swift
//  XMLParsingSpeed
//
//  Created by David Flores on 3/15/16.
//  Copyright © 2016 David Flores. All rights reserved.
//

import Foundation

class DAFNSXMLParser : NSObject, DAFXMLParser, NSXMLParserDelegate
{
    private var elementCount = UInt64(0)
    
    func parseXMLFileAtPath(urlFilePath: NSURL) -> (NSTimeInterval, UInt64)
    {
        let parser = NSXMLParser(contentsOfURL: urlFilePath)
        
        parser?.delegate = self
        self.elementCount = 0

        let startDate = NSDate()
        parser?.parse()
        let timeInterval = startDate.timeIntervalSinceNow
        
        return (-timeInterval, self.elementCount)
    }
    
    func parser(
        parser: NSXMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String])
    {
        self.elementCount += 1
    }
}
