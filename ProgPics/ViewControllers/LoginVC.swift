//
//  ViewController.swift
//  ProgPics
//
//  Created by Admin on 2020-09-15.
//

import UIKit
import Firebase
import FirebaseUI
import CryptoKit

class LoginVC: UIViewController, FUIAuthDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        let layer = CAGradientLayer()
        layer.frame.size = view.frame.size
        
        
        layer.colors = [UIColor.init(red: CGFloat(255/255.0), green: CGFloat(140/255.0), blue: CGFloat(66/255.0), alpha: 1.0).cgColor, UIColor.white.cgColor]
        
        
        self.view.layer.insertSublayer(layer, at: 0)
        
        loginButton.layer.cornerRadius = 10
        iconImageView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
      }
    
    @IBAction func doLogin(_ sender: Any) {
        
        if let authUI = FUIAuth.defaultAuthUI() {
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
        }
        
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
        
            
            print(user.uid)
            performSegue(withIdentifier: "segue to main", sender: nil)
            //self.dismiss(animated: true, completion: nil)
        }
    }
}

