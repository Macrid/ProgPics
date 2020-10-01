//
//  YourProgressionsViewController.swift
//  ProgPics
//
//  Created by Admin on 2020-09-17.
//

import Foundation
import Firebase

import UIKit

class YourProgressionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var numberOfCategories = 2
    var clickedRow:Int? = nil
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
            addCell()
            performSegue(withIdentifier: "segue to new", sender: nil)
        }
        else
        {
            clickedRow = indexPath.row
            performSegue(withIdentifier: "segue to category", sender: nil)
        }

    }
    
    func addCell()
    {
        numberOfCategories += 1
        progressionsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser == nil)
        {
            performSegue(withIdentifier: "segue to auth", sender: nil)
        }
    }
    
    @IBAction func doLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "segue to auth", sender: nil)
        } catch {

        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue to category")
        {
            let tabBarController = segue.destination as! UITabBarController
            let galleryViewController = tabBarController.viewControllers?[0] as! GalleryViewController
            galleryViewController.testString = String(clickedRow!)
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
