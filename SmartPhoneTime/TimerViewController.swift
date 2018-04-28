//
//  ViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/04/22.
//  Copyright © 2018年 Lame. All rights reserved.
//

import UIKit
import UserNotifications

class TimerViewController: UIViewController , UNUserNotificationCenterDelegate {
    
    let usrD = UserDefaults.standard
    
    @IBOutlet weak var timerMinute: TimerLabel!
    @IBOutlet weak var timerHour: TimerLabel!
    @IBOutlet weak var timerSecond: TimerLabel!
    
    @IBOutlet weak var endButton: UIButton!
    var backTime:Date?
    weak var timer: Timer!
    var startTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usrD.set(false, forKey: "endFlag")
        
        timerHour.text = "00"
        timerMinute.text = "00"
        timerSecond.text = "00"
        
        registerforDeviceLockNotification()
        
        NotificationCenter.default.addObserver(self, selector: #selector(TimerViewController.viewWillEnterForeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TimerViewController.viewDidEnterBackground(_:)), name: .UIApplicationDidEnterBackground, object: nil)
        
        startTimer()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func startTimer() {
        if timer != nil{
            // timerが起動中なら一旦破棄する
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
        
        startTime = Date()
    }
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTime)
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
    
    func alertPresent() {
        let currentTime = Int(Date().timeIntervalSince(startTime))
        let allTime = usrD.integer(forKey: "allTime") + currentTime
        
        usrD.set(allTime,forKey: "allTime")
        
        let alertController = UIAlertController(title: "test",message: "アラートボタン", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
            let storyboard: UIStoryboard = self.storyboard!
            let main = storyboard.instantiateViewController(withIdentifier: "main")
            self.present(main, animated: true, completion: nil)
        }
         
        alertController.addAction(okAction)
        present(alertController,animated: true,completion: nil)
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification?) {
        if (self.isViewLoaded && (self.view.window != nil)) {
            if !usrD.bool(forKey: "lockFlag") && usrD.bool(forKey: "backFlag"){
                let intervalTime = Date().timeIntervalSince(backTime!)
                if intervalTime >= 15{
                    usrD.set(true, forKey: "endFlag")
                    print("endFlagがtrue")
                }
            }
            
            usrD.set(false, forKey: "lockFlag")
            usrD.set(false, forKey: "backFlag")
            
            print("Timerでforgroundにきました")
            if usrD.bool(forKey: "endFlag"){
                print("endFlag=trueでforegroundにきました")
                alertPresent()
                usrD.set(false, forKey: "endFlag")
            }
        }
    }
    
    @objc func viewDidEnterBackground(_ notification: Notification?) {
        if (self.isViewLoaded && (self.view.window != nil)) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //backTagをtrue
                self.usrD.set(true, forKey: "backFlag")
                print("bockFlag:\(self.usrD.bool(forKey: "backFlag"))")
                print("lockFlag:\(self.usrD.bool(forKey: "lockFlag"))")
            
                self.backTime = Date()
            
                if !self.usrD.bool(forKey: "lockFlag"){
                    //　通知設定に必要なクラスをインスタンス化
                    let trigger: UNNotificationTrigger
                    let content = UNMutableNotificationContent()
                    // 設定したタイミングを起点として1分後に通知したい場合
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    // 通知内容の設定
                    content.title = "あれ？"
                    content.body = "勉強は？"
                    content.sound = UNNotificationSound.default()
                    // 通知スタイルを指定
                    let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
                    // 通知をセット
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
            }
        }
    }
    
    func registerforDeviceLockNotification() {
        //Screen lock notifications
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),     //center
            Unmanaged.passUnretained(self).toOpaque(),     // observer
            displayStatusChangedCallback,     // callback
            "com.apple.springboard.lockcomplete" as CFString,     // event name
            nil,     // object
            .deliverImmediately)
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),     //center
            Unmanaged.passUnretained(self).toOpaque(),     // observer
            displayStatusChangedCallback,     // callback
            "com.apple.springboard.lockstate" as CFString,    // event name
            nil,     // object
            .deliverImmediately)
    }
    
    private let displayStatusChangedCallback: CFNotificationCallback = { _, cfObserver, cfName, _, _ in
        guard let lockState = cfName?.rawValue as String? else {
            return
        }
        let catcher = Unmanaged<TimerViewController>.fromOpaque(UnsafeRawPointer(OpaquePointer(cfObserver)!)).takeUnretainedValue()
        catcher.displayStatusChanged(lockState)
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        alertPresent()
    }
    
    private func displayStatusChanged(_ lockState: String) {
        // the "com.apple.springboard.lockcomplete" notification will always come after the "com.apple.springboard.lockstate" notification
        if (lockState == "com.apple.springboard.lockcomplete") {
            print("DEVICE LOCKED")
            usrD.set(true, forKey: "lockFlag")
            print("lockFlag:\(usrD.bool(forKey: "lockFlag"))")
        }
    }
}

