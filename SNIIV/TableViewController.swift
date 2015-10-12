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
        var view = self.navigationController?.topViewController.view as! UITableView
        view.separatorStyle = .None
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Recargar datos")
        self.refresh.addTarget(self, action: "reload:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
    }
    
   
    
    override func viewDidAppear(animated: Bool) {
        cargarDatosFechas()
    }
    
    func cargarDatosFechas() {
        if Reachability.isConnectedToNetwork() {
            print("carga fechas", terminator: "")
            let parseFechas = ParseFechasWeb<Fechas?>()
            parseFechas.getDatos(handlerFechas)
        }
        
        if refresh.refreshing {
            self.refresh.endRefreshing()
        }
    }
    
    func handlerFechas (responseObject: Fechas, error: NSError?) {
        if error != nil {
            print("Error obteniendo fechas", terminator: "")
            return
        }
        
        fechas = responseObject
        //fechas = Fechas(fecha_finan: "26/08/2015", fecha_subs: "01/09/2015", fecha_vv: "25/08/2015")
        actualizaFechas()
        
        if refresh.refreshing {
            self.refresh.endRefreshing()
        }
    }
    
    func actualizaFechas() {
        FechasRepository.deleteAll()
        FechasRepository.save(fechas)
    }
    
    func reload(sender:AnyObject) {
        cargarDatosFechas()
    }
}
