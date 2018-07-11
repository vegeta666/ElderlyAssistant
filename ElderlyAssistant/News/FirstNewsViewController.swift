//
//  FirstNewsViewController.swift
//  OlderApp
//
//  Created by 刘帅 on 2018/1/22.
//  Copyright © 2018年 段佳伟. All rights reserved.
//

import UIKit

class FirstNewsViewController: UITableViewController{

    
//    let headImage = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3))
    
    let firstView = 6
    let v = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3 - 30))
    let headImage = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3 - 30))
    let headLable = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/3-80, width: UIScreen.main.bounds.width, height: 50))
    
    let table:UITableView = UITableView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/3 - 30, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*2/3-100), style:UITableViewStyle.plain)
    //let loadingView: LoadingView = LoadingView(frame: CGRect(x: UIScreen.main.bounds.width/2-50, y: UIScreen.main.bounds.height/3-50, width: 100, height: 100))
  
    var DataSource = [NewsItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        headImage.addTarget(self, action: #selector(addFirstView), for: .touchUpInside)
        headLable.backgroundColor = UIColor(displayP3Red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.55)
        headLable.textAlignment = .center
        
        //下拉刷新
        var refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string:"下拉刷新")
        refreshControl.addTarget(self, action: #selector(FirstNewsViewController.getDataSource), for: UIControlEvents.valueChanged)
        self.refreshControl = refreshControl
        //
        
        //loadingView.backgroundColor = UIColor(displayP3Red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 0.3)
        //self.view.addSubview(self.loadingView)
        DispatchQueue.global().async {
          self.getDataSource()
            DispatchQueue.main.async{
                self.v.addSubview(self.headImage)
                self.v.addSubview(self.headLable)

                self.tableView.addSubview(self.v)
                self.tableView.addSubview(self.table)
                self.table.dataSource = self
                self.table.delegate = self
                self.loadHeaderInfor()
            }
        }
        }
        // Do any additional setup after loading the view.

    @objc func getDataSource(){
        DispatchQueue.main.async {
            self.refreshControl?.beginRefreshing()
        }
        
        do{
            
            let url = URL(string: "http://route.showapi.com/96-109?showapi_appid=45739&tid=1&keyword=&page=1&showapi_sign=96bc4c4d4ff14934bd8457f7ae343a86")
            let data = try Data(contentsOf: url!)
            
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if var dic = object as? [String:Any] {
                
                if var body = dic["showapi_res_body"] as? [String:Any]{
                    if var pagebean = body["pagebean"] as? [String:Any]{
                        let NewsDataSource = pagebean["contentlist"] as! NSArray
                        let CurrentNewsData = NSMutableArray()
                        for currentnews in NewsDataSource{
                            let newsitem = NewsItem()
                            
                            newsitem.NewsTitle = (currentnews as! NSDictionary)["title"] as! NSString
                            newsitem.NewsThumb = (currentnews as! NSDictionary)["img"] as! NSString
                            newsitem.NewsID = (currentnews as! NSDictionary)["id"] as! NSString
                            newsitem.Tname = (currentnews as! NSDictionary)["tname"] as! NSString
                            
                            CurrentNewsData.add(newsitem)
                        }
                        
                        self.DataSource = CurrentNewsData as! [NewsItem]
                        //没有异步处理
                    }
                }
            }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
            
        }catch{
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadHeaderInfor(){
        do{
            
            let url = NSURL(string:DataSource[firstView].NewsThumb as NSString as String)
            if (url != nil){
                let data = try Data(contentsOf: url! as URL)
                self.headImage.setImage(UIImage(data:data), for: UIControlState.normal)
                self.headLable.text = DataSource[firstView].NewsTitle as String
                
            }
            
        }catch{
            print("error")
        }
    }
    @objc func addFirstView() {
        let newId = DataSource[firstView].NewsID as NSString
        let vc = showViewController()
        vc.DetailID = newId
        vc.Tname = DataSource[0].Tname
        vc.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         //print("进来了tableView")
        let indentifier = "MineCenterCell"
        var cell:MyTableViewCell! = tableView.dequeueReusableCell(withIdentifier: indentifier)as?MyTableViewCell
        if cell == nil {
            cell = MyTableViewCell(style: .default, reuseIdentifier: indentifier)
        }
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator //右边小箭头
        cell.content?.text = DataSource[indexPath.row].NewsTitle as String
        do{
            let url = NSURL(string:DataSource[indexPath.row].NewsThumb as NSString as String)
            let data = try Data(contentsOf: url! as URL)
            let image = UIImage(data:data,scale:11)
            cell.showImage?.image = image
            
        }catch{
            //print("error")
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newId = DataSource[indexPath.row].NewsID as NSString
        let vc = showViewController()
        vc.DetailID = newId
        vc.Tname = DataSource[0].Tname
        vc.view.backgroundColor = UIColor.white
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
        
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
