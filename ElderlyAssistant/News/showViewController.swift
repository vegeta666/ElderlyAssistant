//
//  showViewController.swift
//  OlderApp
//
//  Created by 刘帅 on 2018/2/8.
//  Copyright © 2018年 段佳伟. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
class showViewController: UIViewController {
    let lable: UILabel = UILabel(frame: CGRect(x: 20, y: UIScreen.main.bounds.height/9 - 2, width: UIScreen.main.bounds.width/4, height: 20))
    let slider: UISlider = UISlider(frame: CGRect(x: 20+UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.height/9 - 2, width: UIScreen.main.bounds.width*3/4-20, height: 20))
    let headLable: UILabel = UILabel(frame: CGRect(x: 20, y: UIScreen.main.bounds.height/10+20, width: UIScreen.main.bounds.width-40, height: 60))
    
    let content: UITextView = UITextView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height/1.9+20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height/2.1-20))
    let showImage: UIImageView = UIImageView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height/4+20, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height/3.6))
    var AuthorAndTitle: UILabel = UILabel(frame: CGRect(x: 18, y: UIScreen.main.bounds.height/5+20, width: UIScreen.main.bounds.width-40, height: 40))
    var btuPlay = UIBarButtonItem()
    var isPlay:Bool = false
    let syntesizer = AVSpeechSynthesizer()
    
    var voice = AVSpeechSynthesisVoice.init(language: "zh-CN")
    var utterance = AVSpeechUtterance()

    var voiceText = String()
    var DetailURL1 = "http://route.showapi.com/96-36?showapi_appid=45739&id="
    var DetailURL2 = "&showapi_sign=96bc4c4d4ff14934bd8457f7ae343a86"
    var DetailID = NSString()
    var Tname = NSString()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //滑动条
        slider.maximumValue = 60
        slider.minimumValue = 20
        slider.minimumTrackTintColor = UIColor.green
        slider.maximumTrackTintColor = UIColor.blue
        slider.thumbTintColor = UIColor.red
        
    
        slider.addTarget(self, action: #selector(changeFont), for: UIControlEvents.valueChanged)
        
        lable.text = "字体大小"+String(Int(slider.value))
        
        headLable.lineBreakMode = NSLineBreakMode.byWordWrapping
        headLable.numberOfLines = 0;
        headLable.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        AuthorAndTitle.textColor = UIColor.lightGray
        AuthorAndTitle.font = UIFont(name:"",size: 3)
        
        
        btuPlay = UIBarButtonItem(image: #imageLiteral(resourceName: "button-play.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(read))
        self.navigationItem.rightBarButtonItem = btuPlay
        //self.tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true   //页面切换可隐藏tabbar
        self.view.addSubview(lable)
        self.view.addSubview(slider)
        self.view.addSubview(content)
        self.view.addSubview(showImage)
        self.view.addSubview(headLable)
        self.view.addSubview(AuthorAndTitle)
        loadDataSource()
        self.tabBarController?.tabBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // AuthorAndTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        syntesizer.stopSpeaking(at: .immediate)
    }
    @objc func read(){
        if !isPlay{
            let string = voiceText
            
            // 设置将要语音的文字
            utterance = AVSpeechUtterance(string:string)
            //
            utterance.voice = voice
            // 语音的速度
            utterance.rate = 0.4
            // 开始朗读
            
            syntesizer.speak(utterance)
            isPlay = true
            btuPlay = UIBarButtonItem(image:#imageLiteral(resourceName: "button-pause.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(read))
            self.navigationItem.rightBarButtonItem = btuPlay
        }else{
            syntesizer.stopSpeaking(at: .immediate)
            isPlay = false
            btuPlay = UIBarButtonItem(image: #imageLiteral(resourceName: "button-play.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(read))
            self.navigationItem.rightBarButtonItem = btuPlay
        }
    }
    
    @objc func changeFont(slider: UISlider){
        content.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(slider.value))
        lable.text = "字体大小"+String(Int(slider.value))
    }

    func loadDataSource(){
        do{
            let url = URL(string: DetailURL1 + (DetailID as! String) + DetailURL2)
            let data = try Data(contentsOf: url!)

            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if var dic = object as? [String:Any] {
                if var body = dic["showapi_res_body"] as? [String:Any]{
                    if var item = body["item"] as? [String:Any]{
                       let title = item["title"] as! String
                        let author = item["author"] as! String
                        let time = item["time"] as! String
                        let content = item["content"] as! String
                        self.content.font = UIFont.systemFont(ofSize: 100)
                        //content = "STRONG{font-size:100px;}" + content
                        //print(content)
                        //富文本将html语言解析成文本
                        voiceText = content
                        let attribstr = try! NSMutableAttributedString.init(data:(content.data(using: String.Encoding.unicode))! , options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html], documentAttributes: nil)
                        //print(attribstr)
                        attribstr.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Bold", size: 20)!,
                                               range: NSMakeRange(0,attribstr.length))

                      


                        //创建URL对象
                        let url_img = URL(string:item["img"]! as! String)!
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

                                // 这里需要改UI，需要回到主线程
                                DispatchQueue.main.async {

                                  
                                    self.showImage.image = img
                                    self.AuthorAndTitle.text = author + "  " + time
                                    self.headLable.text = title
                                    self.content.attributedText = attribstr

                                }

                            }
                        }) as URLSessionTask

                        //使用resume方法启动任务
                        dataTask.resume()
                    }
                }
            }
        }catch{

        }



    }
    func backPush(){
        self.navigationController?.popViewController(animated: true)
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
