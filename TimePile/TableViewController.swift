//
//  ViewController.swift
//  test
//
//  Created by Lavanya S Patil on 9/11/17.
//  Copyright © 2017 Steerminds. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UITextFieldDelegate {
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    var didEnterForeGround = true
    
    override func viewDidLoad() {
        let date = Date()
        let dateFormatted = DateFormatter()  //"0000-00-00" "2017-01-12"
        dateFormatted.dateFormat = "yyyy-mm-dd"
        let currentFormattedDate = dateFormatted.string(from: date)
        print(currentFormattedDate)
        let passToken = UserDefaults.standard.object(forKey: "_Token")
        let expiryDate = (UserDefaults.standard.object(forKey: "_UseByDate"))
        if (passToken != nil){
            if ((expiryDate as AnyObject).compare(currentFormattedDate) == .orderedAscending)
            {
                DispatchQueue.main.async {
                    if let url = URL(string: "https://www.timepile.com/LoginMobile.aspx?token=\(String(describing: passToken!))") {
                        print(url)
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            else{
                
                return
            }
        }

        

        super.viewDidLoad()
        passwordText.delegate = self
        userNameText.delegate = self
       
      }
    
    func CheckValidity(){
        
        let date = Date()
        let dateFormatted = DateFormatter()  //"0000-00-00" "2017-01-12"
        dateFormatted.dateFormat = "yyyy-mm-dd"
        let currentFormattedDate = dateFormatted.string(from: date)
        print(currentFormattedDate)
        let passToken = UserDefaults.standard.object(forKey: "_Token")
        let expiryDate = (UserDefaults.standard.object(forKey: "_UseByDate"))
        if (passToken != nil){
            if ((expiryDate as AnyObject).compare(currentFormattedDate) == .orderedAscending)
            {
                    DispatchQueue.main.async {
                    if let url = URL(string: "https://www.timepile.com/LoginMobile.aspx?token=\(String(describing: passToken!))") {
                        print(url)
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            else{
                
                return
            }
        }
    }

    
    @IBAction func loginButton(_ sender: UIButton) {
        if (userNameText.text != "" && passwordText.text != ""){
            
        let dict = ["Username": userNameText.text!, "Password": passwordText.text!,
                        "DeviceDescription":"iOS",
                        "AppVersion":"1.0",
                        "CurrentDate":Date().timeIntervalSince1970 ] as [String : Any]
            
        guard let url = URL(string: "https://www.timepile.com/api/Authentication/Authenticate/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: dict, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print(response)
            }else{
                DispatchQueue.main.async {
                self.alert(message: "Something went wrong RETRY")
                }
            }
                
            if let data = data{
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    print(json)
                    let token = json["Token"] as! String
                    let expiry = json["UseByDate"] as! String
                    let userName = json["Username"] as! String
                        
                    UserDefaults.standard.removeObject(forKey: "_Username")
                    UserDefaults.standard.removeObject(forKey: "_Token")
                    UserDefaults.standard.removeObject(forKey: "_UseByDate")
                        
                    UserDefaults.standard.set(token, forKey: "_Token")
                    UserDefaults.standard.set(expiry, forKey: "_UseByDate")
                    UserDefaults.standard.set(userName, forKey: "_Username")
                    UserDefaults.standard.synchronize()
                    if let url = URL(string: "https://www.timepile.com/LoginMobile.aspx?token=\(String(describing: token))") {
                    print(url)
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                        
                }catch{
                    DispatchQueue.main.async {
                    self.userNameText.text = ""
                    self.passwordText.text = ""
                    self.alert(message: "invalid credentials")
                            
                }
            }
        }
    }
            .resume()
    }else{
        alert(message: "Enter Credentials")
    }
}
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        if let url = URL(string: "https://www.timepile.com/forgottenpassword.aspx") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }    
    }
    
    @IBAction func profileRegisterButton(_ sender: UIButton) {
        if let url = URL(string: "https://www.timepile.com/RegisterProfile.aspx") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

