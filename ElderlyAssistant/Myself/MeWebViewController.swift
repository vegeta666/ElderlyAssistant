//
//  MeWebViewController.swift
//  ElderlyAssistant
//
//  Created by 段佳伟 on 2018/1/26.
//  Copyright © 2018年 2015110410. All rights reserved.
//

import UIKit
import WebKit
class MeWebViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
    lazy private var webview: WKWebView = {
        self.webview = WKWebView.init(frame: CGRect(x: 0, y : self.view.bounds.height / 11, width: self.view.bounds.width, height: self.view.bounds.height))
        self.webview.uiDelegate = self
        self.webview.navigationDelegate = self
        return self.webview
    }()
    

    
    lazy private var progressView: UIProgressView = {
        self.progressView = UIProgressView.init(frame: CGRect(x: CGFloat(0), y: CGFloat(65), width: UIScreen.main.bounds.width, height: 2))
        self.progressView.tintColor = UIColor.green      // 进度条颜色
        self.progressView.trackTintColor = UIColor.white // 进度条背景色
        return self.progressView
    }()
    //
    //@IBOutlet weak var Web: UIWebView!
    
    var str:String?

    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func back(_ sender: UIButton) {
        self.webview.goBack()
        
    }
    @IBAction func refresh(_ sender: UIButton) {
        self.webview.reload()
    }
    override func viewWillAppear(_ animated: Bool) {
        view.addSubview(webview)
        view.addSubview(progressView)
        
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
       webview.load(URLRequest.init(url: URL.init(string: str!)!))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Web.addSubview(wk)
        
        //loadWeb(url: str!)
           
        
        
        // Do any additional setup after loading the view.
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress"{
            progressView.alpha = 1.0
            progressView.setProgress(Float(webview.estimatedProgress), animated: true)
            if webview.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                    self.progressView.alpha = 0
                }, completion: { (finish) in
                    self.progressView.setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("开始获取网页内容")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("加载完成")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
        webview.uiDelegate = nil
        webview.navigationDelegate = nil
    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
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
