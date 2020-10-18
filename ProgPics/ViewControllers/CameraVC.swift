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
    
    var captureSession : AVCaptureSession!
    var cameraOutput : AVCapturePhotoOutput!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var progID:String?
    var imageID:String?
    var imageRef:StorageReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageID = UUID().uuidString
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        imageRef = storageRef.child(Auth.auth().currentUser!.uid).child("\(imageID!).jpg")
        
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
                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
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
        photoSettings.flashMode = .off
        photoSettings.isHighResolutionPhotoEnabled = false
        
        cameraOutput.capturePhoto(with: photoSettings, delegate: self)
        overlayView.isHidden = false
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let imageData = photo.fileDataRepresentation()
        let theImage = UIImage(data: imageData!)
        
            imageView.image = theImage
        uploadImage(imageView: imageView)
    }
    
    @IBAction func savePicture(_ sender: Any) {
        //uploadImage(imageView: imageView)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPicture(_ sender: Any) {
        let progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").child(progID!)
        
        progRef.child("Images").child(imageID!).removeValue()
        
        imageRef?.delete(completion: nil)
        
        overlayView.isHidden = true
    }
    
    func uploadImage(imageView: UIImageView)
    {
        let jpegImage = imageView.image?.jpegData(compressionQuality: 0.1)
        
        let progRef = Database.database().reference().child(Auth.auth().currentUser!.uid).child("Progressions").child(progID!)

        progRef.child("Images").child(imageID!).child("Date").setValue(getTodaysDate())
        
        imageRef!.putData(jpegImage!, metadata: nil) {(metadata, error) in
            guard let metadata = metadata else {
                print("Error with upload")
                return
            }
            
        }
    }
    
    func getTodaysDate() -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let date = Date()
        let todaysDate = formatter.string(from: date)
        return todaysDate
    }
}
