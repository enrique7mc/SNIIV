//
//  ParseAvanceObra.swift
//  SNIIV
//
//  Created by admin on 15/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation

class ParseAvanceObra<T>: ParseBase<[AvanceObra]> {
    
}

struct AvanceObra {
    var viv_proc_m50: Int = 0
    var viv_proc_50_99: Int = 0
    var viv_term_rec: Int = 0
    var viv_term_ant: Int = 0
    var total: Int = 0
}