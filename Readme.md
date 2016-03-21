## XMLParsingSpeed
Comparing the speed of libxml2 with NSXMLParser when both are used in SAX-based mode.

### Description
It has always appeared that NSXMLParser is much slower than libxml2, when it comes to parsing XML with a SAX-based parser.   This is simply a project that aims to show the difference in speed over the course of a number of trials.

### Requirements
This project was designed and built against Xcode 7.2.1, but will probably work with an earlier version.  In order to build this correctly, you will need to add an additonal folder:

XMLParsingSpeed/XMLParsingSpeed/SampleXMLFiles

to the project.  Underneath that folder, you will need to copy the "nasa.xml" file located at:

[Univeristy of Washington XML Data Repository](http://www.cs.washington.edu/research/xmldatasets/www/repository.html)

Ensure that "nasa.xml" gets copied to the bundle inside "Copy Bundle Resources" under the "Build Phases" tab.
