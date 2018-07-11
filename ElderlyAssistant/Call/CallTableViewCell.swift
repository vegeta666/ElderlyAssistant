//
//  CallTableViewCell.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/1/26.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit
import LeanCloud
import MessageUI
import MapKit
class CallTableViewCell: UITableViewCell,MFMessageComposeViewControllerDelegate,CLLocationManagerDelegate {
    let cql = CQL()
    var count : Int = 0
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()


//    var contents = [LCObject]()
    //拨打电话

    @IBAction func Call(_ sender: UIButton) {
       
         UIApplication.shared.openURL(NSURL.init(string:"tel://\(self.Cnum.text!)")!as URL)
        
    }
    @IBAction func message(_ sender: UIButton) {
        //cell里面调用父视图
        var topRootViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while ((topRootViewController?.presentedViewController) != nil) {
            topRootViewController = topRootViewController?.presentedViewController
        }
        //------------------
        let actionSheet = UIAlertController(title: "发送短信", message: "选择你需要发送的短信", preferredStyle: .actionSheet)
//        var d : String?
//        if let _p = UserDefaults.standard.string(forKey: "location") {
//            d = "我现在在" + _p + "遇到一点麻烦，希望你马上赶过来！"
//        }
//
//
//        actionSheet.addAction(UIAlertAction(title: d, style: .default, handler: { (action: UIAlertAction) in
//            //判断设备是否能发短信(真机还是模拟器)
//            if MFMessageComposeViewController.canSendText() {
//                let controller = MFMessageComposeViewController()
//                //短信的内容,可以不设置
//                controller.body = d
//                //联系人列表
//                controller.recipients = [self.Cnum.text] as? [String]
//
//                controller.messageComposeDelegate = self
//                  topRootViewController? .present(controller, animated: true, completion: nil)
//            } else {
//                print("本设备不能发短信")
//            }
  //      }))
        //获取信息数量和信息数组
        if let _un = UserDefaults.standard.string(forKey: "name"){
            self.cql.getMessages(userName: _un, finished: { (messages, c) in
                self.count = c
                let contents = messages.lcValue.jsonValue as! NSArray
                DispatchQueue.main.async {
                    for content in contents{
                        //print("\(content)")
                        let str : String = ((content as! NSDictionary)["content"] as! NSString) as String
                        actionSheet.addAction(UIAlertAction(title: str, style: .default, handler: { (action: UIAlertAction) in
                                if MFMessageComposeViewController.canSendText() {
                                    let controller = MFMessageComposeViewController()
                                    //短信的内容,可以不设置
                                    controller.body = str
                                    //联系人列表
                                    controller.recipients = [self.Cnum.text] as? [String]
                                    //设置代理
                                    controller.messageComposeDelegate = self
                                    //print(str)
                                    topRootViewController? .present(controller, animated: true, completion: nil)
                                } else {
                                    print("本设备不能发短信")
                                }
                        }))
                        
                    }
                }
               
            })
        }
        //显示添加信息
        

        actionSheet.addAction(UIAlertAction(title: "添加信息", style: .destructive, handler: { (action: UIAlertAction) in
        
            
            let alert = UIAlertController(title: "添加信息", message: "信息内容", preferredStyle: .alert)
            alert.addTextField { (textField: UITextField) in
                textField.placeholder = "新信息详情"
            }

            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (alertaction: UIAlertAction) in
                let newMessage = alert.textFields?[0].text
                if let _un = UserDefaults.standard.string(forKey: "name") {
                    
                    self.cql.InsertMesage(userName: _un, insertContent: newMessage!)
                    
                    
                }
                
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            topRootViewController? .present(alert, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))

        
        
        topRootViewController? .present(actionSheet, animated: true, completion: nil)
        
    }
    @IBOutlet weak var Cname: UILabel!
    
    @IBOutlet weak var Cnum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //实现MFMessageComposeViewControllerDelegate的代理方法
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        //判断短信的状态
        switch result{
            
        case .sent:
            print("短信已发送")
        case .cancelled:
            print("短信取消发送")
        case .failed:
            print("短信发送失败")
        default:
            print("短信已发送")
            break
        }
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        //判断设备是否能发短信(真机还是模拟器)
//        if MFMessageComposeViewController.canSendText() {
//            let controller = MFMessageComposeViewController()
//            //短信的内容,可以不设置
//            controller.body = "123456"
//            //联系人列表
//            controller.recipients = [self.Cnum.text] as? [String]
//            //设置代理
//            controller.messageComposeDelegate = self
//            //print(str)
//        } else {
//            print("本设备不能发短信")
//        }
//    }
}
