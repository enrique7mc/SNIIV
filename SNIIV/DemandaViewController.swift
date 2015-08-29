//
//  DemandaViewController.swift
//  SNIIV
//
//  Created by SAP1 on 8/28/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit

class DemandaViewController: UITabBarController,UITabBarDelegate {

 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        
       
        if(item.title=="Subsidios")
        {
            let fechasStorage = FechasRepository.selectFechas()
            var fechas: Fechas = Fechas()
            fechas = fechasStorage!
            self.navigationItem.title = "Subsidios \(Utils.formatoDiaMes(fechas.fecha_subs))"

         
        }
        else if(item.title=="Financiamientos")
        {
            
            let fechasStorage = FechasRepository.selectFechas()
            var fechas: Fechas = Fechas()
            fechas = fechasStorage!
            self.navigationItem.title = "Financiamientos \(Utils.formatoDiaMes(fechas.fecha_finan))"
        }
    }

}
