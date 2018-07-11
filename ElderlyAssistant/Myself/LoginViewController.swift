//
//  LoginViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/1/23.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit
import LeanCloud
class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var un: UITextField!
    @IBOutlet weak var pw: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func Login(_ sender: UIButton) {
        let _un = un.text
        let _pw = pw.text
        if un.text?.count != 0 && pw.text?.count != 0{
            LCUser.logIn(username: _un!, password: _pw!) { result in
                switch result {
                case .success(let user):

                    UserDefaults.standard.set(_un!, forKey: "name")
                  
                    
                    
                    let alertB = UIAlertController(title: "登录成功", message: "点击确定跳转", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                        action in
                        self.dismiss(animated: true, completion:nil)
                        
                    })
                    alertB.addAction(okAction)
                    self .present(alertB, animated: false, completion: nil)
                    
                    break
                case .failure(let error):
                    if error.code == 210{
                        let alertB = UIAlertController(title: "登录失败", message: "用户和密码不匹配！", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                        alertB.addAction(okAction)
                        self .present(alertB, animated: false, completion: nil)
                    }else if error.code == 211{
                        let alertB = UIAlertController(title: "登录失败", message: "用户不存在！", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                        alertB.addAction(okAction)
                        self .present(alertB, animated: false, completion: nil)
                    }else{
                        let alertB = UIAlertController(title: "登录失败", message: "系统繁忙，请稍后再试！", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                        alertB.addAction(okAction)
                        self .present(alertB, animated: false, completion: nil)
                    }
                }
            }
        }else{
            let alertB = UIAlertController(title: "登录失败", message: "用户名和密码均不能为空！", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertB.addAction(okAction)
            self .present(alertB, animated: false, completion: nil)
        }
        
    }
    //隐藏键盘事件
    @IBAction func backgroundTap(sender:UIControl){
        un.resignFirstResponder()
        pw.resignFirstResponder()
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
