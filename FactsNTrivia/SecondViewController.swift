//
//  SecondViewController.swift
//  FactsNTrivia
//
//  Created by Arjun Mehndiratta on 18/10/17.
//  Copyright © 2017 Arjun Mehndiratta. All rights reserved.
//

import UIKit


let pickerCategories: [String] = [TRIVIA, MATH, DATE, YEAR]
let placeholderMessages = ["Enter any Number" , "Enter any Number" , "Enter any Date in format MM/DD", "Enter any Year"]

class SecondViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var categoryPicker: UIPickerView!
    @IBOutlet var submitButton: UIButton!
    

    var currentCategory: String = ""
    var fact: String = "No Fact found"
    var textFieldValue: String = ""
    var activityIndicatorSecond = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //call methid to initiate values
        self.initiateValues()
        //notification for modal view dismissed
      // NotificationCenter.default.addObserver(self, selector: #selector(SecondViewController.setInitialValues), name:NSNotification.Name(rawValue: "InitialValues"), object: nil)
        
       // NotificationCenter.default.addObserver(self, selector: #selector(self.setInitialValues), name: NSNotification.Name(rawValue: "InitialValues"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //notification function
 /*   @objc func setInitialValues()
    {
        self.initiateValues()
    }*/
    
    func initiateValues()
    {

        //delegate and datasource for picker view
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        //by default set the 0th position that is trivia
        self.categoryPicker.selectRow(0, inComponent: 0, animated: false)
        self.numberTextField.placeholder = placeholderMessages[0]
        self.currentCategory = pickerCategories[0]
        
        //to allow only numerics
        numberTextField.delegate = self
        submitButton.isEnabled = false
        numberTextField.keyboardType =  UIKeyboardType.numbersAndPunctuation
        self.numberTextField.text = ""
      
    }
    //MARK: - picker view
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // selectedRow = row;
       // txtPickerTextField.text = pickerArray[row]
       // self.view.endEditing(false)
        //  print(placeholderMessages)
        self.numberTextField.text=""
        self.numberTextField.placeholder = placeholderMessages[row]
        self.currentCategory = pickerCategories[row]
       // print("in picker view "+self.currentCategory)
    }

    //MARK: - textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters.isSuperset(of: characterSet)
        {
            if(self.currentCategory == DATE)
            {
                 if (textField.text?.characters.count == 2)
                 {
                    if !(string == "") {
                        // append the text
                        numberTextField?.text = (numberTextField?.text)! + "/"
                    }
                }
                    if(textField.text!.characters.count > 4)
                    {
                        return false
                    }
                    else
                    {
                        if(textField.text!.characters.count == 4)
                        {
                            submitButton.isEnabled = true
                        }
                        return true
                    }
            }
        }
        else
        {
            submitButton.isEnabled = false
            return false
        }
        submitButton.isEnabled = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
                return true;
    }
    
    //MARK: - submit button
    @IBAction func submitButtonTapped(_ sender: Any)
    {
        if(numberTextField.text!.isEmpty)
        {
            // create the alert
            let alert = UIAlertController(title: "No Input", message: "Please Enter a number in Text Field.", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            submitButton.isEnabled = false;
        }
        else
        {
        numberTextField.resignFirstResponder()
        textFieldValue = self.numberTextField.text!
        //print(self.currentCategory)
       // var value:Int = numberTextField.text as? Int
        if let value = numberTextField.text
        {
            switch self.currentCategory
            {
            case TRIVIA:
               // print("in trivia \(value)")
                callAPI(category: TRIVIA, numValue: value){ responseBack in
                    
                    if responseBack["found"] as? Bool == true
                    {
                        self.fact = responseBack["text"] as! String
                    }
                    else
                    {
                        self.fact = "No fact Found! Try another number"
                    }
            
                    // do something with the returned value
                    DispatchQueue.main.async
                        {
                        // update UI
                        self.activityIndicatorSecond.stopAnimating()
                        self.performSegue(withIdentifier: "random", sender: (Any?).self)
                        }
                }
                
            case MATH:
                //print("in math \(value)")
                
                callAPI(category: TRIVIA, numValue: value){ responseBack in
                    
                    if responseBack["found"] as? Bool == true
                    {
                        self.fact = responseBack["text"] as! String
                    }
                    else
                    {
                        self.fact = "No fact Found! Try another number"
                    }
                    DispatchQueue.main.async
                        {
                            // update UI
                            self.activityIndicatorSecond.stopAnimating()
                            self.performSegue(withIdentifier: "random", sender: (Any?).self)
                        }
                    }
                
            case DATE:
               //print("value count \(value.count)")
                if(value.count == 5)
                {
                callAPI(category: DATE, numValue: value){ responseBack in
                    
                    if responseBack["found"] as? Bool == true
                    {
                        self.fact = responseBack["text"] as! String
                    }
                    else
                    {
                        self.fact = "No fact Found! Try another date"
                    }
                    
                    DispatchQueue.main.async
                        {
                            // update UI
                            self.activityIndicatorSecond.stopAnimating()
                            self.performSegue(withIdentifier: "random", sender: (Any?).self)
                    }
                }
                }
                else
                {
                    let alert = UIAlertController(title: "Incorrect Date", message: "Please Enter date in MM/DD format.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                
            case YEAR:
                //print("in year \(value)")
                callAPI(category: YEAR, numValue: value){ responseBack in
                    
                    if responseBack["found"] as? Bool == true
                    {
                        self.fact = responseBack["text"] as! String
                    }
                    else
                    {
                        self.fact = "No fact Found! Try another year"
                    }
                    
                    DispatchQueue.main.async
                        {
                            // update UI
                            self.activityIndicatorSecond.stopAnimating()
                            self.performSegue(withIdentifier: "random", sender: (Any?).self)
                    }
                }
                
            default:
             //   print("wrong entry \(value)")
                let alert = UIAlertController(title: "Wrong input value", message: "Please enter a valid value.", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        self.numberTextField.text = ""
        }//else ends
    }
    
    //MARK: - Segue overridden
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "random"{
            let newController = segue.destination as! RandomFactsViewController
            //print(self.fact)
            
            newController.factRandom = self.fact
            newController.category = self.currentCategory
            newController.number = textFieldValue
            
        }
    }

    
    //MARK:  - API call
    func callAPI(category : String, numValue : String, completion: @escaping (AnyObject)->() )
    {
        if Reachability.isConnectedToNetwork()
        {
           // print("Internet Connection Available!")
            
        //activity indicator
            self.activityIndicatorSecond = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            self.activityIndicatorSecond.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            self.activityIndicatorSecond.center = CGPoint(x: self.view.bounds.midX , y: self.view.bounds.midY);
            self.activityIndicatorSecond.hidesWhenStopped = true
            
            view.addSubview(self.activityIndicatorSecond)
        //set up URL request
        let tempUrl: String = "http://numbersapi.com/"+numValue+"/"+category+"?json"
        guard let finalURL = URL(string: tempUrl) else {
           // print("Error: Cannot create URL")
            //responseBack="Error: Cannot create URL"
            let alert = UIAlertController(title: "Cannot Create URL", message: "Please check the entered value.", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let urlRequest = URLRequest(url: finalURL)
        //set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //let session = URLSession.shared
        
        self.activityIndicatorSecond.startAnimating()
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // check for any errors
            guard error == nil else {
               // print("error calling GET on numbersapi")
                //print(error!)
                let alert = UIAlertController(title: "Error", message: error as? String, preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                //print("Error: did not receive data")
                let alert = UIAlertController(title: "No Data received", message: "Please check numbersapi website for the data.", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            do {
                guard let parsedData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                   // print("error trying to convert data to JSON try")
                    let alert = UIAlertController(title: "Problem in Data retreiving", message: "JSON format not available.", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                // ...
                
                completion(parsedData as AnyObject)

            } catch  {
                let alert = UIAlertController(title: "Problem in Data retreiving", message: "JSON format not available.", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        })
        
        task.resume()
        }
        else
        {
            print("Internet Connection not Available!")
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}//class ends

