//
//  IndicadorViewController.swift
//  SNIIV
//
//  Created by admin on 22/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import UIKit

class BaseUIViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var fechas: Fechas = Fechas()
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    func activarIndicador() {
        indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        indicator.startAnimating()
    }
    
    func desactivarIndicador() {
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
        println("pickerView not implemented")
    }
    
    func handlerFechas (responseObject: Fechas, error: NSError?) {
        if error != nil {
            println("Error obteniendo fechas")
            return
        }
        
        fechas = responseObject
        
        if let fechasStorage = FechasRepository.selectFechas() {
            if fechas != fechasStorage {
                loadFromWeb()
            } else {
                loadFromStorage()
            }
        }
    }
    
    func loadFromWeb() {
        println("loadFromWeb not implemented")
    }
    
    func loadFromStorage() {
        println("loadFromWeb not implemented")
    }
    
    func mostrarDatos() {
        println("mostrarDatos not implemented")
    }
    
    func habilitarPantalla() {
        self.mostrarDatos()
        self.desactivarIndicador()
    }
    
    // deprecated
    func isDataLoaded() -> Bool {
        return false
    }
    
    // deprecated
    func getKey() -> String {
        print("getKey not implemented by subclass")
        return ""
    }
    
    func muestraMensajeError() {
        var alert = UIAlertController(title: "Ha ocurrido un error",
            message: "No hay conexión a internet",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Aceptar",
            style: .Default, handler: nil)
        
        alert.addAction(saveAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
}