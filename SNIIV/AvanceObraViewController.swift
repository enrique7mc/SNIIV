//
//  AvanceObraViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class AvanceObraViewController: BaseUIViewController {
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtCincuentaPorciento: UILabel!
    @IBOutlet weak var txtNoventaPorciento: UILabel!
    @IBOutlet weak var txtRecientes: UILabel!
    @IBOutlet weak var txtAntiguas: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    @IBOutlet weak var txtTitle: UILabel!
    var pParties: [String] = []
    var pValues: [Int64] = []
    @IBOutlet weak var bnChart: UIButton!
    var entidad: AvanceObra?
    var datos: DatosAvanceObra?
    var pTitulo: String? = "Avance de Obra"
    var pEstado:String? = ""
    var intEstado:Int=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.userInteractionEnabled = false
        activarIndicador()
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {
            var parseAvance = ParseAvanceObra<[AvanceObra]>()
            parseAvance.getDatos(handler)
            return
        }
      
        loadFromStorage()
    }

    func getData(){
        pParties = ["Hasta 50%", "Hasta 99%", "Recientes", "Antiguas"]
        pValues = [entidad!.viv_proc_m50,entidad!.viv_proc_50_99,entidad!.viv_term_rec, entidad!.viv_term_ant]
        pEstado = Utils.entidades[intEstado]
    }
    
    @IBAction func showChart(sender: AnyObject) {
        self.performSegueWithIdentifier("chartModal", sender: self)
    }
  
    func handler (responseObject: [AvanceObra], error: NSError?) -> Void {
        if error != nil {
            println("Error obteniendo datos")
            return
        }
        
        AvanceObraRepository.deleteAll()
        AvanceObraRepository.saveAll(responseObject)
        
        datos = DatosAvanceObra(datos: responseObject)
        entidad = datos!.consultaNacional()
        
        if let ultimaFecha = getFechaActualizacion() {
            TimeLastUpdatedRepository.saveLastTimeUpdated(getKey(), fecha: ultimaFecha)
        }
        
        loadFechasStorage()
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
        
        getData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "chartModal") {
            let gvc = segue.destinationViewController as! ChartViewController
            gvc.parties = pParties
            gvc.values = pValues
            gvc.titulo = pTitulo
            gvc.estado = pEstado
        }
    }
    
    override func loadFromStorage() {
        println("AvanceObra loadFromStorage")
        
        let datosStorage = AvanceObraRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosAvanceObra(datos: datosStorage)
            entidad = datos?.consultaNacional()
            picker.userInteractionEnabled = true
        } else {
            muestraMensajeError()
        }
        
        loadFechasStorage()
        
        habilitarPantalla()
        getData()
    }

    override func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = Utils.entidades[row]
        
        if row == 0 {
            entidad = datos?.consultaNacional()
        } else {
            entidad = datos?.consultaEntidad(Entidad(rawValue: row)!)
        }
        intEstado=row
        getData()
        mostrarDatos()
    }
    
    override func mostrarDatos() {
        if entidad != nil {
            txtCincuentaPorciento.text = Utils.toString(entidad!.viv_proc_m50)
            txtNoventaPorciento.text = Utils.toString(entidad!.viv_proc_50_99)
            txtRecientes.text = Utils.toString(entidad!.viv_term_rec)
            txtAntiguas.text = Utils.toString(entidad!.viv_term_ant)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
       txtTitle.text="Avance de Obra \(Utils.formatoMes(fechas.fecha_vv))"
    }
    
    override func getKey() -> String {
        return AvanceObraRepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return FechasRepository.selectFechas()?.fecha_vv
    }
}
