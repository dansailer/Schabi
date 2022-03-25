//
//  ViewController.swift
//  Schabi
//
//  Created by Daniel Sailer on 24.03.22.
//

import UIKit
import WebKit
//import KeychainSwift

class ViewController: UIViewController {

    let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        configuration.limitsNavigationsToAppBoundDomains = true
        let webView = WKWebView(frame: .zero,
                                configuration: configuration)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        //let keychain = KeychainSwift()
        //let username = (keychain.get("username") ?? "")
        //let password = (keychain.get("password") ?? "")
        //keychain.set("", forKey: "username", withAccess: .accessibleWhenUnlocked)
        //keychain.set("", forKey: "password", withAccess: .accessibleWhenUnlocked)
        
        let username : String? = UserDefaults.standard.string(forKey: "username")
        let password : String? = UserDefaults.standard.string(forKey: "password")
        if (username == nil || password == nil || username == "" || password == "") {
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        exit(0)
                    }
                }
            }
        }
        
        guard let url = URL(string: "https://www.schabi.ch/Account/Login") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "UserName=" + username! + "&Password=" + password! + "&RememberMe=true&returnUrl=";
        //NSLog("postData: \(postString)")
        request.httpBody = postString.data(using: String.Encoding.utf8);
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        webView.load(request)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        
    }
}

