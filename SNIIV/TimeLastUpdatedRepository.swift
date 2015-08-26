//
//  TimeLastUpdatedRepository.swift
//  SNIIV
//
//  Created by admin on 12/08/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import Foundation
import SQLite

class TimeLastUpdatedRepository {
    static let db: Database = DBConfig.getInstance().db
    static let key = Expression<String>("key")
    static let time = Expression<String>("time")
    static let dateFormatter = NSDateFormatter()
    
    private static let TABLA = "TimeLastUpdated"
    
    static func saveLastTimeUpdated(keyString: String) {
        let tabla = db[TABLA]
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        tabla.insert(or: .Replace, key <- keyString,
            time <- dateFormatter.stringFromDate(NSDate()))
    }
    
    static func getLastTimeUpdated(keyString: String) -> String {
        let tabla = db[TABLA]
        if let date = tabla.select(time).filter(key == keyString).first {
            return date[time]
        } else {
            return ""
        }
    }
}
