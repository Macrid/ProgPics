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

    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.dismiss(animated: true, completion: nil)
        }
    }
}

