//
//  ParseFechasWeb.swift
//  SNIIV
//
//  Created by admin on 24/08/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SWXMLHash

class ParseFechasWeb<T>: ParseBase<Fechas> {
    
    init() {
        super.init(action: "http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_fechas_act")
    }
    
    override func handler(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void {
        let httpResponse = response as! NSHTTPURLResponse
        
        if error != nil || httpResponse.statusCode != 200 {
            print("Fechas status code: \(httpResponse.statusCode)", terminator: "")
            self.serviceResponse!(Fechas(), NSError())
        } else {
            if let dataString = NSString(data: data, encoding:NSUTF8StringEncoding) {
                self.xmlResponse = dataString as String
                var xml = SWXMLHash.parse(self.xmlResponse)
                var elemFechas = xml["soap:Envelope"]["soap:Body"]["get_fechas_actResponse"]["get_fechas_actResult"]
                
                let jsonString = Utils.getText(elemFechas)
                let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
                let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    as? [String: AnyObject]
                println("FECHAAAS \(jsonResult)")
                
                if let fechas = jsonResult {
                    var fechas = Fechas(fechasDictionary: fechas)
                    self.serviceResponse!(fechas, nil)
                }            
            }
        }
    }
}
