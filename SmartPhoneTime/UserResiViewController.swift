//
//  UserResiViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/04/25.
//  Copyright © 2018年 Lame. All rights reserved.

import UIKit
import LineSDK

class UserResiViewController: UIViewController, UITextFieldDelegate {

    let usrD = UserDefaults.standard
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LineSDKLogin.sharedInstance().delegate = self
        nameText.delegate = self
        nameText.returnKeyType = .done
        passwordText.delegate = self
        passwordText.returnKeyType = .done
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        LineSDKLogin.sharedInstance().start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        usrD.set(nameText.text, forKey:"name")
        usrD.set(passwordText.text, forKey:"pass")
        let storyboard: UIStoryboard = self.storyboard!
        let main = storyboard.instantiateViewController(withIdentifier: "main")
        self.present(main, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを隠す
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension UserResiViewController: LineSDKLoginDelegate {
    
    func didLogin(_ login: LineSDKLogin,
                  credential: LineSDKCredential?,
                  profile: LineSDKProfile?,
                  error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        // アクセストークン
        if let accessToken = credential?.accessToken {
            print("accessToken : \(accessToken)")
        }
        
        // 表示名
        if let displayName = profile?.displayName {
            usrD.set(displayName, forKey:"name")
        }
        
        // ユーザID
        if let userID = profile?.userID {
            usrD.set(userID, forKey:"uid")
        }
        
        // プロフィール写真のURL
        if let pictureURL = profile?.pictureURL {
            usrD.set(pictureURL, forKey:"pictureURL")
            
        }
        
        let storyboard: UIStoryboard = self.storyboard!
        let main = storyboard.instantiateViewController(withIdentifier: "tabbar")
        self.present(main, animated: true, completion: nil)
    }
}
