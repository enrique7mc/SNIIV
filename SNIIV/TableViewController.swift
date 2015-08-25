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
    static var isDateLoaded: Bool = false
    var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("menu")
        
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Recargar datos")
        self.refresh.addTarget(self, action: "reload:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
        
        cargarDatosFechas()
    }
    
    func cargarDatosFechas() {
        if Reachability.isConnectedToNetwork() {
            var parseFechas = ParseFechasWeb<Fechas?>()
            parseFechas.getDatos(handlerFechas)
        }
        
        if refresh.refreshing {
            self.refresh.endRefreshing()
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
                TableViewController.isDateLoaded = false
            } else {
                TableViewController.isDateLoaded = true
            }
        } else {
            println("Saving dates")
            FechasRepository.deleteAll()
            FechasRepository.save(fechas)
            TableViewController.isDateLoaded = true
        }
        
        if refresh.refreshing {
            self.refresh.endRefreshing()
        }
    }
    
    func reload(sender:AnyObject) {
        cargarDatosFechas()
    }
}
