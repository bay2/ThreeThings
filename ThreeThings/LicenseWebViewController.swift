//
//  LicenseWebViewController.swift
//  ThreeThings
//
//  Created by xuemincai on 2017/3/10.
//  Copyright © 2017年 xuemincai. All rights reserved.
//

import UIKit

class LicenseWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var licenseUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        guard let url = URL(string: licenseUrl) else {
            return
        }
        
        webView.loadRequest(URLRequest(url: url))
        
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension LicenseWebViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        let injectionJSString = "var script = document.createElement('meta'); script.name = 'viewport'; script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\"; document.getElementsByTagName('head')[0].appendChild(script);"
        
        webView.stringByEvaluatingJavaScript(from: injectionJSString)
        
    }
    
}
