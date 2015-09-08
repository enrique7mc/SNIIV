//
//  TipoViviendaViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class TipoViviendaViewController: BaseUIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtHorizontal: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    @IBOutlet weak var txtVetical: UILabel!
    @IBOutlet weak var btnChart: UIButton!
    var pParties: [String] = []
    var pValues: [Int64] = []
    var entidad: TipoVivienda?
    var datos: DatosTipoVivienda?
    var pTitulo: String? = "Tipo de Vivienda"
    var pEstado:String? = ""
    var intEstado:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.userInteractionEnabled = false
        activarIndicador()
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {            
            var parseTipo = ParseTipoVivienda<[TipoVivienda]>()
            parseTipo.getDatos(handler)
            return
        }
        
        loadFromStorage()
    }
    
    func getData(){
        pParties = ["Horizontal", "Vertical"]
        pValues = [entidad!.horizontal,entidad!.vertical]
        pEstado = Utils.entidades[intEstado]
    }
    
    @IBAction func showChart(sender: AnyObject) {
        self.performSegueWithIdentifier("chartModal", sender: self)
    }
    
    func handler (responseObject: [TipoVivienda], error: NSError?) -> Void {
        if error != nil {
            println("TipoVivienda error obteniendo datos")
            return
        }
        
        TipoViviendaRepository.deleteAll()
        TipoViviendaRepository.saveAll(responseObject)
        
        datos = DatosTipoVivienda(datos: responseObject)
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
        if(segue.identifier == "chartModal"){
            let gvc=segue.destinationViewController as! ChartViewController
            gvc.parties = pParties
            gvc.values = pValues
            gvc.titulo = pTitulo
            gvc.estado = pEstado
        }
    }
    
    override func loadFromStorage() {
        println("TipoVivienda loadFromStorage")
        
        let datosStorage = TipoViviendaRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosTipoVivienda(datos: datosStorage)
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
            txtHorizontal.text = Utils.toString(entidad!.horizontal)
            txtVetical.text = Utils.toString(entidad!.vertical)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
        txtTitle.text = "Tipo de la Vivienda \(Utils.formatoMes(fechas.fecha_vv))"
    }
    
    override func getKey() -> String {
        return TipoViviendaRepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return FechasRepository.selectFechas()?.fecha_vv
    }
}
