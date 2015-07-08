

import UIKit

class ReporteGeneralViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var parseSoap = ParseSoap()
        var result = parseSoap.getDatosReporte()
        println(result?.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
