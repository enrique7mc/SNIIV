//
//  TableViewController.swift
//  SNIIV
//
//  Created by admin on 25/08/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var fechas: Fechas = Fechas()
    static var isDataLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("menu")
        
        if Reachability.isConnectedToNetwork() {
            var parseFechas = ParseFechasWeb<Fechas?>()
            parseFechas.getDatos(handlerFechas)
            
            return
        }
    }
    
    func handlerFechas (responseObject: Fechas, error: NSError?) {
        if error != nil {
            println("Error obteniendo fechas")
            return
        }
        
        fechas = responseObject
        
        if let fechasStorage = FechasRepository.selectFechas() {
            if fechas != fechasStorage {
                TableViewController.isDataLoaded = false
            } else {
                TableViewController.isDataLoaded = true
            }
        } else {
            FechasRepository.deleteAll()
            FechasRepository.save(fechas)
        }
    }
}
