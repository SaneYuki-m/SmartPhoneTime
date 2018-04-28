//
//  UserResiViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/04/25.
//  Copyright © 2018年 Lame. All rights reserved.
//

import UIKit
import LineSDK

class UserResiViewController: UIViewController {

    let usrD = UserDefaults.standard
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LineSDKLogin.sharedInstance().delegate = self
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
            print("displayName : \(displayName)")
        }
        
        // ユーザID
        if let userID = profile?.userID {
            print("userID : \(userID)")
        }
        
        // プロフィール写真のURL
        if let pictureURL = profile?.pictureURL {
            print("profile Picture URL : \(pictureURL)")
        }
    }
}
