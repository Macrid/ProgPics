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
    var sliderVC:SliderVC?
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").child(progID!)
        storageRef = storage.reference()
        sliderVC = self.tabBarController!.viewControllers![1] as? SliderVC
        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

            cell.image = UIImage(data: imageData!)
            cell.imageView.image = UIImage(data: imageData!)
            self.sliderVC!.cellList[indexPath.row].image = UIImage(data: imageData!)
        } else {
            storageRef?.child(Auth.auth().currentUser!.uid).child(imageFilename).getData(maxSize: 10 * 1024 * 1024, completion: {data, error in
                if let error = error {
                    print("Error bildhämt")
                    
                }
                else {
                    try? data?.write(to: URL(fileURLWithPath: tempFile.path), options: [.atomicWrite])
                    
                    
                    cell.image = UIImage(data: data!)
                    cell.imageView.image = UIImage(data: data!)
                    self.sliderVC!.cellList[indexPath.row].image = UIImage(data: data!)
                }
            })
        }
        
        
        
        
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
        self.cellList.removeAll()
        self.sliderVC!.cellList.removeAll()
        self.imageCollectionView.reloadData()
        
        progRef?.child("Images").observe(.value, with: { snapshot in
            let count = snapshot.childrenCount
            for p in snapshot.children
            {
                
                let imagesSnapshot = p as! DataSnapshot
                let newCell = ThumbnailCollectionViewCell()
                newCell.ID = imagesSnapshot.key
                newCell.date = imagesSnapshot.childSnapshot(forPath: "Date").value as! String

                self.cellList.append(newCell)
                self.sliderVC?.cellList.append(newCell)
            }
            self.cellList.sort(by: {$0.date! < $1.date!})
            self.sliderVC!.cellList.sort(by: {$0.date! < $1.date!})
            self.imageCollectionView.reloadData()

        }) { (error) in
            print(error.localizedDescription)
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue to camera") {
            let cameraVC = segue.destination as! CameraVC
            cameraVC.progID = self.progID
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
