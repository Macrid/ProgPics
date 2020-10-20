//
//  SliderVC.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-10-18.
//

import UIKit

class SliderVC: UIViewController {

    //var numberOfImages:Int?
    var imageIDList = [String]()
    var imageList = [UIImage]()
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(imageIDList)
        print(imageIDList.count)
        // Do any additional setup after loading the view.
    }

    func loadImageList()
    {
        /*
        let imageFilename = "\(cellList[indexPath.row].ID!).jpg"
        
        let tempFile = try! URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFilename)

        if(FileManager.default.fileExists(atPath: tempFile.path))
        {
            let imageData = try? Data(contentsOf: tempFile)

            cell.image = UIImage(data: imageData!)
            cell.imageView.image = UIImage(data: imageData!)
        } else {
            storageRef?.child(Auth.auth().currentUser!.uid).child(imageFilename).getData(maxSize: 10 * 1024 * 1024, completion: {data, error in
                if let error = error {
                    print("Error bildhämt")
                    
                }
                else {
                    try? data?.write(to: URL(fileURLWithPath: tempFile.path), options: [.atomicWrite])
                    
                    
                    cell.image = UIImage(data: data!)
                    cell.imageView.image = UIImage(data: data!)
                }
            })*/
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
