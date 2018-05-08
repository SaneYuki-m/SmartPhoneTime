//
//  GroupMemberViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/05/06.
//  Copyright © 2018年 Lame. All rights reserved.
//


import UIKit
import Firebase

class GroupMemberViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    let usrD = UserDefaults.standard
    var groupMember:[String] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        groupMember = usrD.object(forKey: "gm") as! [String]
        print("finviewdid")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func approveButton(_ sender: UIButton) {
        if usrD.bool(forKey:"niltag"){
            let alertController = UIAlertController(title: "test",message: "アラートボタン", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                let storyboard: UIStoryboard = self.storyboard!
                let main = storyboard.instantiateViewController(withIdentifier: "tabbar")
                self.present(main, animated: true, completion: nil)
            }
            alertController.addAction(okAction)
            present(alertController,animated: true,completion: nil)
        }else{
            print("a")
            var username:String = ""
            var uid = ""
            ref.child("groups").child(usrD.string(forKey:"indexpath")!).child("leader").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                username = value?["leader"] as? String ?? ""
                print(username)
                print(self.usrD.string(forKey: "uid")!)
                uid = self.usrD.string(forKey: "uid")!
            });
            if username == uid{
                let storyboard: UIStoryboard = self.storyboard!
                let main = storyboard.instantiateViewController(withIdentifier: "groupapp")
                self.present(main, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "test",message: "アラートボタン", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){ (action: UIAlertAction) in
                    let storyboard: UIStoryboard = self.storyboard!
                    let main = storyboard.instantiateViewController(withIdentifier: "tabbar")
                    self.present(main, animated: true, completion: nil)
                }
                alertController.addAction(okAction)
                present(alertController,animated: true,completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("fincount")
        return groupMember.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SampleCell1", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = groupMember[indexPath.row]
        print("fintableview")
        return cell
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
