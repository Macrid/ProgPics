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
        return cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       //if (indexPath.row == numberOfCategories)
        //{
            //let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! LastTableViewCell
            //tableViewCells.append(cell)
            //return cell
        //}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! UserCategoryTableViewCell
        
        //let cell = cellList[indexPath.row]
        
        cell.titleTextbox.text = cellList[indexPath.row].title
        cell.dateTextbox.text = cellList[indexPath.row].date
        print(cellList)
        return cell
        
        //tableViewCells.append(cell)
       // return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == numberOfCategories)
        {
            performSegue(withIdentifier: "segue to new", sender: nil)
        }
        else
        {
            clickedRow = indexPath.row
            performSegue(withIdentifier: "segue to category", sender: nil)
        }

    }
    
    func loadCells()
    {
        ref?.child(Auth.auth().currentUser!.uid).child("Progressions").observeSingleEvent(of: .value, with: {(snapshot) in
            self.cellList.removeAll()
            for p in snapshot.children
            {
                let progressionSnapshot = p as! DataSnapshot
                
                let newCell = UserCategoryTableViewCell()
                newCell.title = progressionSnapshot.childSnapshot(forPath: "Progression Title").value as! String
                newCell.date = progressionSnapshot.childSnapshot(forPath: "Date Started").value as! String
                
                self.cellList.append(newCell)
            }
            self.progressionsTableView.reloadData()
        
        
        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    func addCell(title: String, date: String)
    {
        
        progressionsTableView.reloadData()
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
    //@IBAction func cellButtonPress(_ sender: AnyObject) {
        //let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.progressionsTableView)
        //let indexPath = self.progressionsTableView.indexPathForRow(at: buttonPosition)

        
        //performSegue(withIdentifier: "segue to category", sender: nil)
    //}
    
    //@IBAction func newCategoryButton(_ sender: Any) {
        
        
    //}
}
