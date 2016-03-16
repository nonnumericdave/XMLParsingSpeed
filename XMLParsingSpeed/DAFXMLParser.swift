//
//  DAFXMLParser.swift
//  XMLParsingSpeed
//
//  Created by David Flores on 3/15/16.
//  Copyright © 2016 David Flores. All rights reserved.
//

import Foundation

protocol DAFXMLParser
{
    /**
        Parse XML document located at URL file path in a SAX-like manner,
        returning the time interval required to complete the parse.
    
        - Parameter urlFilePath: The URL file path for the XML document.
     
        - Returns: The time interval required to complete the parse, along with
            the number of elements in the XML document.
     */
    func SAXParseXMLFileAtPath(urlFilePath: NSURL) -> (NSTimeInterval, UInt64)
}
