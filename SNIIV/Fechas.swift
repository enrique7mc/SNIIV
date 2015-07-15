//
//  Fechas.swift
//  SNIIV
//
//  Created by admin on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class Fechas {
    var fecha_finan: String
    var fecha_subs: String
    var fecha_vv: String
    
    init() {
        fecha_finan = ""
        fecha_subs = ""
        fecha_vv = ""
    }
    
    init(fecha_finan: String, fecha_subs: String, fecha_vv: String) {
        self.fecha_finan = fecha_finan
        self.fecha_subs = fecha_subs
        self.fecha_vv = fecha_vv
    }
}