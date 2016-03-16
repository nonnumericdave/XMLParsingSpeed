//
//  DAFLibXML2Parser.swift
//  XMLParsingSpeed
//
//  Created by David Flores on 3/15/16.
//  Copyright © 2016 David Flores. All rights reserved.
//

import Foundation

class DAFLibXML2Parser : DAFXMLParser
{
    private var elementCount : UInt64 = 0
    
    func SAXParseXMLFileAtPath(urlFilePath: NSURL) -> (NSTimeInterval, UInt64)
    {
        var xmlHandler = xmlSAXHandler()
        xmlHandler.startElement =
        {
            (contextPointer: UnsafeMutablePointer<Void>, _, _) -> Void in
            Unmanaged<DAFLibXML2Parser>.fromOpaque(COpaquePointer(contextPointer)).takeUnretainedValue().elementCount += 1
        }
        
        self.elementCount = 0
        
        let startDate = NSDate()
        xmlSAXUserParseFile(&xmlHandler,
            UnsafeMutablePointer(Unmanaged.passUnretained(self).toOpaque()),
            urlFilePath.fileSystemRepresentation)
        let timeInterval = startDate.timeIntervalSinceNow
        
        return (timeInterval, self.elementCount)
    }
}
