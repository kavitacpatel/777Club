//
//  AlertViewController.swift
//  777Club
//
//  Created by kavita patel on 9/7/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController
{
    static var alertView = AlertViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    func alertMsg(_ title: String, msg: String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
