//
//  PerantViewController.swift
//  OlderApp
//
//  Created by 刘帅 on 2018/1/22.
//  Copyright © 2018年 段佳伟. All rights reserved.
//

import UIKit
import PagingMenuController
private struct PagingMenuOptions:PagingMenuControllerCustomizable{
    //第1个子视图控制器
    private let viewController1 = FirstNewsViewController()
    //第2个子视图控制器
    private let viewController2 = SecondNewsViewController()
//    //第3个子视图控制器
//    private let viewController3 = ThirdViewController()
    
    //组件类型
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [viewController1, viewController2]
    }
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
    }
    
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "综合资讯"))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "疾病资讯"))
        }
    }
    //第3个菜单项
//    fileprivate struct MenuItem3: MenuItemViewCustomizable {
//        //自定义菜单项名称
//        var displayMode: MenuItemDisplayMode {
//            return .text(title: MenuItemText(text: "食品资讯"))
//        }
//    }
}

class PerantViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //分页菜单配置
        let options = PagingMenuOptions()
        //分页菜单控制器初始化
        let pagingMenuController = PagingMenuController(options: options)
        //分页菜单控制器尺寸设置
        pagingMenuController.view.frame.origin.y += 64
        pagingMenuController.view.frame.size.height -= 64
        
        //建立父子关系
        addChildViewController(pagingMenuController)
        //分页菜单控制器视图添加到当前视图中
        view.addSubview(pagingMenuController.view)
       
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
