//
//  GroupSearchViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/04/28.
//  Copyright © 2018年 Lame. All rights reserved.
//

import UIKit
import Firebase

class GroupSearchViewController: UIViewController, UITextFieldDelegate{

    let usrD = UserDefaults.standard
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var groupLabel: UILabel!
    
    let app:AppDelegate =
        (UIApplication.shared.delegate as! AppDelegate)

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        groupLabel.isUserInteractionEnabled = true
        groupLabel.tag = 1
        backButton.tag = 2
        searchButton.tag = 3
        
        searchText.delegate = self
        searchText.returnKeyType = .done
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let main = storyboard.instantiateViewController(withIdentifier: "tabbar")
        self.present(main, animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        ref.child("groups").child(searchText.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is NSNull {
                self.groupLabel.text! = "no group"
            } else {
                self.groupLabel.text! = self.searchText.text!
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            switch tag {
            case 1:
                if self.groupLabel.text! != "label" && self.groupLabel.text! != "no group"{
                    let postRef =   self.ref.child("groups").child(self.groupLabel.text!).child("premembers").child(self.app.uid)
                    let post:Dictionary<String, Any>? = ["name": self.usrD.string(forKey: "name")!,
                                                     "time": self.usrD.integer(forKey: "allTime")]
                    postRef.setValue(post)
                    alertPresent()
                }
            default:
                break
            }
        }
    }
    
    func alertPresent() {
        let alertController = UIAlertController(title: "test",message: "アラートボタン", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            let storyboard: UIStoryboard = self.storyboard!
            let main = storyboard.instantiateViewController(withIdentifier: "tabbar")
            self.present(main, animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController,animated: true,completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
