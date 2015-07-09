

import UIKit

class ReporteGeneralViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var parseSoap = ParseSoap()
        parseSoap.getDatosReporte() { (responseObject:[ReporteGeneral]?, error:NSError?) in
            
            if ((error) != nil) {
                println("Error logging you in!")
            } else {
                println(responseObject!.count)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
