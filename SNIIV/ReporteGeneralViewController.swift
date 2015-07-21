

import UIKit

class ReporteGeneralViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtFinanMto: UILabel!
    @IBOutlet weak var txtFinanAcc: UILabel!
    @IBOutlet weak var txtSubAcc: UILabel!
    @IBOutlet weak var txtSubMto: UILabel!
    @IBOutlet weak var txtViviendasVigentes: UILabel!
    @IBOutlet weak var txtViviendasRegistradas: UILabel!
    @IBOutlet weak var labelFinanciamiento: UITextField!
    @IBOutlet weak var labelSubsidios: UITextField!
    @IBOutlet weak var labelVivienda: UITextField!
    
    @IBOutlet weak var txtTitleOferta: UITextField!
    @IBOutlet weak var txtTitleSub: UITextField!
    @IBOutlet weak var txtTitleFinan: UITextField!
    
    var rowSelected = 0
    var entidad: ReporteGeneralPrueba?
    var datos: DatosReporteGeneral?
    var fechas: Fechas = Fechas()
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleOferta.enabled = false
        txtTitleFinan.enabled = false
        txtTitleSub.enabled = false
        indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        picker.userInteractionEnabled = false
        
        indicator.startAnimating()
        if Reachability.isConnectedToNetwork() {
            var parseFechas = ParseFechas<Fechas?>()
            parseFechas.getDatos(handlerFechas)
            var parseReporte = ParseReporteGeneral<[ReporteGeneralPrueba]>()
            parseReporte.getDatos(handler)
            
            picker.userInteractionEnabled = true
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [ReporteGeneralPrueba], error: NSError?) -> Void {
        if error != nil {
            println("Error obteniendo datos")
            return
        }
        
        datos = DatosReporteGeneral(datos: responseObject)
        entidad = datos!.consultaNacional()
        
        CRUDReporteGeneral.deleteReporteGeneral()
        for d in datos!.datos {
            CRUDReporteGeneral.saveReporteGeneral(d)
        }
    }
    
    func handlerFechas (responseObject: Fechas, error: NSError?) {
        if error != nil {
            println("Error obteniendo fechas")
            return
        }

        CRUDFechas.deleteFechas()
        
        fechas = responseObject
        CRUDFechas.saveFechas(fechas)
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
        
        let fechasStorage = CRUDFechas.selectFechas()
        if fechasStorage != nil {
            fechas = fechasStorage!
        } else {
            println("no hay fechas en local storage")
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
        return Utils.entidades.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return Utils.entidades[row]
    }
    
   func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = Utils.entidades[row]
    
        if row == 0 {
            entidad = datos?.consultaNacional()
        } else {
            entidad = datos?.consultaEntidad(Entidad(rawValue: row)!)
        }
    
        mostrarDatos()
    }
    
    func mostrarDatos() {
        if entidad != nil {
            txtFinanAcc.text = entidad!.accFinan
            txtFinanMto.text = entidad!.mtoFinan
            txtSubAcc.text = entidad!.accSubs
            txtSubMto.text = entidad!.mtoSubs
            txtViviendasVigentes.text = entidad!.vv
            txtViviendasRegistradas.text = entidad!.vr
        }
        
        
        labelFinanciamiento.text = "Financiamientos \(fechas.fecha_finan)"
        labelSubsidios.text = "Subsidios \(fechas.fecha_subs)"
        labelVivienda.text = "Oferta de Vivienda \(fechas.fecha_vv)"
        
    }
}
