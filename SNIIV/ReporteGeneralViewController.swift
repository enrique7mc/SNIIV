

import UIKit

class ReporteGeneralViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var parseSoap = ParseSoap()
        parseSoap.getDatosReporte() { (responseObject:[ReporteGeneralPrueba]?, error:NSError?) in
            
            if (error) != nil {
                println("Error obteniendo datos")
                return
            }
            
            println(responseObject!.count)
            var datos = DatosReporteGeneral(datos: responseObject!)
            var result = datos.consultaNacional()
            println(result.accFinan)
            println(result.mtoFinan)
            println(result.accSubs)
            println(result.mtoSubs)
            println(result.vv)
            println(result.vr)
            
            var entidad = datos.consultaEntidad(.DF)
            println("\n\(entidad.accFinan)")
            println(entidad.mtoFinan)
            println(entidad.accSubs)
            println(entidad.mtoSubs)
            println(entidad.vv)
            println(entidad.vr)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
