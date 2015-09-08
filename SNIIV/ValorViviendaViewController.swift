//
//  ValorViviendaViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class ValorViviendaViewController: BaseUIViewController {
 
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtEconomica: UILabel!
    @IBOutlet weak var txtPopular: UILabel!
    @IBOutlet weak var txtTradicional: UILabel!
    @IBOutlet weak var txtMediaResidencial: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    @IBOutlet weak var btnChart: UIButton!
    var pParties:[String] = []
    var pValues:[Int64] = []
    var entidad: ValorVivienda?
    var datos: DatosValorVivienda?
    var pTitulo:String = "Valor Vivienda"
    var pEstado: String = ""
    var intEstado:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.userInteractionEnabled = false

        activarIndicador()
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {            
            var parseValor = ParseValorVivienda<[ValorVivienda]>()
            parseValor.getDatos(handler)
            return
        }
        
        loadFromStorage()
    }
    
    func getData(){
        pParties = ["Popular", "Tradicional","Media-Residencial"]
        pValues = [entidad!.popular,entidad!.tradicional, entidad!.media_residencial]
        pEstado = Utils.entidades[intEstado]
    }
    
    @IBAction func showChart(sender: AnyObject) {
         self.performSegueWithIdentifier("chartModal", sender:self)
    }
    
    func handler (responseObject: [ValorVivienda], error: NSError?) -> Void {
        if error != nil {
            println("ValorVivienda error obteniendo datos")
            return
        }
        
        ValorViviendaRepository.deleteAll()
        ValorViviendaRepository.saveAll(responseObject)
        
        datos = DatosValorVivienda(datos: responseObject)
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
        if segue.identifier == "chartModal" {
            let gvc = segue.destinationViewController as! ChartViewController
            gvc.parties = pParties
            gvc.values = pValues
            gvc.titulo = pTitulo
            gvc.estado = pEstado
        }
    }
    override func loadFromStorage() {
        println("Valorivienda loadFromStorage")
        let datosStorage = ValorViviendaRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosValorVivienda(datos: datosStorage)
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
            txtEconomica.text = Utils.toString(entidad!.economica)
            txtPopular.text = Utils.toString(entidad!.popular)
            txtTradicional.text = Utils.toString(entidad!.tradicional)
            txtMediaResidencial.text = Utils.toString(entidad!.media_residencial)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
     //   txtTitleValorVivienda.text = "Valor de la Vivienda \(Utils.formatoMes(fechas.fecha_vv))"
    }
    
    override func getKey() -> String {
        return ValorViviendaRepository.TABLA
    }
    
    override func getFechaActualizacion() -> String? {
        return FechasRepository.selectFechas()?.fecha_vv
    }
}
