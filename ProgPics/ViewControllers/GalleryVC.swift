//
//  GalleryViewController.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-09-28.
//

import UIKit
import Firebase

class GalleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var progID:String?
    var progRef:DatabaseReference?
    var storage = Storage.storage()
    var storageRef:StorageReference?
    var cellList = [ThumbnailCollectionViewCell]()
    var selectedImageID:String?
    
    @IBOutlet weak var closeFullscreenButton: UIButton!
    
    @IBOutlet weak var deleteImageButton: UIButton!
    @IBOutlet weak var fullscreenImageView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").child(progID!)
        storageRef = storage.reference()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(cellList.count)
        return cellList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnail cell" , for: indexPath) as! ThumbnailCollectionViewCell
        
        cell.imageView.image = nil
        
        let imageFilename = "\(cellList[indexPath.row].ID!).jpg"
        
        let tempFile = try! URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFilename)

        if(FileManager.default.fileExists(atPath: tempFile.path))
        {
            let imageData = try? Data(contentsOf: tempFile)

            cellList[indexPath.row].image = UIImage(data: imageData!)
            cell.imageView.image = UIImage(data: imageData!)
        } else {
            storageRef?.child(Auth.auth().currentUser!.uid).child(imageFilename).getData(maxSize: 10 * 1024 * 1024, completion: {data, error in
                if let error = error {
                    print(imageFilename)
                    print("Error bildhämt")
                    
                }
                else {
                    try? data?.write(to: URL(fileURLWithPath: tempFile.path), options: [.atomicWrite])
                    
                    
                    self.cellList[indexPath.row].image = UIImage(data: data!)
                    cell.imageView.image = UIImage(data: data!)
                }
            })
        }
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Int(collectionView.frame.width/3) - 5, height: Int(collectionView.frame.width/3) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        print("clicked")
        
        fullscreenImageView.isHidden = false
        closeFullscreenButton.isHidden = false
        deleteImageButton.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        let cell = imageCollectionView.cellForItem(at: indexPath) as! ThumbnailCollectionViewCell
        fullscreenImageView.image = cell.imageView.image
        selectedImageID = cellList[indexPath.row].ID

    }
    
    @IBAction func backFromFullscreen(_ sender: Any) {
        fullscreenImageView.isHidden = true
        closeFullscreenButton.isHidden = true
        deleteImageButton.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        fullscreenImageView.image = nil
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        print(selectedImageID)
        progRef!.child("Images").child(selectedImageID!).removeValue()
        self.storageRef?.child(Auth.auth().currentUser!.uid).child("\(selectedImageID!).jpg").delete(completion: nil)

        backFromFullscreen(deleteImageButton!)
        self.cellList.removeAll()
        self.loadCells()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        print("Will called")
        self.cellList.removeAll()
        self.imageCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Did called")
        loadCells()
      /*  for c in self.cellList
        {
            let sliderTab = self.tabBarController!.viewControllers![1] as! SliderVC
            if let imageID = c.ID
            {
                sliderTab.imageIDList.append(imageID)
            }
            
        }*/
    }
    
    func loadCells()
    {
        //self.cellList.removeAll(keepingCapacity: false)
        
        progRef?.child("Images").observe(.value, with: { snapshot in
            for p in snapshot.children
            {
                
                let imagesSnapshot = p as! DataSnapshot
                let newCell = ThumbnailCollectionViewCell()
                newCell.ID = imagesSnapshot.key
                newCell.date = imagesSnapshot.childSnapshot(forPath: "Date").value as! String

                self.cellList.append(newCell)
            }
            self.cellList.sort(by: {$0.date! < $1.date!})
            self.imageCollectionView.reloadData()
            

        }) { (error) in
            print(error.localizedDescription)
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue to camera") {
            let cameraVC = segue.destination as! CameraVC
            cameraVC.progID = self.progID
            if(cellList.isEmpty == false)
            {
                cameraVC.transPicID = self.cellList[Int(cellList.count) - 1].ID!
            }
        }
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
