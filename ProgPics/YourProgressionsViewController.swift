//
//  YourProgressionsViewController.swift
//  ProgPics
//
//  Created by Admin on 2020-09-17.
//

import Foundation

import UIKit

class YourProgressionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var numberOfCategories = 8
    @IBOutlet weak var progressionsTableView: UITableView!
    //var tableViewCells = [UserCategoryTableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressionsTableView.dataSource = self
        progressionsTableView.delegate = self
    }


    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCategories + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == numberOfCategories)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! LastTableViewCell
            //tableViewCells.append(cell)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! UserCategoryTableViewCell
        //tableViewCells.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == numberOfCategories)
        {
            performSegue(withIdentifier: "segue to new", sender: nil)
        }
        else
        {
            performSegue(withIdentifier: "segue to category", sender: nil)
        }

    }
    
    //@IBAction func cellButtonPress(_ sender: AnyObject) {
        //let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.progressionsTableView)
        //let indexPath = self.progressionsTableView.indexPathForRow(at: buttonPosition)

        
        //performSegue(withIdentifier: "segue to category", sender: nil)
    //}
    
    //@IBAction func newCategoryButton(_ sender: Any) {
        
        
    //}
}
