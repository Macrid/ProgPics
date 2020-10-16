//
//  YourProgressionsViewController.swift
//  ProgPics
//
//  Created by Admin on 2020-09-17.
//

import Foundation
import Firebase
import UIKit

class YourProgressionsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var numberOfCategories:Int?
    var clickedCellID:String?
    var ref:DatabaseReference?
    var cellList = [UserCategoryTableViewCell]()
    
    @IBOutlet weak var progressionsTableView: UITableView!
    //var tableViewCells = [UserCategoryTableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressionsTableView.dataSource = self
        progressionsTableView.delegate = self
        
        ref = Database.database().reference()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (cellList.count != 0)
        {
            return cellList.count + 1
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.row == cellList.count)
        {
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
            clickedCellID = cellList[indexPath.row].ID
            performSegue(withIdentifier: "segue to category", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row == cellList.count)
        {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){_, _, complete in
            let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {_ in
                
                self.ref?.child(Auth.auth().currentUser!.uid).child("Progressions").child(self.cellList[indexPath.row].ID!).removeValue()
                self.loadCells()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit"){_,_, complete in
            let alert = UIAlertController(title: "", message: "Change title", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {(textfield) in
                
                textfield.text = self.cellList[indexPath.row].title
            })
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
                
                self.ref?.child(Auth.auth().currentUser!.uid).child("Progressions").child(self.cellList[indexPath.row].ID!).child("Progression Title").setValue(alert.textFields!.first?.text!)
                self.loadCells()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: false)
            
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return configuration
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
                newCell.date = (progressionSnapshot.childSnapshot(forPath: "Date Started").value as! String)
                newCell.ID = progressionSnapshot.key
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
    
   /* func deleteCellFromDB(title: String)
    {
        ref?.child(Auth.auth().currentUser!.uid).child("Progressions")
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue to category")
        {
            let tabBarController = segue.destination as! UITabBarController
            let galleryViewController = tabBarController.viewControllers?[0] as! GalleryVC
            galleryViewController.progID = clickedCellID
        }
        
    }
}
