//
//  CallViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/1/22.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit
import LeanCloud

class CallViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var un:String = ""
    var contact = [LCObject]()
    var cql = CQL()
    var DataSource = [ContactsItem]()
    
    @IBOutlet weak var calltableView: UITableView!
    @IBAction func Add(_ sender: UIButton) {
        //判断用户是否登录
        if un == ""{
            
            let alert = UIAlertController(title: "尚未登录！", message: "", preferredStyle: .alert)
            //let view = LoginViewController()
            alert.addAction(UIAlertAction(title: "去登录", style: .default, handler: { (alertaction: UIAlertAction) in

                let sb = UIStoryboard(name: "Main", bundle:nil)
                let vc = sb.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                self.present(vc, animated: true, completion: nil)
                
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        
        }else{
            let alert = UIAlertController(title: "添加联系人", message: "详细信息", preferredStyle: .alert)
            alert.addTextField { (textField: UITextField) in
                textField.placeholder = "姓名"
            }
            alert.addTextField { (textField: UITextField) in
                textField.placeholder = "电话号码"
                //textField.isSecureTextEntry = true
            }
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (alertaction: UIAlertAction) in
                let name = alert.textFields?[0]
                  
                let number = alert.textFields?[1]
                
                self.cql.InsertContacts(userName: self.un, insertName: (name?.text)!, insertNum: (number?.text)!)
                self.loadContacts()
                self.tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        self.tableView.reloadData()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        if let _un = UserDefaults.standard.string(forKey: "name") {
            un = _un
            
            loadContacts()
            
        }

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string:"下拉刷新")
        refreshControl.addTarget(self, action: #selector(CallViewController.loadContacts), for: UIControlEvents.valueChanged)
        self.calltableView.refreshControl = refreshControl
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(self.count)
        return DataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CallTableViewCell =  calltableView.dequeueReusableCell(withIdentifier: "Callcell", for: indexPath) as! CallTableViewCell
        cell.Cname.text = DataSource[indexPath.row].Cname as String
        cell.Cnum.text = DataSource[indexPath.row].Cnum as String
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let contact = DataSource[indexPath.row]
            DataSource.remove(at: indexPath.row)
            cql.deleteContact(CID: contact.CID as String)
            tableView.deleteRows(at: [indexPath], with: .fade)
            loadContacts()
        }
    }
    //加载用户所有联系人
    @objc func loadContacts(){
        self.refreshControl.beginRefreshing()
        DataSource.removeAll()
        self.tableView.reloadData()
        //self.tableView.refreshControl?.beginRefreshing()
        cql.getContacts(userName: self.un, finished: { (contacts) in
            self.contact = contacts
            
            let ContactsDataSource = self.contact.lcValue.jsonValue as! NSArray
            //print(ContactsDataSource)
            let CurrentContactsData = NSMutableArray()
            for currentcontacts in ContactsDataSource{
                
                let contactsitem = ContactsItem()
                
                contactsitem.Cname = (currentcontacts as! NSDictionary)["Cname"] as! NSString
            
                contactsitem.Cnum = (currentcontacts as! NSDictionary)["Cnum"] as! NSString
            
                contactsitem.CID = (currentcontacts as! NSDictionary)["objectId"] as! NSString
                CurrentContactsData.add(contactsitem)
                self.DataSource = CurrentContactsData as! [ContactsItem]
                //print((currentcontacts as! NSDictionary)["createdAt"])
            }
            
            self.tableView.reloadData()
           //self.tableView.refreshControl?.endRefreshing()
        })
        //self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
