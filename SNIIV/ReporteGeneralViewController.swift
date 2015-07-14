

import UIKit

class ReporteGeneralViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var opt = ["Nacional","Aguascalientes", "Baja California", "Baja California Sur", "Campeche", "Coahuila", "Colima", "Chiapas" , "Chihuahua", "Distrito Federal", "Durango", "Guanajuato", "Guerrero","Hidalgo", "Jalisco",
        "México", "Michoacán", "Morelos", "Nayarit", "Nuevo León" , "Oaxaca", "Puebla", "Querétaro", "Quintana Roo", "San Luis Potosí", "Sinaloa", "Sonora", "Tabasco", "Tamaulipas", "Tlaxcala", "Veracruz", "Yucatán", "Zacatecas"]

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtFinanMto: UILabel!
    @IBOutlet weak var txtFinanAcc: UILabel!
    @IBOutlet weak var txtSubAcc: UILabel!
    @IBOutlet weak var txtSubMto: UILabel!
    @IBOutlet weak var txtViviendasVigentes: UILabel!
    @IBOutlet weak var txtViviendasRegistradas: UILabel!
    var rowSelected = 0
    var entidad: DatoEntidad?
    var datos: DatosReporteGeneral?
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        picker.userInteractionEnabled = false
        
        indicator.startAnimating()
        if Reachability.isConnectedToNetwork() {
            var parseSoap = ParseSoap()
            parseSoap.getDatosReporte(handler)
            picker.userInteractionEnabled = true
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [ReporteGeneralPrueba]?, error: NSError?) {
        if (error) != nil {
            println("Error obteniendo datos")
            return
        }
        
        datos = DatosReporteGeneral(datos: responseObject!)
        entidad = datos!.consultaNacional()
        
        CRUDReporteGeneral.deleteReporteGeneral()
        for d in datos!.datos {
            CRUDReporteGeneral.saveReporteGeneral(d)
        }
    }
    
    func loadFromStorage() {
        let datosStorage = CRUDReporteGeneral.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosReporteGeneral(datos: datosStorage)
            entidad = datos?.consultaNacional()
            picker.userInteractionEnabled = true
        } else {
            println("no hay datos en local storage")
        }
    }

    override func viewDidAppear(animated: Bool) {
        mostrarDatos()
        indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return opt.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return opt[row]
    }
    
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = opt[row]
    
        if row == 0 {
            entidad = datos?.consultaNacional()
        } else {
            entidad = datos?.consultaEntidad(Entidad(rawValue: row)!)
        }
    
        mostrarDatos()
    }
    
    func mostrarDatos() {
        if entidad != nil {
            txtFinanAcc.text = Utils.toString(entidad!.accFinan)
            txtFinanMto.text = Utils.toString(entidad!.mtoFinan, divide: 1000000)
            txtSubAcc.text = Utils.toString(entidad!.accSubs)
            txtSubMto.text = Utils.toString(entidad!.mtoSubs, divide: 1000000)
            txtViviendasVigentes.text = Utils.toString(entidad!.vv)
            txtViviendasRegistradas.text = Utils.toString(entidad!.vr)
        }
    }
}
