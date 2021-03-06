

import UIKit

class ReporteGeneralControllerViewController: UIViewController, NSURLConnectionDelegate, NSXMLParserDelegate {
    
   var mutableData: NSMutableData = NSMutableData.alloc()
   var currentElementName: NSString = ""
   var requestXML=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("idaiosndioasndioasndi")
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("idaiosndioasndioasndi")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getXML()->String{
      
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
        var connection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        connection?.start()
        
        if(connection == true) {
            var mutableData : Void = NSMutableData.initialize()
        }
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
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!,  qName: String!, attributes attributeDict: NSDictionary!) {
        currentElementName = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters : String?) {
       NSLog("%@", foundCharacters!)
        if currentElementName == "get_tot_iniResult" {
            if let chars=foundCharacters{
                requestXML = chars
            }
        }
            
    }
    
 
}
