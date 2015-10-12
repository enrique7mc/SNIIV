//
//  SoapToXml.swift
//  SNIIV
//
//  Created by admin on 09/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class SoapToXml {
    var message: String
    var urlString: String
    var soapAction: String
    var method: String
    var handler: (NSURLResponse!, NSData!, NSError!) -> Void
    var xmlResponse: String?
    
    init(message: String, url: String, soapAction: String, method: String, completionHandler handler: (NSURLResponse!, NSData!, NSError!) -> Void) {
        self.message = message
        self.urlString = url
        self.soapAction = soapAction
        self.method = method
        self.handler = handler
    }
    
    func responseXlm() {
        var url = NSURL(string: urlString)
        var theRequest = NSMutableURLRequest(URL: url!)
        var msgLength = String(message.characters.count)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.addValue(soapAction, forHTTPHeaderField: "SOAPAction")
        theRequest.HTTPMethod = method.uppercaseString
        theRequest.HTTPBody = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(theRequest, queue: queue, completionHandler: handler)
    }
}