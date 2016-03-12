//
//  MyViewController.swift
//  swift-001
//
//  Created by lyle on 15/8/7.
//  Copyright (c) 2015年 lyleLH. All rights reserved.
//

import UIKit

class MyViewController: UIViewController ,UITableViewDataSource ,UITableViewDelegate{
   var ary:Array<String>  = ["哈哈","呵呵","嘿嘿"]
    override func viewDidLoad() {
        
     
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orangeColor()
        
        let tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
       
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self;
        tableView.backgroundColor = UIColor.cyanColor()

        self.view.addSubview(tableView)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ary.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = TableViewCell(style:.Default, reuseIdentifier:"myCell")
        cell.setLayout()
        cell.textLabel!.text = self.creatString( "Wondeful"+"\t"+"swift cell \(indexPath.row)"+"ary\(ary[indexPath.row])")
        cell.accessoryView = UISwitch(frame: CGRectMake(0, 0, 80, 30))
        cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc:UIViewController = UIViewController()
        vc.title = "title is \(indexPath.row)"
        vc.view.backgroundColor = UIColor.orangeColor()
//        vc.view.backgroundColor = UIColor.clearColor()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func creatString(aString:String) ->String {
        
        return aString + "  " + "加长型"
    }
    
    
    
    
}
