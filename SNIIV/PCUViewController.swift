//
//  PCUViewController.swift
//  SNIIV
//
//  Created by SAP1 on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class PCUViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

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
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitlePCU.enabled=false
        indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        picker.userInteractionEnabled = false
        indicator.startAnimating()
        
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
        indicator.stopAnimating()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
            txtU1.text = Utils.toString(entidad!.u1)
            TXTu2.text = Utils.toString(entidad!.u2)
            txtU3.text = Utils.toString(entidad!.u3)
            txtFC.text = Utils.toString(entidad!.fc)
            txtND.text = Utils.toString(entidad!.nd)
            txtTotal.text = Utils.toString(entidad!.total)
        }
        
        txtTitlePCU.text = "Perímetros de Contención Urbana \(fechas.fecha_subs)"
    }
}
