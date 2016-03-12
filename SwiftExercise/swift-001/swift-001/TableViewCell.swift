//
//  TableViewCell.swift
//  swift-001
//
//  Created by lyle on 15/8/7.
//  Copyright (c) 2015年 lyleLH. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var mySegment: UISegmentedControl!
   
    func setLayout() {
        
       self.contentView.backgroundColor = UIColor.redColor()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

