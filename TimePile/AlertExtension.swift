//
//  AlertExtension.swift
//  TimePile1
//
//  Created by Lavanya S Patil on 9/7/17.
//  Copyright © 2017 Steerminds. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
