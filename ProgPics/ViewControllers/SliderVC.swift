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
    var timer:Timer!
    
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
        //slider.value = 0
        
        let galleryTab = self.tabBarController!.viewControllers![0] as! GalleryVC
        for c in galleryTab.cellList
        {
            //let sliderTab = self.tabBarController!.viewControllers![1] as! SliderVC
            if let imageID = c.ID
            {
                imageIDList.append(imageID)
            }
            
        }
        
        print(imageIDList)
        print(imageIDList.count)
        print(imageList.count)
        loadImageList()
        slider.maximumValue = Float(imageIDList.count - 1)
        if(imageList.count != 0)
        {
            imageView.image = imageList[0]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        slider.value = 0
        slider.minimumValue = 0
        if(timer != nil)
        {
            timer.invalidate()
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
            print(slider.value)
            timer.invalidate()
            
            let sliderVal = Int(slider.value.rounded(.toNearestOrEven))
            if(sliderVal < imageList.count)
            {
                imageView.image = imageList[sliderVal]
            }
            
            
        }
    }
    
    @IBAction func playPause(_ sender: Any) {
        
        if(timer != nil && timer!.isValid)
        {
            timer!.invalidate()
        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func fireTimer()
    {
        if(imageList.count != 0)
        {
            print(slider.value)
            
            slider.value = slider.value.rounded(.down) + 1
            let sliderVal = Int(slider.value.rounded(.toNearestOrEven))
            if(sliderVal < imageList.count)
            {
                imageView.image = imageList[sliderVal]
            }
            
            
        }
    }
}
