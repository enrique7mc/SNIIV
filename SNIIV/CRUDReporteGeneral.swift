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
    
    static let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static let ctx: NSManagedObjectContext = CRUDReporteGeneral.appDel.managedObjectContext!
    
    static func saveReporteGeneral(reporteGeneral: ReporteGeneralPrueba) {
        let en = NSEntityDescription.entityForName("ReporteGeneral", inManagedObjectContext: CRUDReporteGeneral.ctx)
        
        var newItem = ReporteGeneral(entity: en!, insertIntoManagedObjectContext: CRUDReporteGeneral.ctx)
    
        newItem.cve_ent = reporteGeneral.cveeNT
        newItem.acc_finan = reporteGeneral.accFinan
        newItem.mto_finan = reporteGeneral.mtoFinan
        newItem.mto_subs = reporteGeneral.mtoSubs
        newItem.acc_subs = reporteGeneral.accSubs
        newItem.vv = reporteGeneral.vv
        newItem.vr = reporteGeneral.vr
        
        CRUDReporteGeneral.ctx.save(nil)
    }
    
    static func deleteReporteGeneral(){
        let request=NSFetchRequest(entityName: "ReporteGeneral")
        var entities: Array<AnyObject> = CRUDReporteGeneral.ctx.executeFetchRequest(request, error:nil)!
        
        for bas: AnyObject in entities {
            CRUDReporteGeneral.ctx.deleteObject(bas as! NSManagedObject)
        }
        
        CRUDReporteGeneral.ctx.save(nil)
    }
    
    static func selectAllReporteGeneral()->Array<AnyObject>{
        let request=NSFetchRequest(entityName: "ReporteGeneral")
        var entities: Array<AnyObject> = CRUDReporteGeneral.ctx.executeFetchRequest(request, error:nil)!
        
        return entities
    }
    
    static func loadFromStorage() -> [ReporteGeneralPrueba] {
        var all = CRUDReporteGeneral.selectAllReporteGeneral()

        var result = all.map() { r in
            ReporteGeneralPrueba(cveeNT: Utils.getText(r.valueForKey("cve_ent")),
                accFinan: Utils.getText(r.valueForKey("acc_finan")),
                mtoFinan: Utils.getText(r.valueForKey("mto_finan")),
                accSubs: Utils.getText(r.valueForKey("acc_subs")),
                mtoSubs: Utils.getText(r.valueForKey("mto_subs")),
                vv: Utils.getText(r.valueForKey("vv")),
                vr: Utils.getText(r.valueForKey("vr")))
        }

        return result
        
    }
}
