//
//  BeforeAfterVC.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-10-26.
//

import UIKit
import Firebase

class BeforeAfterVC: UIViewController {

    var firstImage:UIImage?
    var lastImage:UIImage?
    
    var firstImageID = ""
    var lastImageID = ""
    
    var storage = Storage.storage()
    var storageRef:StorageReference?
    
    var progRef:DatabaseReference?
    var progID:String?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame.size = view.frame.size
        
        layer.colors = [UIColor.init(red: CGFloat(78/255.0), green: CGFloat(89/255.0), blue: CGFloat(140/255.0), alpha: 1.0).cgColor, UIColor.white.cgColor]
        
        
        self.view.layer.insertSublayer(layer, at: 0)
        
        let tabBar = self.tabBarController! as! ProgressTabBarController
        progID = tabBar.progID
        
        storageRef = storage.reference()
        
        progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").child(progID!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(switchImage(_:)))
         imageView.addGestureRecognizer(tap)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        loadImages()
        
        print(firstImageID)
        print(lastImageID)
    }
    
    
    @objc func switchImage(_ sender: UITapGestureRecognizer)
    {
        print("click")
        if(imageView.image == firstImage)
        {
            imageView.image = lastImage
        }
        
        else
        {
            imageView.image = firstImage
        }
    }

    func fetchImage(imageID: String, isFirstImage: Bool)
    {
        var image:UIImage?
        
        let imageFilename = "\(imageID).jpg"
        
        let tempFile = try! URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFilename)

        if(FileManager.default.fileExists(atPath: tempFile.path))
        {
            let imageData = try? Data(contentsOf: tempFile)
            
            if(isFirstImage == true)
            {
                firstImage = UIImage(data: imageData!)
            }
            else
            {
                lastImage = UIImage(data: imageData!)
            }
            
        } else
        {
            storageRef?.child(Auth.auth().currentUser!.uid).child(imageFilename).getData(maxSize: 10 * 1024 * 1024, completion: {data, error in
                if let error = error {
                    print("Error bildhämt")
                    
                }
                else {
                    try? data?.write(to: URL(fileURLWithPath: tempFile.path), options: [.atomicWrite])
                    
                    if(isFirstImage == true)
                    {
                        self.firstImage = UIImage(data: data!)
                    }
                    else
                    {
                        self.lastImage = UIImage(data: data!)
                    }
                    
                }
            })
            
        }
    }
    
    func loadImages()
    {
        let galleryTab = self.tabBarController!.viewControllers![0] as! GalleryVC
        
        if(galleryTab.cellList.isEmpty)
        {
            return
        }
        
        firstImageID = (galleryTab.cellList.first?.ID)!
        lastImageID = (galleryTab.cellList.last?.ID)!
        
        fetchImage(imageID: firstImageID, isFirstImage: true)
        fetchImage(imageID: lastImageID, isFirstImage: false)
        
        imageView.image = firstImage
        
        /*
        progRef?.child("Images").observe(.value, with: { snapshot in

            for p in snapshot.children
            {
                let imagesSnapshot = p as! DataSnapshot
                ImageIDs.append(imagesSnapshot.key)
            }

            
            if(ImageIDs.count > 1)
            {
                self.firstImageID = ImageIDs[0]
                self.lastImageID = ImageIDs[ImageIDs.count - 1]
            }
            self.fetchImage(imageID: self.firstImageID, isFirstImage: true)
            self.fetchImage(imageID: self.lastImageID, isFirstImage: false)
            
            self.imageView.image = self.firstImage
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
*/
    }
}
