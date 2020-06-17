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
            if username.contains(" ") || username.count == 0 || username.contains("@") {
                AlertManager.shared.askNewUserToProvideName(with: "please provide new username which is not empty, without @ and empty spaces", in: controller)
                return
            }
            FirebaseManager.shared.checkWhetherUserExists(with: username) { (doesExist) in
                if doesExist {
                    AlertManager.shared.askNewUserToProvideName(with: "whoops username is not unique, please provide new one", in: controller)
                } else {
                    let userEmail = FirebaseManager.shared.getCurrentUser()
                    Constants.currentUserEmail = userEmail
                    Constants.currentUserName = username
                    FirebaseManager.shared.addUserToList(email: userEmail, username: username)
                    FirebaseManager.shared.setCurrentUserInfo {
                        Constants.currentUserProfilePicture = Constants.externalRegisterProfilePicture!
                        FirebaseManager.shared.saveProfilePictureToFirebase(as: (Constants.currentUserProfilePicture?.jpegData(compressionQuality: 0.2))!)
                        controller.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
        }))
        controller.present(alert, animated: false)
    }
    
    func requiedAuthorisationAlert(in controller: WallViewController) {
        let alert = UIAlertController(title: "Please Log In", message: "to see recipe details authorisation is required", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Log In", style: .cancel, handler: { (action) in
            controller.performSegue(withIdentifier: Constants.Segues.wallLoginSegue, sender: self)
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

//MARK: - register alerts
extension AlertManager {
    func userHasBeenRegisteredAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "Cool!", message: "You have been successfully registered. To use your account and join our community you need to only check your email and finish authentication using link that we sent. May the food be with you!", preferredStyle: .alert)
        let action = UIAlertAction(title: "got it", style: .cancel) { (action) in
            controller.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func wrongUsernameAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "wrong username", message: "please provide new username which is not empty, without @ and empty spaces", preferredStyle: .alert)
        let action = UIAlertAction(title: "okay", style: .cancel, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func notUniqueUsernameAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "username is not unique", message: "please provide new username which is not unique", preferredStyle: .alert)
        let action = UIAlertAction(title: "okay", style: .cancel, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func notUniqueEmailAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "whoops", message: "It seems that account with this email already exists. If this email belongs to you please login, otherwise try with different credentials", preferredStyle: .alert)
        let tryAgain = UIAlertAction(title: "try again", style: .cancel, handler: nil)
        let signIn = UIAlertAction(title: "sign in", style: .default) { (action) in
            controller.navigationController?.popViewController(animated: true)
        }
        alert.addAction(tryAgain)
        alert.addAction(signIn)
        controller.present(alert, animated: true)
    }
    
    func verifyEmailAlert(in controller: UIViewController, completion: @escaping ()-> ()) {
        let alert = UIAlertController(title: "please verify your email", message: "check your email and find authentication link, if you haven't received anything please press help", preferredStyle: .alert)
        let action = UIAlertAction(title: "okay", style: .cancel) { action in
            completion()
        }
        let helpAction = UIAlertAction(title: "help", style: .default) { action in
            completion()
        }
        alert.addAction(action)
        alert.addAction(helpAction)
        controller.present(alert, animated: true)
    }
}

//MARK: - change password/username alerts

extension AlertManager {
     func passwordChangedAlert(in controller: UIViewController) {
           let alert = UIAlertController(title: "Great!", message: "Your password has been changed", preferredStyle: .alert)
           let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
           alert.addAction(action)
           controller.present(alert, animated: true)
    }
    
    func usernameChangedAlert(in controller: UIViewController) {
           let alert = UIAlertController(title: "Great!", message: "Your username has been changed", preferredStyle: .alert)
           let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
           alert.addAction(action)
           controller.present(alert, animated: true)
       }
    
}
