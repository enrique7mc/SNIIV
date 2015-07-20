//
//  Context.swift
//  SNIIV
//
//  Created by admin on 20/07/15.
//  Copyright (c) 2015 enrique7mc. All rights reserved.
//

import UIKit
import CoreData

class Context {
    static let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static let ctx: NSManagedObjectContext = Context.appDel.managedObjectContext!
}