//
//  GroupResiViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/04/28.
//  Copyright © 2018年 Lame. All rights reserved.
//

import UIKit
import Firebase

class GroupResiViewController: UIViewController, UITextFieldDelegate {

    let usrD = UserDefaults.standard
    
    @IBOutlet weak var passConfText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var groupText: UITextField!
    
    let app:AppDelegate =
        (UIApplication.shared.delegate as! AppDelegate)
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passText.delegate = self
        passText.returnKeyType = .done
        passConfText.delegate = self
        passConfText.returnKeyType = .done
        groupText.delegate = self
        groupText.returnKeyType = .done
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if passText == nil || passConfText == nil || groupText == nil{
            
        }else{
            if passText.text! == passConfText.text!{
                let postRef = ref.child("groups").child(groupText.text!).child("members").child(app.uid)
                let postRef1 = ref.child("groups").child(groupText.text!).child("password")
                let postRef2 = ref.child("groups").child(groupText.text!).child("leader")
            
                let post1:Dictionary<String, Any>? = ["password": passText.text!]
                postRef1.setValue(post1)
                let post:Dictionary<String, Any>? = ["name": usrD.string(forKey: "name")!,
                                                 "time": usrD.integer(forKey: "allTime")]
                postRef.setValue(post)
                let post2:Dictionary<String, Any>? = ["leader": app.uid]
                postRef2.setValue(post2)
            
                var groupArr:[String]
                groupArr = usrD.object(forKey: "group") as? [String] ?? []
            
                if groupArr[0] == "no group"{
                    groupArr.removeFirst()
                }
            
                groupArr.append(groupText.text!)
                print(groupArr)
                usrD.set(groupArr, forKey:"group")
            
                let storyboard: UIStoryboard = self.storyboard!
                let groupsearch = storyboard.instantiateViewController(withIdentifier: "tabbar")
                self.present(groupsearch, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "test",message: "アラートボタン", preferredStyle: UIAlertControllerStyle.alert)
                present(alertController,animated: true,completion: nil)
            }
        }
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
