//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Linix on 2017/2/20.
//  Copyright © 2017年 Linix. All rights reserved.
//

import Foundation
import UIKit

class AddItemViewController: UITableViewController {
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
    }
}
