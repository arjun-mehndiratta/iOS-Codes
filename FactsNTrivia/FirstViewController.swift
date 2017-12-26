//
//  FirstViewController.swift
//  FactsNTrivia
//
//  Created by Arjun Mehndiratta on 18/10/17.
//  Copyright © 2017 Arjun Mehndiratta. All rights reserved.
//

import UIKit
let TRIVIA = "trivia"
let MATH = "math"
let DATE = "date"
let YEAR = "year"

class FirstViewController: UIViewController
{
    
    var fact: String = "No Fact found"
    var categoryFact: String = ""
    var numberReturned: String = " "
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK: -Button Tapped
    @IBAction func triviaTapped(_ sender: UIButton)
    {
        categoryFact = TRIVIA
        callAPI(category: TRIVIA){ responseBack in
            if let returned  = responseBack["number"] as? NSNumber {
                self.numberReturned = returned.stringValue
            }
           // self.numberReturned = String(describing: responseBack["number"])
            //print(self.numberReturned)
            if responseBack["found"] as? Bool == true
            {
                self.fact = responseBack["text"] as! String
            }
            else
            {
                self.fact = " No fact Found"
            }
            // do something with the returned value
            DispatchQueue.main.async {
                // update UI
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "random", sender: (Any?).self)
            }
        }
    
    }
    
    @IBAction func mathTapped(_ sender: Any)
    {
        categoryFact = MATH
        callAPI(category: MATH){ responseBack in
            if let returned  = responseBack["number"] as? NSNumber {
                self.numberReturned = returned.stringValue
            }
            if responseBack["found"] as? Bool == true
            {
                self.fact = responseBack["text"] as! String
            }
            else
            {
                self.fact = " No fact Found"
            }
            // do something with the returned value
            DispatchQueue.main.async {
                // update UI
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "random", sender: (Any?).self)
            }
        }
    }
    
    
    @IBAction func dateTapped(_ sender: Any)
    {
        categoryFact = DATE
        callAPI(category: DATE){ responseBack in
            if let returned  = responseBack["year"] as? NSNumber {
                self.numberReturned = returned.stringValue
            }
          //  self.fact=responseBack
            //print(self.fact)
            if responseBack["found"] as? Bool == true
            {
                self.fact = responseBack["text"] as! String
            }
            else
            {
                self.fact = " No fact Found"
            }
            // do something with the returned value
            DispatchQueue.main.async {
                // update UI
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "random", sender: (Any?).self)
            }
        }
    }
    
    
    @IBAction func yearTapped(_ sender: Any)
    {
        categoryFact = YEAR
        callAPI(category: YEAR){ responseBack in
            if let returned  = responseBack["number"] as? NSNumber {
                self.numberReturned = returned.stringValue
            }
            if responseBack["found"] as? Bool == true
            {
                self.fact = responseBack["text"] as! String
            }
            else
            {
                self.fact = " No fact Found!"
            }
            //print(self.fact)
            // do something with the returned value
            DispatchQueue.main.async {
                // update UI
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "random", sender: (Any?).self)
            }
        }
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
            newController.category = self.categoryFact
            newController.number = self.numberReturned
        }
    }



//MARK:  - API call
func callAPI(category : String, completion: @escaping (AnyObject)->() )
{
    if Reachability.isConnectedToNetwork()
    {
        //print("Internet Connection Available!")
   
    //var activityIndicator = UIActivityIndicatorView()
    self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    self.activityIndicator.center = CGPoint(x: self.view.bounds.midX , y: self.view.bounds.midY);
    self.activityIndicator.hidesWhenStopped = true
    
    view.addSubview(self.activityIndicator)
    //var responseBack:String = "No Fact"
    //set up URL request
    let tempUrl: String = "http://numbersapi.com/random/"+category+"?json"
    guard let finalURL = URL(string: tempUrl) else {
       // print("Error: Cannot create URL")
        let alert = UIAlertController(title: "Cannot create URL", message: "Check numbersapi website.", preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        return
       
    }
    
    let urlRequest = URLRequest(url: finalURL)
    //set up the session
    //let config = URLSessionConfiguration.default
    //let session = URLSession(configuration: config)
    let session = URLSession.shared
    
    self.activityIndicator.startAnimating()
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
                //print("error trying to convert data to JSON try")
                let alert = UIAlertController(title: "Problem in Data retreiving", message: "JSON format not available.", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
            // ...
            completion(parsedData as AnyObject)
            
           /* if parsedData["found"] as? Bool == true
            {
                responseBack = parsedData["text"] as! String
                //print("in function")
                //print(responseBack)
                completion(responseBack)
                
            }*/
        } catch  {
           // print("error trying to convert data to JSON catch")
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

} //class ends
