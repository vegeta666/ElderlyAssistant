//
//  MeViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/1/23.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit
import LeanCloud


class MeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //
    @IBOutlet weak var bottomTableView: UITableView!
    
    @IBOutlet weak var myData: UIButton!
    @IBOutlet weak var imgbutton: UIButton!
    @IBOutlet weak var cancelbutton: UIButton!
    @IBOutlet weak var loginbutton: UIBarButtonItem!
    @IBOutlet weak var username: UILabel!
    var image = UIImage(named: "admin.jpg")?.toCircle()
    var dataArray: Array<Dictionary<String,String>>?
    var isupdatingHead : Bool = false
    @IBOutlet weak var hpt: UIImageView!
    let cql = CQL()
    override func viewWillAppear(_ animated: Bool) {
        //判断用户是否登录
        if let _un = UserDefaults.standard.string(forKey: "name") {
            if _un != ""{
                change(str: _un)
                //获取用户头像
                if !isupdatingHead{
                    cql.getHead(userName: _un, finished: { (img) in
                        DispatchQueue.main.async {
                            self.hpt.image = img
                        }
                        
                    })
                }
            isupdatingHead = false
                
            }else{
                self.myData.isEnabled = false
                self.imgbutton.isEnabled = false
                self.hpt.image = image?.toCircle()
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        self.username.text = "请登录"
        drawBottomtableView()
        //
        
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray?.count)!
    }
    @IBAction func cancel(_ sender: UIButton) {
        self.loginbutton.title = "登录"
        self.loginbutton.isEnabled = true

        self.myData.isEnabled = true
        self.hpt.image = UIImage(named: "admin.jpg")?.toCircle()

        self.username.text = "请登录"
        UserDefaults.standard.set("", forKey: "name")
        self.cancelbutton.setTitle("", for: UIControlState.normal)
        cancelbutton.backgroundColor = UIColor.white
        self.viewWillAppear(true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "meCell", for: indexPath) as! MeTableViewCell
        
        let dic = dataArray![indexPath.row]

        cell.title.text = dic["name"]
        cell.Mimage.image = UIImage(named:dic["image"]!)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator //cell最右边出现>符号
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    //动画效果
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
        
    }
    func drawBottomtableView() {
        //解析plist文件
        let arr: NSArray = NSArray.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forAuxiliaryExecutable: "Me.plist")!))!
        
        dataArray = arr as? Array
        
        
    }
    //用户登录以后界面的改变
    func change(str:String) {
        self.loginbutton.title = ""
        self.loginbutton.isEnabled = false
        self.username.text = str
        self.imgbutton.isEnabled = true
        self.myData.isEnabled = true
        self.cancelbutton.setTitle("注销", for: UIControlState.normal)
        cancelbutton.backgroundColor = UIColor.red
        
    }
    //传递url
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "meShow"{
            let indexPath = bottomTableView.indexPathForSelectedRow
            
            
            //let PurchaseViewC = segue.destination as! PurchaseTableViewController
            let c = segue.destination as! MeWebViewController
            let dic = dataArray![(indexPath?.row)!]
            //PurchaseViewC.titleLb = dic["link"]!
            c.str = dic["link"]!
        }

    }
    
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain ultiple representations of the image. ou want to use the original.
       
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        //hpt.image = selectedImage.toCircle()
 
        self.hpt.image = selectedImage.scaleImage(scaleSize: 0.05).toCircle()
        
        cql.updateHead(userName: username.text!, image: self.hpt.image!)
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        self.isupdatingHead = true

    }
    
    //MARK: Actions


    @IBAction func selectImageFromPL(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "修改头像", style: .default, handler: { (action: UIAlertAction) in
            let imagePickerController = UIImagePickerController()
            // Only allow photos to be picked, not taken.
            imagePickerController.sourceType = .photoLibrary
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)

        }))
     
        //self.present(imagePickerController, animated: true, completion: nil)
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            
        
        present(actionSheet, animated: true, completion: nil)
        //-------------------------------------------------------------
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
