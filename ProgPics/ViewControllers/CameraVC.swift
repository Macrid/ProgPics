//
//  CameraVC.swift
//  ProgPics
//
//  Created by Erik Persson on 2020-10-14.
//

import UIKit
import AVFoundation
import Firebase

class CameraVC: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var toggleFlashButton: UIButton!
    @IBOutlet weak var seethroughImage: UIImageView!
    
    var captureSession : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    var device : AVCaptureDevice!
    var flashIsOn = false
    var usingFrontCamera = false
    
    var progID:String?
    var imageID:String?
    let storage = Storage.storage()
    var storageRef:StorageReference?
    var imageRef:StorageReference?
    var transPicID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageID = UUID().uuidString
        
        storageRef = storage.reference()
        imageRef = storageRef!.child(Auth.auth().currentUser!.uid).child("\(imageID!).jpg")
        
        if (transPicID != nil)
        {
            getTransparentPicture()
        }
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        cameraOutput = AVCapturePhotoOutput()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        if let input = try? AVCaptureDeviceInput(device: device!) {
                    if (captureSession.canAddInput(input)) {
                        captureSession.addInput(input)
                        if (captureSession.canAddOutput(cameraOutput)) {
                            captureSession.addOutput(cameraOutput)
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.frame = previewView.bounds
                            
                            previewLayer.videoGravity = AVLayerVideoGravity.resize
                            previewView.layer.addSublayer(previewLayer)
                            captureSession.startRunning()
                        }
                    } else {
                        print("issue here : captureSession.canAddInput")
                    }
                } else {
                    print("some problem here")
                }

    }
    
    @IBAction func takePicture(_ sender: Any) {
        let photoSettings : AVCapturePhotoSettings!
        photoSettings = AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        if (flashIsOn)
        {
            photoSettings.flashMode = .on
        }
        else
        {
            photoSettings.flashMode = .off
        }
        photoSettings.isHighResolutionPhotoEnabled = false
        
        
        
        cameraOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let imageData = photo.fileDataRepresentation()
        let sourceImage = UIImage(data: imageData!)
        
        var finalImage:UIImage!
        
        if(usingFrontCamera)
        {
            finalImage = UIImage(cgImage: sourceImage!.cgImage!, scale: sourceImage!.scale, orientation: .leftMirrored)
        }
        else
        {
            finalImage = sourceImage
        }
        
        
        finalImage = ImageHelper().resizeImage(finalImage, newWidth: 500)
        
        imageView.image = finalImage
        overlayView.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func savePicture(_ sender: Any) {
        if(imageView.image == nil)
        {
            return
        }
        uploadImage(imageView: imageView)
    }
    
    @IBAction func cancelPicture(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        imageView.image = nil
        overlayView.isHidden = true
    }
    
    @IBAction func toggleFlash(_ sender: Any) {
        if (flashIsOn)
        {
            toggleFlashButton.setBackgroundImage(UIImage(systemName: "lightbulb.slash.fill"), for: .normal)
            flashIsOn = false
        }
        else
        {
            toggleFlashButton.setBackgroundImage(UIImage(systemName: "lightbulb.fill"), for: .normal)
            flashIsOn = true
        }
    }
    
    @IBAction func swapCamera(_ sender: Any) {
        usingFrontCamera = !usingFrontCamera
          do{
              captureSession.removeInput(captureSession.inputs.first!)

              if(usingFrontCamera){
                  device = getFrontCamera()
              }else{
                  device = getBackCamera()
              }
              let captureDeviceInput1 = try AVCaptureDeviceInput(device: device)
              captureSession.addInput(captureDeviceInput1)
          }catch{
              print(error.localizedDescription)
          }
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
        return nil
    }

    func getBackCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first
        return nil
    }
    
    @IBAction func toggleSeethrough(_ sender: Any)
    {
        if(seethroughImage.isHidden == true)
        {
            seethroughImage.isHidden = false
        }
        else
        {
            seethroughImage.isHidden = true
        }
    }
    
    func uploadImage(imageView: UIImageView)
    {
        let jpegImage = imageView.image?.jpegData(compressionQuality: 0.8)
        
        let progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").child(progID!)
        
        progRef.observeSingleEvent(of: .value, with: { (snapshot) in

                if snapshot.hasChild("Thumbnail"){

                    print("exist")

                }else{

                    progRef.child("Thumbnail").setValue(self.imageID)
                    print("doesn't exist")
                }
        })
        
        imageRef!.putData(jpegImage!, metadata: nil, completion: {(metadata, error) in
           
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.isNavigationBarHidden = false
            
            guard let metadata = metadata
            else {
                print("Error with upload")
                return
            }
            
        })
        progRef.child("Images").child(imageID!).child("Date").setValue(getTodaysDate())
    }
    
    func getTodaysDate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = Date()
        let todaysDate = formatter.string(from: date)
        return todaysDate
    }
    
    func getTransparentPicture()
    {
        let imageFilename = "\(transPicID!).jpg"
        
        let tempFile = try! URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imageFilename)

        if(FileManager.default.fileExists(atPath: tempFile.path))
        {
            let imageData = try? Data(contentsOf: tempFile)
            seethroughImage.image = UIImage(data: imageData!)

        } else {
            storageRef?.child(Auth.auth().currentUser!.uid).child(imageFilename).getData(maxSize: 10 * 1024 * 1024, completion: {data, error in
                if let error = error {
                    print(imageFilename)
                    print("Error bildhämt")
                    
                }
                else {
                    try? data?.write(to: URL(fileURLWithPath: tempFile.path), options: [.atomicWrite])
                    
                    self.seethroughImage.image = UIImage(data: data!)

                }
            })
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue back to gallery")
        {
            //let tabBarController = segue.destination as! UITabBarController
            //let galleryViewController = tabBarController.viewControllers?[0] as! GalleryVC
            let galleryViewController = segue.destination as! GalleryVC
            galleryViewController.progID = progID
        }
    }
}
