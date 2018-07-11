//
//  DataViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/4/26.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit
import LeanCloud
class DataViewController: UIViewController {
    let cql = CQL()
    @IBOutlet weak var t1: UITextField!
    @IBOutlet weak var t2: UITextField!
    @IBOutlet weak var t3: UITextField!
    @IBOutlet weak var t4: UITextField!
    @IBOutlet weak var t5: UITextField!
    @IBOutlet weak var t6: UITextField!
    @IBOutlet weak var t7: UITextField!
    //var data = [LCObject]()
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: UIButton) {
        if let _un = UserDefaults.standard.string(forKey: "name") {
            cql.updateData(userName: _un, t1: t1.text!, t2: t2.text!, t3: t3.text!, t4: t4.text!, t5: t5.text!, t6: t6.text!, t7: t7.text!)
            let alertB = UIAlertController(title: "保存成功", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertB.addAction(okAction)
            self .present(alertB, animated: false, completion: nil)
        }

    }
    override func viewDidLoad() {
       
        super.viewDidLoad()
        if let _un = UserDefaults.standard.string(forKey: "name") {
            cql.getData(userName: _un) { (datas) in

                let _datas = datas.lcValue.jsonValue as! NSArray
                //print((_data as! NSDictionary)["t1"])
                for _data in _datas{
                    self.t1.text = ((_data as! NSDictionary)["t1"] as! NSString) as String
                    self.t2.text = ((_data as! NSDictionary)["t2"] as! NSString) as String
                    self.t3.text = ((_data as! NSDictionary)["t3"] as! NSString) as String
                    self.t4.text = ((_data as! NSDictionary)["t4"] as! NSString) as String
                    self.t5.text = ((_data as! NSDictionary)["t5"] as! NSString) as String
                    self.t6.text = ((_data as! NSDictionary)["t6"] as! NSString) as String
                    self.t7.text = ((_data as! NSDictionary)["t7"] as! NSString) as String
                    
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backgroundTap(sender:UIControl){
        t1.resignFirstResponder()
        t2.resignFirstResponder()
        t3.resignFirstResponder()
        t4.resignFirstResponder()
        t5.resignFirstResponder()
        t6.resignFirstResponder()
        t7.resignFirstResponder()
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
