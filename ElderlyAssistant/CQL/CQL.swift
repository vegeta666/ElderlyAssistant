//
//  CQL.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/2/1.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import Foundation
import LeanCloud
import AVOSCloud
import AVOSCloudIM
import UIKit

extension UIImage {
    //生成圆形图片
    func toCircle() -> UIImage {
        //取最短边长
        let shotest = min(self.size.width, self.size.height)
        //输出尺寸
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        //开始图片处理上下文（由于输出的图不会进行缩放，所以缩放因子等于屏幕的scale即可）
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        //添加圆形裁剪区域
        context.addEllipse(in: outputRect)
        context.clip()
        //绘制图片
        self.draw(in: CGRect(x: (shotest-self.size.width)/2,
                             y: (shotest-self.size.height)/2,
                             width: self.size.width,
                             height: self.size.height))
        //获得处理后的图片
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return maskedImage
    }
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x : 0, y : 0, width:reSize.width, height:reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize, height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
class CQL{
    init() {}
    //初始化健康数据
    func initData(userName:String){
        let newData = LCObject(className:"H_data")
        
        newData.set("username", value: "\(userName)")
        newData.set("t1", value: "0")
        newData.set("t2", value: "0")
        newData.set("t4", value: "0")
        newData.set("t3", value: "0")
        newData.set("t5", value: "0")
        newData.set("t6", value: "0")
        newData.set("t7", value: "0")
        newData.save { result in
            switch result{
            case .success:
                break
            case .failure(let error):
                print(error)
            }
            
        }
    }
    //获取健康信息
    func getData(userName:String,finished : @escaping (_ datas: [LCObject]) -> Void){
        LCCQLClient.execute("select * from H_data where username = '\(userName)'") { result in
            
            switch result {
            case .success:
                finished(result.objects)
                //print(result.objects.lcArray.jsonValue)
            case .failure(let error):
                print(error)
                
            }
            
        }
    }
    //获取信息ID
    func getDataID(userName:String,finished : @escaping (_ id : String) -> Void){
        LCCQLClient.execute("select * from H_data where username = '\(userName)'") { result in
            var obId : String = ""
            switch result {
            case .success:
                //
                let test = result.objects.lcValue.jsonValue as! NSArray
                //print(test)
                for t in test{
                    obId = ((t as! NSDictionary)["objectId"]) as! String
                }
                finished(obId)
                //print(obId)
            case .failure(let error):
                print(error)
                
            }
            
        }
    }
    //更新健康信息
    func updateData(userName:String,t1:String,t2:String,t3:String,t4:String,t5:String,t6:String,t7:String){
        var str : String = ""
        getDataID(userName: userName) { (id) in
            str = id
            LCCQLClient.execute("update H_data set t1 = '\(t1)' where objectId = '\(str)'") { result in
                switch result {
                case .success:
                break // 更新成功
                case .failure(let error):
                    print(error)
                }
            }
            LCCQLClient.execute("update H_data set t2 = '\(t2)' where objectId = '\(str)'") { result in
                switch result {
                case .success:
                break // 更新成功
                case .failure(let error):
                    print(error)
                }
            }
            LCCQLClient.execute("update H_data set t3 = '\(t3)' where objectId = '\(str)'") { result in
                switch result {
                case .success:
                break // 更新成功
                case .failure(let error):
                    print(error)
                }
            }
            LCCQLClient.execute("update H_data set t4 = '\(t4)' where objectId = '\(str)'") { result in
                switch result {
                case .success:
                break // 更新成功
                case .failure(let error):
                    print(error)
                }
            }
            LCCQLClient.execute("update H_data set t5 = '\(t5)' where objectId = '\(str)'") { result in
                switch result {
                case .success:
                break // 更新成功
                case .failure(let error):
                    print(error)
                }
            }
            LCCQLClient.execute("update H_data set t6 = '\(t6)' where objectId = '\(str)'") { result in
                switch result {
                case .success:
                break // 更新成功
                case .failure(let error):
                    print(error)
                }
            }
            LCCQLClient.execute("update H_data set t7 = '\(t7)' where objectId = '\(str)'") { result in
                switch result {
                case .success:
                break // 更新成功
                case .failure(let error):
                    print(error)
                }
            
            
            }
        }
    }
    
    
    //添加联系人
    func InsertContacts(userName:String,insertName:String,insertNum:String){
        let newContact = LCObject(className: "Contacts")
        
        newContact.set("username", value: "\(userName)")
        newContact.set("Cnum", value: "\(insertNum)")
        newContact.set("Cname", value: "\(insertName)")
        
        newContact.save { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    //初始化头像
    func initHead(userName:String,image:UIImage){

        let obj = AVObject(className: "Headportrait")

        let data = UIImagePNGRepresentation(image.toCircle())
        let file = AVFile(data: data!)
        obj.setObject(file, forKey: "headp")


        obj.setObject(userName, forKey: "username")
        obj.saveInBackground()
     
    }
    //获取头像类的objcetId
    func getHpId(userName:String,finished : @escaping (_ id : String) -> Void){
        LCCQLClient.execute("select headp from Headportrait where username = '\(userName)'") { result in
            var obId : String = ""
            switch result {
            case .success:
                //
                let test = result.objects.lcValue.jsonValue as! NSArray
                //print(test)
                for t in test{
                    obId = (t as! NSDictionary)["objectId"] as! String
                }
                finished(obId)
            case .failure(let error):
                print(error)
                
            }
            
        }
    }
    //更换头像
    func updateHead(userName:String,image:UIImage){
        var id:String = "s"
        
        let data = UIImagePNGRepresentation(image.toCircle())
        let file = AVFile(data: data!)
        getHpId(userName: userName) { (Id) in
            id = Id
            let obj = AVObject(className: "Headportrait",objectId: "\(id)")
            
            let data = UIImagePNGRepresentation(image.toCircle())
            let file = AVFile(data: data!)
            obj.setObject(file, forKey: "headp")
            
            obj.saveInBackground()
        }

        
    }
    //获取头像文件的objcetId
    func getHeadId(userName:String,finished : @escaping (_ id : String) -> Void){
        LCCQLClient.execute("select headp from Headportrait where username = '\(userName)'") { result in
            var obId : String = ""
            switch result {
            case .success:
//
                let test = result.objects.lcValue.jsonValue as! NSArray
                //print(test)
                for t in test{
                    obId = ((t as! NSDictionary)["headp"] as! NSDictionary)["objectId"] as! String
                }
                finished(obId)
            case .failure(let error):
                print(error)
                
            }
            
        }
    }
    //通过objectId获取头像信息
    func getHead(userName:String,finished : @escaping (_ image : UIImage) -> Void){
        var id:String = "s"
        getHeadId(userName: userName) { (Id) in
            id = Id
            //print(id)
            LCCQLClient.execute("select url from _File where objectId = '\(id)'") { result in
                switch result{
                case .success:
                    //print(result.objects.lcValue.jsonValue)
                    var url : String = ""
                    let test = result.objects.lcValue.jsonValue as! NSArray
                    
                    for t in test{
                        url = ((t as! NSDictionary))["url"] as! String
                        let url_img = URL(string:url)!
                        //创建请求对象
                        let request = URLRequest(url: url_img)
                        
                        let session = URLSession.shared
                        let dataTask = session.dataTask(with: request, completionHandler: {
                            (data, response, error) -> Void in
                            if error != nil{
                                print(error.debugDescription)
                            }else{
                                //将图片数据赋予UIImage
                                let img = UIImage(data:data!)
                                
                                
                                DispatchQueue.main.async {
                                    finished(img!)
                                }
                                
                            }
                        }) as URLSessionTask
                        
                        //使用resume方法启动任务
                        dataTask.resume()
                        //
                    }
                    //print(url)
                case .failure(let error):
                    print(error)
                    
                }
                
            }
        }
        
        
        
        
        
    }
    //获取联系人信息
    func getContacts(userName:String,finished : @escaping (_ contacts: [LCObject]) -> Void){
        LCCQLClient.execute("select * from Contacts where username = '\(userName)'") { result in

            switch result {
            case .success:
                finished(result.objects)
                //print(result.objects.lcValue.jsonValue)
            case .failure(let error):
                print(error)

            }

        }
    }
    //删除联系人
    func deleteContact(CID:String){
        LCCQLClient.execute("delete from Contacts where objectId='\(CID)'") { result in
            switch result {
            case .success:
            break // 删除成功
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //

    //添加新信息
    func InsertMesage(userName:String,insertContent:String){
        let newMessage = LCObject(className: "Message")
    
        newMessage.set("username", value: "\(userName)")
        newMessage.set("content", value: "\(insertContent)")
    
        newMessage.save { result in
            switch result{
            case .success:
                break
            case .failure(let error):
                print(error)
            }
    
        }
    
    }
    //获取信息
    func getMessages(userName:String,finished : @escaping (_ messages: [LCObject],_ count: Int) -> Void){
        LCCQLClient.execute("select content from Message where username = '\(userName)'") { result in
    
            switch result {
            case .success:
                finished(result.objects,result.count)
    
            case .failure(let error):
                print(error)
    
            }
    
        }
    }
}

