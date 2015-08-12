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
    @IBOutlet weak var txtTitleValorVivienda: UITextField!
    @IBOutlet weak var txtEconomica: UILabel!
    @IBOutlet weak var txtPopular: UILabel!
    @IBOutlet weak var txtTradicional: UILabel!
    @IBOutlet weak var txtMediaResidencial: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    
    var entidad: ValorVivienda?
    var datos: DatosValorVivienda?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitleValorVivienda.enabled = false
        picker.userInteractionEnabled = false

        activarIndicador()
        
        if !isDataLoaded() && Reachability.isConnectedToNetwork() {
            var parseFechas = ParseFechas<Fechas>()
            parseFechas.getDatos(handlerFechas)
            var parseValor = ParseValorVivienda<[ValorVivienda]>()
            parseValor.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
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
        
        TimeLastUpdatedRepository.saveLastTimeUpdated(getKey())
        
        dispatch_async(dispatch_get_main_queue()){
            self.habilitarPantalla()
            self.picker.userInteractionEnabled = true
        }
    }
    
    func loadFromStorage() {
        println("Valorivienda loadFromStorage")
        let datosStorage = ValorViviendaRepository.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosValorVivienda(datos: datosStorage)
            entidad = datos?.consultaNacional()
            picker.userInteractionEnabled = true
        } else {
            println("no hay datos en local storage")
        }
        
        let fechasStorage = FechasRepository.selectFechas()
        if fechasStorage != nil {
            fechas = fechasStorage!
        } else {
            println("no hay fechas en local storage")
        }
        
        habilitarPantalla()
    }
    
    override func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemSelected = Utils.entidades[row]
        if row == 0 {
            entidad = datos?.consultaNacional()
        } else {
            entidad = datos?.consultaEntidad(Entidad(rawValue: row)!)
        }
        
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
        
        txtTitleValorVivienda.text = "Valor de la Vivienda \(fechas.fecha_vv)"
    }
    
    override func getKey() -> String {
        return ValorViviendaRepository.TABLA
    }
}
