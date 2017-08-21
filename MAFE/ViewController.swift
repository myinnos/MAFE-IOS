//
//  ViewController.swift
//  MAFE
//
//  Created by MyInnos on 13/07/17.
//  Copyright © 2017 MyInnos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var textFileld: UITextField!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    
    // declaration for preferences
    let preferences = UserDefaults.standard
    let lastEnteredNameValueKey = "lastEnteredNameValue"
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        //toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.font = toastLabel.font.withSize(11)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 6.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @IBAction func subtractionFunctionButtonPressed(sender: UIButton) {
        //Subtracting Function
        
        let decimalCharacters = CharacterSet.decimalDigits
        let spaceCharacters = CharacterSet.whitespaces
        let specialCharacters = CharacterSet.symbols
        
        let decimalRange = textFileld.text?.rangeOfCharacter(from: decimalCharacters)
        let whiteSpaceRange = textFileld.text?.rangeOfCharacter(from: spaceCharacters)
        let specialCharRange = textFileld.text?.rangeOfCharacter(from: specialCharacters)
        
        /*let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
         if lable.text?.rangeOfCharacter(from: characterset.inverted) != nil {
         print("string contains special characters")
         }*/
        
        if decimalRange != nil {
            lable.text = "Macha! Remove numbers and Try madi!"
        } else if whiteSpaceRange != nil {
            lable.text = "Macha! Remove white space and Try madi!"
        }else if specialCharRange != nil {
            lable.text = "Macha! Remove special characters and Try madi!"
        }else if textFileld.text == "" {
            lable.text = "Orey Pakodi! Edanna Enter Chay ra!"
            //titleLable.text = "MA/FE"
        }else{
            lable.text = "checking ... swalpa wait madu!"
            //titleLable.text = textFileld.text
            //calling the function that will fetch the json
            getJsonFromUrl();
        }
    }
    @IBAction func buttonAction(_ sender: Any) {
        subtractionFunctionButtonPressed(sender: button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.backgroundColor = UIColor.red.cgColor
        button.layer.borderColor = UIColor.black.cgColor
        
        lable.lineBreakMode = NSLineBreakMode.byWordWrapping
        lable.numberOfLines = 3
        
        if preferences.object(forKey: lastEnteredNameValueKey) == nil {
            //  Doesn't exist
        } else {
            showToast(message: "We found last used value!")
            let lastUsedValue = preferences.value(forKey: lastEnteredNameValueKey)
            textFileld.text = lastUsedValue as? String
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        let URL_GENDER = "https://api.namsor.com/onomastics/api/json/gender/"+self.textFileld.text!+"/a"
        let url = NSURL(string: URL_GENDER)
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url! as URL), completionHandler: {(data, response, error) -> Void in
            
            if error != nil {
                self.lable.text = "Something went wrong!"
            } else {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    //print(parsedData)
                    //self.showToast(message: parsedData["gender"] as! String)
                    DispatchQueue.main.async {
                        
                        // saving entered value in  prefrences
                        self.preferences.setValue(self.textFileld.text, forKey:self.lastEnteredNameValueKey)
                        self.lable.text = "success!"
                        self.titleLable.text = parsedData["gender"] as? String
                        //self.titleLable.font = self.titleLable.font.withSize(40)
                        self.titleLable.text = self.titleLable.text?.uppercased()
                        
                        //self.subTitleLable.text = "under scale value " + (parsedData["scale"] as! String)
                        
                    }
                    
                    
                    //print(parsedData["gender"] as! String)
                    
                    
                    /*for (key, value) in parsedData {
                     print("\(key) - \(value) ")
                     
                     if key == "gender"{
                     
                     // saving entered value in  prefrences
                     self.preferences.setValue(self.textFileld.text, forKey:self.lastEnteredNameValueKey)
                     
                     self.lable.text = "success!"
                     self.titleLable.text = "\(value)"
                     //self.titleLable.font = self.titleLable.font.withSize(40)
                     self.titleLable.text = self.titleLable.text?.uppercased()
                     }
                     
                     
                     if key == "scale"{
                     self.subTitleLable.text = "under scale value " + "\(value)"
                     }
                     
                     
                     }*/
                    
                } catch let error as NSError {
                    print(error)
                }
                
            }
            
        }).resume()
    }
    
}

