//
//  RegisterViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/1/23.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit
import LeanCloud
import AVOSCloud
import AVOSCloudIM
class RegisterViewController: UIViewController {
    let cql = CQL()
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func register(_ sender: UIButton) {
        let un = userName.text
        let pw = password.text
        //用户名和密码不能为空
        if userName.text?.count != 0 && password.text?.count != 0{
          //密码位数不能小于3
            if (password.text?.count)! < 3{
                let alertB = UIAlertController(title: "注册失败", message: "密码不能少于3位！", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertB.addAction(okAction)
                self .present(alertB, animated: false, completion: nil)
                
            }else{
            
            DispatchQueue.global().async {
                let randomUser = LCUser()
                
                randomUser.username = LCString(un!)
                randomUser.password = LCString(pw!)
                //用户注册
                randomUser.signUp(){ result in
                    switch result {
                    case .success:
                        //初始化头像
                        let image = UIImage(named:"admin.jpg")
                        self.cql.initHead(userName: un!, image: image!)
                        self.cql.initData(userName: un!)
                        let alertB = UIAlertController(title: "注册成功", message: "点击确定跳转", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                            action in
                            self.dismiss(animated: true, completion:nil)
                            
                        })
                        alertB.addAction(okAction)
                        self .present(alertB, animated: false, completion: nil)
                        
                        break
                    case .failure(let error):
                        if error.code == 202{
                            let alertB = UIAlertController(title: "注册失败", message: "用户已经存在", preferredStyle: UIAlertControllerStyle.alert)
                            let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                            alertB.addAction(okAction)
                            self .present(alertB, animated: false, completion: nil)
                        }
                    }
                }
            }
            }
        }else{
            
            
                let alertB = UIAlertController(title: "注册失败", message: "用户名和密码均不能为空", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                alertB.addAction(okAction)
                self .present(alertB, animated: false, completion: nil)
            
            //}
        }
        
    }
    @IBAction func backgroundTap(sender:UIControl){
        userName.resignFirstResponder()
        password.resignFirstResponder()
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
