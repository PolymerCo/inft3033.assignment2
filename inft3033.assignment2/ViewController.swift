//
//  ViewController.swift
//  inft3033.assignment2
//
//  Created by Oliver Mitchell on 27/10/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    static var modelContainer: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard ViewController.modelContainer != nil else {
            fatalError("Base ViewController requires a persistent container.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

