//
//  IndexTableViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/4/26.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit

class IndexTableViewController: UITableViewController {
    var dataArray: Array<Dictionary<String,String>>?
    override func viewDidLoad() {
        super.viewDidLoad()
        drawtableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func drawtableView() {
        //解析plist文件
        let arr: NSArray = NSArray.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forAuxiliaryExecutable: "Index.plist")!))!
        
        dataArray = arr as? Array
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (dataArray?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "indexCell", for: indexPath)
        let dic = dataArray![indexPath.row]
        cell.textLabel?.text = dic["name"]
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator //cell最右边出现>符号
        // Configure the cell...
        //print("\(dic["name"])")
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContent"{
            let indexPath = tableView.indexPathForSelectedRow
            
            let ContentViewController = segue.destination as! ContentViewController
            let dic = dataArray![(indexPath?.row)!]
            
            ContentViewController.str = dic["content"] as! String
            

            
            
        }
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//                if identifier == "showContent"{
//
//
//
//
//                    let c = description as! ContentViewController
//                    let dic = dataArray![(indexPath.row)!]
//                    //PurchaseViewC.titleLb = dic["link"]!
//                    c.str = dic["content"]!
//
//                }
//
//
//    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
