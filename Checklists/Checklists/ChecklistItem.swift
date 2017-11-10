//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Linix on 2017/2/20.
//  Copyright © 2017年 Linix. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
}
