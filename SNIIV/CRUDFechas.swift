//
//  CRUDFechas.swift
//  SNIIV
//
//  Created by admin on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit
import CoreData

class CRUDFechas {
    static func saveFechas(fechas: Fechas) {
        let en = NSEntityDescription.entityForName("Fechas", inManagedObjectContext: Context.ctx)
        
        let fechasEntity = NSManagedObject(entity: en!, insertIntoManagedObjectContext: Context.ctx)
        fechasEntity.setValue(fechas.fecha_finan, forKey: "fecha_finan")
        fechasEntity.setValue(fechas.fecha_subs, forKey: "fecha_subs")
        fechasEntity.setValue(fechas.fecha_vv, forKey: "fecha_vv")
        
        var error: NSError?
        if !Context.ctx.save(nil) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    static func deleteFechas(){
        let request=NSFetchRequest(entityName: "Fechas")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!

        for bas: AnyObject in entities {
            Context.ctx.deleteObject(bas as! NSManagedObject)
        }
        
        var error: NSError?
        if !Context.ctx.save(nil) {
            println("Could not delete \(error), \(error?.userInfo)")
        }
    }
    
    static func selectFechas() -> Fechas? {
        let request = NSFetchRequest(entityName: "Fechas")
        var entities: Array<AnyObject> = Context.ctx.executeFetchRequest(request, error:nil)!
        
        println("fechas \(entities.count)")
        if let fechas: AnyObject = entities.first {
            return Fechas(fecha_finan: Utils.getText(fechas.valueForKey("fecha_finan")), fecha_subs: Utils.getText(fechas.valueForKey("fecha_subs")), fecha_vv: Utils.getText(fechas.valueForKey("fecha_vv")))
        }
        
        return nil
    }

}