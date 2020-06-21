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
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: {
            action in
            guard let username = alert.textFields![0].text else { return }
            if username.contains(" ") || username.count == 0 || username.contains("@") {
                AlertManager.shared.askNewUserToProvideName(with: "Please provide new username which is not empty, without @ and empty spaces", in: controller)
                action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
                return
            }
            FirebaseManager.shared.checkWhetherUserExists(with: username) { (doesExist) in
                if doesExist {
                    AlertManager.shared.askNewUserToProvideName(with: "Whoops username is not unique, please provide new one", in: controller)
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
        let alert = UIAlertController(title: "Please Log In", message: "To see recipe details authorisation is required", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Log In", style: .cancel, handler: { (action) in
            controller.performSegue(withIdentifier: Constants.Segues.wallLoginSegue, sender: self)
            action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
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
        let alert = UIAlertController(title: nil, message: "Whoops something went wrong", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Get back", style: .cancel, handler: { (action) in
            controller.navigationController?.popToRootViewController(animated: false)
            action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
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
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
}

//MARK: - register alerts
extension AlertManager {
    func userHasBeenRegisteredAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "Cool!", message: "You have been successfully registered. To use your account and join our community you need to only check your email and finish authentication using link that we sent. May the food be with you!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it", style: .cancel) { (action) in
            controller.navigationController?.popViewController(animated: true)
        }
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func wrongUsernameAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "Wrong username", message: "Please provide new username which is not empty, without @ and empty spaces", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func notUniqueUsernameAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "Username is not unique", message: "Please provide new username which is unique", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func notUniqueEmailAlertWithSingInOption(in controller: UIViewController) {
        let alert = UIAlertController(title: "Whoops", message: "It seems that account with this email already exists. If this email belongs to you please login, otherwise try with different credentials", preferredStyle: .alert)
        let tryAgain = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
        let signIn = UIAlertAction(title: "Sign in", style: .default) { (action) in
            controller.navigationController?.popViewController(animated: true)
        }
        tryAgain.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        signIn.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(tryAgain)
        alert.addAction(signIn)
        controller.present(alert, animated: true)
    }
    
    func actionSuccessfullyCompleted(with title: String, in controller: UIViewController) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "okay", style: .cancel, handler: nil)
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    
    func notUniqueEmailAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "Whoops", message: "It seems that account with this email already exists. Please find another username", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func verifyEmailAlert(in controller: UIViewController, completion: @escaping ()-> ()) {
        let alert = UIAlertController(title: "Please verify your email", message: "Check your email and find authentication link, if you haven't received anything please press help", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { action in
            completion()
        }
        let helpAction = UIAlertAction(title: "Help", style: .default) { action in
            completion()
        }
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        helpAction.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        alert.addAction(helpAction)
        controller.present(alert, animated: true)
    }
}


//MARK: - remove account alerts
extension AlertManager {
    func confirmAccountRemovalAlert(in controller: UIViewController, completion: @escaping (Bool)-> ()) {
        let alert = UIAlertController(title: "Are you sure that you want to remove your account?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            completion(true)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { action in
            completion(false)
        }
        yesAction.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        noAction.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(noAction)
        alert.addAction(yesAction)
        controller.present(alert, animated: true)
    }
    
    func accountRemovedAlert(in controller: UIViewController, completion: @escaping ()-> ()) {
        let alert = UIAlertController(title: "Account has been removed", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
            completion()
        }
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
}

//MARK: - change password/username alerts
extension AlertManager {
    func passwordChangedAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "Great!", message: "Your password has been changed", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func usernameChangedAlert(in controller: UIViewController) {
        let alert = UIAlertController(title: "Great!", message: "Your username has been changed", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
    
    func askUserToChangeUsername(with title: String, in controller: UIViewController) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "new username"
        }
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: {
            action in
            guard let username = alert.textFields![0].text else { return }
            if username.contains(" ") || username.count == 0 || username.contains("@") {
                AlertManager.shared.askUserToChangeUsername(with: "Please provide new username which is not empty, without @ and empty spaces", in: controller)
                action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
                return
            }
            FirebaseManager.shared.checkWhetherUserExists(with: username) { (doesExist) in
                if doesExist {
                    AlertManager.shared.askUserToChangeUsername(with: "Whoops username is not unique, please provide new one", in: controller)
                } else {
                    FirebaseManager.shared.changeUsername(to: username) { (success) in
                        if success {
                            AlertManager.shared.usernameChangedAlert(in: controller)
                        }
                    }
                }
            }
        }))
        controller.present(alert, animated: false)
    }
    
    func askUserToChangePassword(with title: String, in controller: UIViewController) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "new password"
        }
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: {
            action in
            guard let password = alert.textFields![0].text else { return }
            if password.isEmpty {
                AlertManager.shared.askUserToChangePassword(with: "Please use at least one character in your new password", in: controller)
                action.setValue(Constants.Colors.deepGreen, forKey: "titleTextColor")
                return
            }
            /*FirebaseManager.shared.changePassword() { (success) in
                if success {
                    AlertManager.shared.passwordChangedAlert(in: controller)
                }
            }
             */
        }))
        controller.present(alert, animated: false)
    }
    
}

//MARK: - extensions

extension UIAlertController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.tintColor = Constants.Colors.deepGreen
    }
}

