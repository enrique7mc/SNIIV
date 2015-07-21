//
//  CRUDPCU.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import CoreData

class CRUDPCU {
    static func save(pcu: PCU) {
        let en = NSEntityDescription.entityForName("PCU", inManagedObjectContext: Context.ctx)
        
        let pcuEntity = NSManagedObject(entity: en!, insertIntoManagedObjectContext: Context.ctx)
        pcuEntity.setValue(pcu.cve_ent, forKey: "cve_ent")
        pcuEntity.setValue(NSNumber(longLong: pcu.u1), forKey: "u1")
        pcuEntity.setValue(NSNumber(longLong: pcu.u2), forKey: "u2")
        pcuEntity.setValue(NSNumber(longLong: pcu.u3), forKey: "u3")
        pcuEntity.setValue(NSNumber(longLong: pcu.fc), forKey: "fc")
        pcuEntity.setValue(NSNumber(longLong: pcu.nd), forKey: "nd")
        pcuEntity.setValue(NSNumber(longLong: pcu.total), forKey: "total")
        
        var error: NSError?
        if !Context.ctx.save(&error) {
            println("Could not save PCU \(error), \(error?.userInfo)")
        }
    }
    
    static func delete(){
        let request=NSFetchRequest(entityName: "PCU")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        for bas: AnyObject in entities {
            Context.ctx.deleteObject(bas as! NSManagedObject)
        }
        
        var error: NSError?
        if !Context.ctx.save(&error) {
            println("Could not delete PCU \(error), \(error?.userInfo)")
        }
    }
    
    static func selectAll() -> Array<AnyObject> {
        let request = NSFetchRequest(entityName: "PCU")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        return entities
    }
    
    static func loadFromStorage() -> [PCU] {
        var all = CRUDPCU.selectAll()
        var result: [PCU] = []
        
        for r in all {
            let cve_ent = Utils.getNSNumber(r.valueForKey("cve_ent")).integerValue
            let u1 = Utils.getNSNumber(r.valueForKey("u1")).longLongValue
            let u2 = Utils.getNSNumber(r.valueForKey("u2")).longLongValue
            let u3 = Utils.getNSNumber(r.valueForKey("u3")).longLongValue
            let fc = Utils.getNSNumber(r.valueForKey("fc")).longLongValue
            let nd = Utils.getNSNumber(r.valueForKey("nd")).longLongValue
            let total = Utils.getNSNumber(r.valueForKey("total")).longLongValue
            result.append( PCU(cve_ent: cve_ent, u1: u1, u2: u2, u3: u3, fc: fc,
                nd: nd, total: total))
        }
        
        
        return result
    }
}