//
//  GalleryViewController.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-09-28.
//

import UIKit
import Firebase

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var progID:String?
    var numberOfPictures = 0
    var progRef:DatabaseReference?
    var storage = Storage.storage()
    var storageRef:StorageReference?
    var cellList = [ThumbnailCollectionViewCell]()
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").child(progID!)
        storageRef = storage.reference()
        // Do any additional setup after loading the view.
    }
    
    //func numberOfSections(in collectionView: UICollectionView) -> Int {
        
    //}
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPictures
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnail cell" , for: indexPath) as! ThumbnailCollectionViewCell
        storageRef?.child(Auth.auth().currentUser!.uid).child(cellList[indexPath.row].ID!).getData(maxSize: 10 * 1024 * 1024, completion: {data, error in
            if let error = error {
                print("Error bildhämt")
            }
            else {
                cell.imageView.image = UIImage(data: data!)
            }
            })
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(collectionView.frame.width/3) - 5, height: Int(collectionView.frame.width/3) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        //LADDA RÄTT BILD o GÖR IMAGEVY SOM TÄCKER SKÄRMEN SYNLIG

    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCells()
    }
    
    func loadCells()
    {
        progRef?.child("Images").observe(.value, with: { snapshot in
            let count = snapshot.childrenCount
            self.numberOfPictures = Int(count)

            self.cellList.removeAll()
            
            for p in snapshot.children
            {
                let imagesSnapshot = p as! DataSnapshot
                let newCell = ThumbnailCollectionViewCell()
                newCell.ID = imagesSnapshot.key
                self.cellList.append(newCell)
            }
            self.imageCollectionView.reloadData()

        }) { (error) in
            print(error.localizedDescription)
            
        }
    }
    
    @IBAction func addNewImage(_ sender: Any) {
    }
    /*func imageTapped(_ sender: nil) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    */
    /*@objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
   */
    
}
