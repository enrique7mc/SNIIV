

import UIKit

class ReporteGeneralViewController: UIViewController, NSURLConnectionDelegate, NSXMLParserDelegate {
    
    var mutableData: NSMutableData = NSMutableData.alloc()
    var currentElementName: NSString = ""
    var requestXML=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getXML()
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getXML()->String{
        println("xml")
        var soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'> <soap:Body> <get_tot_ini xmlns='http://www.conavi.gob.mx:8080/WS_App_SNIIV' /></soap:Body></soap:Envelope>"
        
        var urlString = "http://192.168.10.166:8005/WS_App_SNIIV.asmx"
        var url = NSURL(string: urlString)
        var theRequest = NSMutableURLRequest(URL: url!)
        var msgLength = String(count(soapMessage))
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.addValue("http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_tot_ini", forHTTPHeaderField: "SOAPAction")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
       
        var connection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        connection?.start()
        
        if(connection == true) {
            var mutableData : Void = NSMutableData.initialize()
            println(":,(")
        }
        else
        {
             println(":D")
        }
       
        return requestXML;
    }
    
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        mutableData.length=0
        println("con")
     
    }
    
    func connection(connect: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
        println(mutableData)
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        println("confinish")
        var xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        println("p1")
        currentElementName = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        println(string)
        if currentElementName == "get_tot_iniResult" {
            requestXML = string!
            println("p2")
        }
    }
    
    
}
