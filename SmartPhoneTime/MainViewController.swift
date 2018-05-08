//
//  MainViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/04/22.
//  Copyright © 2018年 Lame. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

class MainViewController: UIViewController , UNUserNotificationCenterDelegate{

    @IBOutlet weak var startButton: UIButton!
    let usrD = UserDefaults.standard
    let app:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)

    var alltime = ""
    
    @IBOutlet weak var timerHour: UILabel!
    @IBOutlet weak var timerMinute: UILabel!
    @IBOutlet weak var timerSecond: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(usrD.string(forKey: "uid") != nil){
            app.uid = usrD.string(forKey: "uid")!
        }else{
            usrD.set(app.uid, forKey: "uid")
        }
        
        ref = Database.database().reference()
        
        if usrD.object(forKey: "group") == nil {
            usrD.set(["no group"], forKey: "group")
        }
        
        let post:Dictionary<String, Any>? = ["name": usrD.string(forKey: "name")!,
                                            "pass": usrD.string(forKey: "pass")!,
                                            "time": usrD.integer(forKey: "allTime"),
                                            "group": usrD.object(forKey: "group") as! [String]]
        
        let postRef = ref.child("users").child(app.uid)
        postRef.setValue(post)
        
        timerHour.text = "00"
        timerMinute.text = "00"
        timerSecond.text = "00"
        
        addStudyTime()
        notification()
        // Do any additional setup after loading the view.
    }
    
    func addStudyTime(){
            // タイマー開始からのインターバル時間
            let currentTime = Double(usrD.integer(forKey: "allTime"))
            let hour = (Int)(fmod((currentTime/3600), 60))
            let minute = (Int)(fmod((currentTime/60), 60))
            let second = (Int)(fmod(currentTime, 60))
        
            // %02d： ２桁表示、0で埋める
            let sHour = String(format:"%02d", hour)
            let sMinute = String(format:"%02d", minute)
            let sSecond = String(format:"%02d", second)
        
            timerHour.text = sHour
            timerMinute.text = sMinute
            timerSecond.text = sSecond
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func makeGroup(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let group = storyboard.instantiateViewController(withIdentifier: "group")
        self.present(group, animated: true, completion: nil)
    }
    
    @IBAction func searchGroup(_ sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let groupsearch = storyboard.instantiateViewController(withIdentifier: "groupsearch")
        self.present(groupsearch, animated: true, completion: nil)
    }
    
    func notification(){
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                if granted {
                    print("通知許可")
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                } else {
                    print("通知拒否")
                }
            })
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
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
