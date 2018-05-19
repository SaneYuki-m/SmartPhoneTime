//
//  GroupApproveViewController.swift
//  SmartPhoneTime
//
//  Created by 牧野真之 on 2018/05/06.
//  Copyright © 2018年 Lame. All rights reserved.
//

import UIKit
import Firebase

class GroupApproveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let usrD = UserDefaults.standard
    var ref: DatabaseReference!
    var preGroupMember: [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        preGroupMember = usrD.object(forKey: "passPre") as! [String]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preGroupMember.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SampleCell2", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = preGroupMember[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func approveAlert(){
        
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
