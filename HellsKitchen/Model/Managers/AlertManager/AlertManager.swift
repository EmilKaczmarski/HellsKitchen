//
//  AlertManager.swift
//  HellsKitchen
//
//  Created by Apple on 24/05/2020.
//  Copyright © 2020 Emil. All rights reserved.
//

import UIKit
import SystemConfiguration

class AlertManager {
    static let shared = AlertManager()
    private init() { }
    
    func textInputAlert(with windowTitle: String, buttonTitle: String, for controller: UIViewController) {
        let alert = UIAlertController(title: windowTitle, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: {
            action in
            // Called when user taps outside
        }))
        controller.present(alert, animated: true)
    }
    
    func askNewUserToProvideName(with title: String, in controller: UIViewController) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "new username"
        }
        alert.addAction(UIAlertAction(title: "done", style: .cancel, handler: {
            action in
            guard let username = alert.textFields![0].text else { return }
            
            FirebaseManager.shared.checkWhetherUserExists(with: username) { (doesExist) in
                if doesExist {
                    AlertManager.shared.askNewUserToProvideName(with: "whoops username is not unique, please provide new one", in: controller)
                } else {
                    let userEmail = FirebaseManager.shared.getCurrentUser()
                    Constants.currentUserEmail = userEmail
                    Constants.currentUserName = username
                    FirebaseManager.shared.addUserToList(email: userEmail, username: username)
                    FirebaseManager.shared.setCurrentUsername {
                        controller.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }))
        controller.present(alert, animated: false)
    }
    
    func requiedAuthorisationAlert(in controller: WallViewController) {
        let alert = UIAlertController(title: "Please Log In", message: "Don't have an account? Register Now!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Log In", style: .cancel, handler: { (action) in
            controller.performSegue(withIdentifier: Constants.Segues.loginSegue, sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
            controller.performSegue(withIdentifier: Constants.Segues.registerSegue, sender: self)
        }))
        controller.present(alert, animated: true)
    }
    
    func sheduleTimerFor(alert: UIAlertController, in controller: UIViewController, completion: @escaping (Bool)-> Void) {
        Timer.scheduledTimer(withTimeInterval: 7, repeats:false, block: {_ in
            if controller.presentedViewController == alert {
                controller.dismiss(animated: true, completion: nil)
                AlertManager.shared.errorAlert(in: controller)
                completion(false)
            } else {
                completion(false)
            }
        })
    }
    
    func loadingAlert(in controller: UIViewController, completion: @escaping ()-> Void)-> UIAlertController {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true) {
            completion() 
        }
        return alert
    }
    
    func errorAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: "whoops something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "get back", style: .cancel, handler: { (action) in
            controller.navigationController?.popToRootViewController(animated: false)
        }))
        controller.present(alert, animated: true)
    }
    
  
    func isInternetAvailable(completion: @escaping (Bool) -> ()){
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachibility = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachibility!, &flags) {
            completion(false)
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        completion(isReachable && !needsConnection)
    }
    
    func sendMessageAlert(in controller: UIViewController) {
            let alert = UIAlertController(title: "Alert", message: "No internet connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            controller.present(alert, animated: true)
    }
}
