//
//  IndicadorViewController.swift
//  SNIIV
//
//  Created by admin on 22/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import UIKit
import Charts

class BaseUIViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, ChartViewDelegate {
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
    
    func isDataLoaded() -> Bool {
        let date = TimeLastUpdatedRepository.getLastTimeUpdated(getKey())
        let lastUpdated = getFechaActualizacion() ?? "00/00/0000"
        println(date + " " + lastUpdated)
        return date == lastUpdated
    }
    
    func getKey() -> String {
        print("getKey not implemented by subclass")
        return ""
    }
    
    func getFechaActualizacion() -> String? {
        print("getFechaActualizacion not implemented by subclass")
        return nil
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
    
    func loadFechasStorage() {
        let fechasStorage = FechasRepository.selectFechas()
        if fechasStorage != nil {
            fechas = fechasStorage!
        } else {
            println("no hay fechas en local storage")
        }
    }
}