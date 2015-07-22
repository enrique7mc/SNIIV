//
//  PCUViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class PCUViewController: BaseUIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var txtTitlePCU: UITextField!
    @IBOutlet weak var txtU1: UILabel!
    @IBOutlet weak var TXTu2: UILabel!
    @IBOutlet weak var txtU3: UILabel!
    @IBOutlet weak var txtFC: UILabel!
    @IBOutlet weak var txtND: UILabel!
    @IBOutlet weak var txtTotal: UILabel!
    
    var entidad: PCU?
    var datos: DatosPCU?
    var fechas: Fechas = Fechas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitlePCU.enabled=false
        picker.userInteractionEnabled = false
        
        activarIndicador()
        
        if Reachability.isConnectedToNetwork() {
            var parseFechas = ParseFechas<Fechas>()
            parseFechas.getDatos(handlerFechas)
            var parsePCU = ParsePCU<[PCU]>()
            parsePCU.getDatos(handler)
            
            return
        }
        
        loadFromStorage()
    }
    
    func handler (responseObject: [PCU], error: NSError?) -> Void {
        if error != nil {
            println("Error obteniendo datos")
            return
        }
        
        datos = DatosPCU(datos: responseObject)
        entidad = datos!.consultaNacional()
        
        CRUDPCU.delete()
        for d in datos!.datos {
            CRUDPCU.save(d)
        }
        
        picker.userInteractionEnabled = true
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
        println("PCU loadFromStorage")
        let datosStorage = CRUDPCU.loadFromStorage()
        if datosStorage.count > 0 {
            datos = DatosPCU(datos: datosStorage)
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
        super.viewDidAppear(animated)
        mostrarDatos()
        desactivarIndicador()
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
    
    func mostrarDatos() {
        if entidad != nil {
            txtU1.text = Utils.toString(entidad!.u1)
            TXTu2.text = Utils.toString(entidad!.u2)
            txtU3.text = Utils.toString(entidad!.u3)
            txtFC.text = Utils.toString(entidad!.fc)
            txtND.text = Utils.toString(entidad!.nd)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
        txtTitlePCU.text = "PCU \(fechas.fecha_subs)"
    }
}
