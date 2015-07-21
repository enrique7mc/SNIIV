//
//  CRUDValorVivienda.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import CoreData

class CRUDValorVivienda {
    static func save(valor: ValorVivienda) {
        let en = NSEntityDescription.entityForName("ValorVivienda", inManagedObjectContext: Context.ctx)
        
        let valorEntity = NSManagedObject(entity: en!, insertIntoManagedObjectContext: Context.ctx)
        valorEntity.setValue(valor.cve_ent, forKey: "cve_ent")
        valorEntity.setValue(NSNumber(longLong: valor.economica), forKey: "economica")
        valorEntity.setValue(NSNumber(longLong: valor.popular), forKey: "popular")
        valorEntity.setValue(NSNumber(longLong: valor.tradicional), forKey: "tradicional")
        valorEntity.setValue(NSNumber(longLong: valor.media_residencial), forKey: "media_residencial")
        valorEntity.setValue(NSNumber(longLong: valor.total), forKey: "total")
        
        var error: NSError?
        if !Context.ctx.save(&error) {
            println("Could not save ValorVivienda \(error), \(error?.userInfo)")
        }
    }
    
    static func delete(){
        let request=NSFetchRequest(entityName: "ValorVivienda")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        for bas: AnyObject in entities {
            Context.ctx.deleteObject(bas as! NSManagedObject)
        }
        
        var error: NSError?
        if !Context.ctx.save(&error) {
            println("Could not delete ValorVivienda \(error), \(error?.userInfo)")
        }
    }
    
    static func selectAll() -> Array<AnyObject> {
        let request = NSFetchRequest(entityName: "ValorVivienda")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        return entities
    }
    
    static func loadFromStorage() -> [ValorVivienda] {
        var all = CRUDValorVivienda.selectAll()
        var result: [ValorVivienda] = []
        
        for r in all {
            let cve_ent = Utils.getNSNumber(r.valueForKey("cve_ent")).integerValue
            let economica = Utils.getNSNumber(r.valueForKey("economica")).longLongValue
            let popular = Utils.getNSNumber(r.valueForKey("popular")).longLongValue
            let tradicional = Utils.getNSNumber(r.valueForKey("tradicional")).longLongValue
            let media_residencial = Utils.getNSNumber(r.valueForKey("media_residencial")).longLongValue
            let total = Utils.getNSNumber(r.valueForKey("total")).longLongValue
            result.append( ValorVivienda(cve_ent: cve_ent,
                economica: economica,
                popular: popular,
                tradicional: tradicional,
                media_residencial: media_residencial,
                total: total))
        }
        
        
        return result
    }
}