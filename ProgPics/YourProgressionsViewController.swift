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
    var tableViewCells = [UserCategoryTableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressionsTableView.dataSource = self
        progressionsTableView.delegate = self
    }


    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! UserCategoryTableViewCell
        tableViewCells.append(cell)
        return cell
    }
    
    @IBAction func cellButtonPress(_ sender: AnyObject) {
        //let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.progressionsTableView)
        //let indexPath = self.progressionsTableView.indexPathForRow(at: buttonPosition)

        
        //performSegue(withIdentifier: "segue", sender: nil)
    }
}
