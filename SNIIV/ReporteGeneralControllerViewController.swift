

import UIKit

class ReporteGeneralControllerViewController: UIViewController, NSURLConnectionDelegate, NSXMLParserDelegate {
    
   var mutableData: NSMutableData = NSMutableData.alloc()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getXML()->String{
        var requestXML=""
        var soapMessage = ""
        var urlString = "http://192.168.10.166:8005/WS_App_SNIIV.asmx"
        var url = NSURL(string: urlString)
        var theRequest = NSMutableURLRequest(URL: url!)
        var msgLength = String(count(soapMessage))
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        theRequest.addValue("http://www.conavi.gob.mx:8080/WS_App_SNIIV/get_tot_ini", forHTTPHeaderField: "SOAPAction")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)

        return requestXML;
    }
    
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        mutableData.length = 0
    }
    
    func connection(connect: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
        currentElementName = elementName
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        println(string)
        if currentElementName == "CelsiusToFahrenheitResult" {
            txtFahrenheit.text = string
        }
    }
    
 
}
