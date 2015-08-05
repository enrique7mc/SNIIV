//
//  ParseBase.swift
//  SNIIV
//
//  Created by admin on 16/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class ParseBase<T> {
    var xmlResponse: String = ""
    var action: String
    var urlString: String
    var message: String
    var serviceResponse: ((T, NSError?) -> Void)?
    
    init(action: String) {
        self.action = action
        self.urlString = "\(Utils.WEB_SERVICE_URL)/WS_App_SNIIV.asmx"
        self.message = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body> <get_tot_ini xmlns='http://www.conavi.gob.mx:8080/WS_App_SNIIV' /></soap:Body></soap:Envelope>"
    }
    
    func getXml() {
        var soapToXml = SoapToXml(message: message, url: urlString, soapAction: action, method: "POST", completionHandler: handler)
        soapToXml.responseXlm()
    }
    
    func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        println("Handler not implemented")
    }
    
    func getDatos(onCompletion: (T, NSError?) -> Void) {
        getXml()
        serviceResponse = onCompletion
    }
}
