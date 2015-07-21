//
//  CRUDTipoVivienda.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
//
//  CRUDPCU.swift
//  SNIIV
//
//  Created by admin on 21/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import CoreData

class CRUDTipoVivienda {
    static func save(tipo: TipoVivienda) {
        let en = NSEntityDescription.entityForName("TipoVivienda", inManagedObjectContext: Context.ctx)
        
        let tipoEntity = NSManagedObject(entity: en!, insertIntoManagedObjectContext: Context.ctx)
        tipoEntity.setValue(tipo.cve_ent, forKey: "cve_ent")
        tipoEntity.setValue(NSNumber(longLong: tipo.horizontal), forKey: "horizontal")
        tipoEntity.setValue(NSNumber(longLong: tipo.vertical), forKey: "vertical")
        tipoEntity.setValue(NSNumber(longLong: tipo.total), forKey: "total")
        
        var error: NSError?
        if !Context.ctx.save(&error) {
            println("Could not save TipoVivienda \(error), \(error?.userInfo)")
        }
    }
    
    static func delete(){
        let request=NSFetchRequest(entityName: "TipoVivienda")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        for bas: AnyObject in entities {
            Context.ctx.deleteObject(bas as! NSManagedObject)
        }
        
        var error: NSError?
        if !Context.ctx.save(&error) {
            println("Could not delete TipoVivienda \(error), \(error?.userInfo)")
        }
    }
    
    static func selectAll() -> Array<AnyObject> {
        let request = NSFetchRequest(entityName: "TipoVivienda")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        return entities
    }
    
    static func loadFromStorage() -> [TipoVivienda] {
        var all = CRUDTipoVivienda.selectAll()
        var result: [TipoVivienda] = []
        
        for r in all {
            let cve_ent = Utils.getNSNumber(r.valueForKey("cve_ent")).integerValue
            let horizontal = Utils.getNSNumber(r.valueForKey("horizontal")).longLongValue
            let vertical = Utils.getNSNumber(r.valueForKey("vertical")).longLongValue
            let total = Utils.getNSNumber(r.valueForKey("total")).longLongValue
            result.append( TipoVivienda(cve_ent: cve_ent,
                horizontal: horizontal,
                vertical: vertical,
                total: total))
        }
        
        
        return result
    }
}