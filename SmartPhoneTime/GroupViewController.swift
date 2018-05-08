//
//  GroupViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/04/28.
//  Copyright © 2018年 Lame. All rights reserved.
//

import UIKit
import Firebase

class GroupViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var groupTableView: UITableView!
    let usrD = UserDefaults.standard
    var ref: DatabaseReference!
    var groupMember:[String] = []
    var preGroupMember:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(usrD.object(forKey: "group")!)
        let group = usrD.object(forKey: "group") as? [String]
        return group!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = usrD.object(forKey: "group") as? [String]
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SampleCell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = group![indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let group = usrD.object(forKey: "group") as? [String]
        usrD.set(group![indexPath.row], forKey:"indexpath")
        
        ref.child("groups").child(usrD.string(forKey: "indexpath")!).child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.createRoom(value: value as! Dictionary<AnyHashable, Any>)
        });
        
        ref.child("groups").child(usrD.string(forKey: "indexpath")!).child("premembers").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.usrD.set(true, forKey:"niltag")
            if value != nil{
                self.passPre(value: value as! Dictionary<AnyHashable, Any>)
                self.usrD.set(false, forKey:"niltag")
            }
        });
        //セルの選択解除
        tableView.deselectRow(at: indexPath, animated: true)
        //ここに遷移処理を書く
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            let storyboard: UIStoryboard = self.storyboard!
            let groupsearch = storyboard.instantiateViewController(withIdentifier: "groupmember")
            self.present(groupsearch, animated: true, completion: nil)
        }
    }

    func createRoom(value:Dictionary<AnyHashable, Any>){
        for (key,_) in value {
            self.groupMember.append(key as! String)
        }
        usrD.set(groupMember, forKey:"gm")
    }
    
    func passPre(value:Dictionary<AnyHashable, Any>){
        for (key,_) in value {
            self.preGroupMember.append(key as! String)
        }
        usrD.set(preGroupMember, forKey:"passPre")
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
