//
//  ContentViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/4/26.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    var str:String?
    override func viewDidLoad() {
        //print(str)
        content.text = str
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var content: UITextView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
