//
//  CRUDAvanceObra.swift
//  SNIIV
//
//  Created by admin on 20/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import CoreData

class CRUDAvanceObra {
    static func save(avance: AvanceObra) {
        let en = NSEntityDescription.entityForName("AvanceObra", inManagedObjectContext: Context.ctx)
        
        let avanceEntity = NSManagedObject(entity: en!, insertIntoManagedObjectContext: Context.ctx)
        avanceEntity.setValue(avance.cve_ent, forKey: "cve_ent")
        avanceEntity.setValue(NSNumber(longLong: avance.viv_proc_m50), forKey: "viv_proc_m50")
        avanceEntity.setValue(NSNumber(longLong: avance.viv_proc_50_99), forKey: "viv_proc_50_99")
        avanceEntity.setValue(NSNumber(longLong: avance.viv_term_rec), forKey: "viv_term_rec")
        avanceEntity.setValue(NSNumber(longLong: avance.viv_term_ant), forKey: "viv_term_ant")
        avanceEntity.setValue(NSNumber(longLong: avance.total), forKey: "total")
        
        var error: NSError?
        if !Context.ctx.save(nil) {
            println("Could not save AvanceObra \(error), \(error?.userInfo)")
        }
    }
    
    static func delete(){
        let request=NSFetchRequest(entityName: "AvanceObra")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        for bas: AnyObject in entities {
            Context.ctx.deleteObject(bas as! NSManagedObject)
        }
        
        var error: NSError?
        if !Context.ctx.save(nil) {
            println("Could not delete AvanceObra \(error), \(error?.userInfo)")
        }
    }
    
    static func selectAll() -> Array<AnyObject> {
        let request = NSFetchRequest(entityName: "AvanceObra")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        return entities
    }
    
    static func loadFromStorage() -> [AvanceObra] {
        var all = CRUDAvanceObra.selectAll()
        var result: [AvanceObra] = []
        
        for r in all {
            let cve_ent = Utils.getNSNumber(r.valueForKey("cve_ent")).integerValue
            let viv_proc_m50 = Utils.getNSNumber(r.valueForKey("viv_proc_m50")).longLongValue
            let viv_proc_50_99 = Utils.getNSNumber(r.valueForKey("viv_proc_50_99")).longLongValue
            let viv_term_rec = Utils.getNSNumber(r.valueForKey("viv_term_rec")).longLongValue
            let viv_term_ant = Utils.getNSNumber(r.valueForKey("viv_term_ant")).longLongValue
            let total = Utils.getNSNumber(r.valueForKey("total")).longLongValue
            result.append( AvanceObra(cve_ent: cve_ent, viv_proc_m50: viv_proc_m50,
                viv_proc_50_99: viv_proc_50_99,
                viv_term_rec: viv_term_rec,
                viv_term_ant: viv_term_ant,
                total: total))
        }
        
        
        return result
    }
}