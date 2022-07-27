//
//  UIViewController+Context.swift
//  MovieLib
//
//  Created by Lucas Oliveira de Borba on 26/07/22.
//

import UIKit
import CoreData

extension UIViewController{
    var context: NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
