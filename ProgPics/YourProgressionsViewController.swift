//
//  YourProgressionsViewController.swift
//  ProgPics
//
//  Created by Admin on 2020-09-17.
//

import Foundation

import UIKit

class YourProgressionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var progressionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressionsTableView.dataSource = self
        progressionsTableView.delegate = self
    }


    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        
        return cell!
    }
}
