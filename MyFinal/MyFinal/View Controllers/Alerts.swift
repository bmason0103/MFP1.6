//
//  Alerts.swift
//  MyFinal
//
//  Created by Brittany Mason on 2/29/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ViewController  {
    
    
    
    func displayAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
         present(alert, animated: true)

        }
    }
}
extension CityViewController  {

    func displayAlert(title:String, message:String?) {

        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
         present(alert, animated: true)

        }
    }
}

extension UIViewController {

var appDelegate: AppDelegate {
    
    return UIApplication.shared.delegate as! AppDelegate
}

func save() {
    do {
        try CoreDataStack.shared().saveContext()
    } catch {
       showInfo(withTitle: "Error", withMessage: "Error while saving Pin location: \(error)")
    }
}
    
    func showInfo(withTitle: String = "Info", withMessage: String, action: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(ac, animated: true)
        }
    }
}

