//
//  CRUDReporteGeneral.swift
//  SNIIV
//
//  Created by SAP1 on 09/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit
import CoreData

class CRUDReporteGeneral: NSObject {
    
    var entities: Array<AnyObject>=[]
    
    func saveReporteGeneral(reporteGeneral: ReporteGeneral)
    {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let ctx:NSManagedObjectContext = appDel.managedObjectContext!
        
        let en=NSEntityDescription.entityForName("ReporteGeneral", inManagedObjectContext: ctx)
        
        var newItem=ReporteGeneral(entity: en!, insertIntoManagedObjectContext: ctx)
        
        newItem.cve_ent=reporteGeneral.cve_ent
        newItem.acc_finan=reporteGeneral.acc_finan
        newItem.mto_finan=reporteGeneral.mto_finan
        newItem.acc_subs=reporteGeneral.acc_subs
        newItem.acc_finan=reporteGeneral.acc_finan
        newItem.vv=reporteGeneral.vv
        newItem.vr=reporteGeneral.vr
        
        ctx.save(nil)
        
    }
    
    func deleteReporteGeneral(){
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let ctx:NSManagedObjectContext = appDel.managedObjectContext!

        let request=NSFetchRequest(entityName: "ReporteGeneral")
        
        entities=ctx.executeFetchRequest(request, error:nil)!
        
        var aux:NSManagedObject
        
        for bas:AnyObject in entities
        {
            ctx.deleteObject(bas as! NSManagedObject)
        }
        
    }
    
    func selectAllReporteGeneral()->Array<AnyObject>{
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let ctx:NSManagedObjectContext = appDel.managedObjectContext!
        
        let request=NSFetchRequest(entityName: "ReporteGeneral")
        
        entities=ctx.executeFetchRequest(request, error:nil)!
        
        return entities
    }
    
   
}
