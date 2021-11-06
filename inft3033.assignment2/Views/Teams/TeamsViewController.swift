//
//  TeamsViewController.swift
//  inft3033.assignment2
//
//  Created by Mitchell, Oliver - mitoj001 on 6/11/21.
//  Copyright © 2021 Oliver Mitchell. All rights reserved.
//

import UIKit

class TeamsViewController: UITableViewController {
    
    /**
     Data source for the table
     */
    var dataSource: TeamsTableDataSource?
    
    /**
     Action to reload the table view
     */
    @IBAction func reloadTable() {
        tableView.reloadData()
    }
    
    /**
     Method run when the view loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = TeamsTableDataSource()
        tableView.dataSource = dataSource
    }
}
