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
    
    var numberOfCategories:Int?
    var clickedRow:Int?
    var ref:DatabaseReference?
    var cellList = [UserCategoryTableViewCell]()
    
    
    @IBOutlet weak var progressionsTableView: UITableView!
    //var tableViewCells = [UserCategoryTableViewCell]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ref = Database.database().reference()
        loadCells()
        
        progressionsTableView.dataSource = self
        progressionsTableView.delegate = self
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (cellList.count != 0)
        {
            return cellList.count + 1
        }
        else
        {
            return cellList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        print(cellList.count)
        
        if (indexPath.row == cellList.count)
        {
            print(indexPath.row)
            print(cellList.count)
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! LastTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! UserCategoryTableViewCell
        
        cell.titleTextbox.text = cellList[indexPath.row].title
        cell.dateTextbox.text = cellList[indexPath.row].date
        
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == cellList.count)
        {
            performSegue(withIdentifier: "segue to new", sender: nil)
        }
        else
        {
            clickedRow = indexPath.row
            performSegue(withIdentifier: "segue to category", sender: nil)
        }

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableview(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath)
    {
        
    }
    
    func loadCells()
    {
        ref?.child(Auth.auth().currentUser!.uid).child("Progressions").observeSingleEvent(of: .value, with: {(snapshot) in
            self.cellList.removeAll()
            for p in snapshot.children
            {
                let progressionSnapshot = p as! DataSnapshot
                
                let newCell = UserCategoryTableViewCell()
                newCell.title = (progressionSnapshot.childSnapshot(forPath: "Progression Title").value as! String)
                newCell.date = progressionSnapshot.childSnapshot(forPath: "Date Started").value as! String
                
                self.cellList.append(newCell)
            }
            self.progressionsTableView.reloadData()
            
            
        
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Auth.auth().currentUser == nil)
        {
            performSegue(withIdentifier: "segue to auth", sender: nil)
        }
        else
        {
            loadCells()
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
}
