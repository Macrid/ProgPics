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
    var storage = Storage.storage()
    var storageRef:StorageReference?
    var cellList = [UserCategoryTableViewCell]()
    
    @IBOutlet weak var progressionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressionsTableView.dataSource = self
        progressionsTableView.delegate = self
        
        ref = Database.database().reference()
        storageRef = storage.reference()
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
        
        var imageRef = [String]()
        
        if (indexPath.row == cellList.count)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell") as! LastTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! UserCategoryTableViewCell
        
        cell.titleTextbox.text = cellList[indexPath.row].title
        cell.dateTextbox.text = cellList[indexPath.row].date
        
        if(cellList[indexPath.row].thumbnailID != nil)
        {
            cell.imageView!.image = nil
            
            let imageFilename = "\(cellList[indexPath.row].thumbnailID!).jpg"
            
            let tempFile = try! URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFilename)

            if(FileManager.default.fileExists(atPath: tempFile.path))
            {
                let imageData = try? Data(contentsOf: tempFile)

                cell.thumbnailView.image = UIImage(data: imageData!)
            } else {
                storageRef?.child(Auth.auth().currentUser!.uid).child(imageFilename).getData(maxSize: 10 * 1024 * 1024, completion: {data, error in
                    if let error = error {
                        print("Error bildhämt")
                        
                    }
                    else {
                        try? data?.write(to: URL(fileURLWithPath: tempFile.path), options: [.atomicWrite])
                        
                        cell.thumbnailView.image = UIImage(data: data!)
                    }
                })
            }
        }

        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == cellList.count)
        {
            addNewProg()
            //performSegue(withIdentifier: "segue to new", sender: nil)
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
              
                self.deleteProgression(indexPath: indexPath)

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
                
                if(progressionSnapshot.hasChild("Thumbnail"))
                {
                    newCell.thumbnailID = (progressionSnapshot.childSnapshot(forPath: "Thumbnail").value as! String)
                }
                
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
    
    func deleteProgression(indexPath: IndexPath)
    {
        self.ref?.child(Auth.auth().currentUser!.uid).child("Progressions").child(self.cellList[indexPath.row].ID!).child("Images").observeSingleEvent(of: .value, with: {(snapshot) in
            
            for i in snapshot.children
            {
                let imageSnapshot = i as! DataSnapshot
                self.storageRef?.child(Auth.auth().currentUser!.uid).child("\(imageSnapshot.key).jpg").delete(completion: nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
            
        }

        self.ref?.child(Auth.auth().currentUser!.uid).child("Progressions").child(self.cellList[indexPath.row].ID!).removeValue()

        self.loadCells()
    }
    
    func addNewProg()
    {
        let progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").childByAutoId()
        
        let alert = UIAlertController(title: "New Progression", message: "Add a title", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textfield) in})
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {_ in
            
            let prog : [String : Any] = ["Progression Title" : alert.textFields!.first?.text!, "Date Started" : self.getTodaysDate()]
            progRef.setValue(prog)
            
            self.loadCells()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getTodaysDate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date = Date()
        let todaysDate = formatter.string(from: date)
        return todaysDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue to category")
        {
            let tabBarController = segue.destination as! ProgressTabBarController
            tabBarController.progID = clickedCellID
            let galleryViewController = tabBarController.viewControllers?[0] as! GalleryVC
            galleryViewController.progID = clickedCellID
        }
        
    }
}
