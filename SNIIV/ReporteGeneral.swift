//
//  ReportePrincipal.swift
//
//
//  Created by SAP1 on 09/07/15.
//
//

import Foundation
import CoreData

@objc(ReporteGeneral)
class ReporteGeneral: NSManagedObject {
    
    @NSManaged var acc_finan: String
    @NSManaged var acc_subs: String
    @NSManaged var cve_ent: String
    @NSManaged var mto_finan: String
    @NSManaged var mto_subs: String
    @NSManaged var vr: String
    @NSManaged var vv: String
    
}
