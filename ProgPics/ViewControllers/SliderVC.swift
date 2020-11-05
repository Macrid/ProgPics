//
//  SliderVC.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-10-18.
//

import UIKit
import Firebase

class SliderVC: UIViewController {

    //var numberOfImages:Int?
    var imageIDList = [String]()
    var imageList = [UIImage]()
    var storage = Storage.storage()
    var storageRef:StorageReference?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = CAGradientLayer()
        layer.frame.size = view.frame.size
        
        layer.colors = [UIColor.init(red: CGFloat(78/255.0), green: CGFloat(89/255.0), blue: CGFloat(140/255.0), alpha: 1.0).cgColor, UIColor.white.cgColor]
        
        
        self.view.layer.insertSublayer(layer, at: 0)
        
        storageRef = storage.reference()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        imageIDList.removeAll()
        imageList.removeAll()
        
        let galleryTab = self.tabBarController!.viewControllers![0] as! GalleryVC
        for c in galleryTab.cellList
        {
            //let sliderTab = self.tabBarController!.viewControllers![1] as! SliderVC
            if let imageID = c.ID
            {
                imageIDList.append(imageID)
            }
            
        }
        
        slider.maximumValue = Float(imageIDList.count - 1)
        
        print(imageIDList)
        print(imageIDList.count)
        loadImageList()
        if(imageList.count != 0)
        {
            imageView.image = imageList[0]
        }
    }
    
    func loadImageList()
    {
        for imageID in imageIDList
        {
            
            let imageFilename = "\(imageID).jpg"
            
            let tempFile = try! URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFilename)

            if(FileManager.default.fileExists(atPath: tempFile.path))
            {
                let imageData = try? Data(contentsOf: tempFile)
                
                imageList.append(UIImage(data: imageData!)!)
               // cell.image = UIImage(data: imageData!)
               // cell.imageView.image = UIImage(data: imageData!)
            } else
            {
                storageRef?.child(Auth.auth().currentUser!.uid).child(imageFilename).getData(maxSize: 10 * 1024 * 1024, completion: {data, error in
                    if let error = error {
                        print("Error bildhämt")
                        
                    }
                    else {
                        try? data?.write(to: URL(fileURLWithPath: tempFile.path), options: [.atomicWrite])
                        
                        self.imageList.append(UIImage(data: data!)!)
                        
                        //cell.image = UIImage(data: data!)
                        //cell.imageView.image = UIImage(data: data!)
                    }
                })
            }
        }
    }
    
    @IBAction func sliderChange(_ sender: Any) {
        if(imageList.count != 0)
        {
            imageView.image = imageList[Int(slider.value)]  
        }


    }

}
