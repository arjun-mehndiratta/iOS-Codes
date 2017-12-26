//
//  RandomFactsViewController.swift
//  FactsNTrivia
//
//  Created by Arjun Mehndiratta on 21/10/17.
//  Copyright © 2017 Arjun Mehndiratta. All rights reserved.
//

import UIKit

class RandomFactsViewController: UIViewController {
    var factRandom: String = ""
    var category: String = ""
    var number: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (!self.factRandom.isEmpty) {
            self.randomFactLabel.text = factRandom
        }
        if(!self.category.isEmpty){
            switch self.category
            {
            case TRIVIA:
                self.labelHeading.text = "Amazing \(self.category) fact for the number \(self.number) "
                
            case MATH:
                self.labelHeading.text = "Amazing \(self.category) fact for the number \(self.number) "
                
            case DATE:
                self.labelHeading.text = "Amazing \(self.category) fact for the date \(self.number) "
                
            case YEAR:
                self.labelHeading.text = "Amazing \(self.category) fact for the year \(self.number) "
                
            default:
                let alert = UIAlertController(title: "Wrong category", message: "Please check the input category.", preferredStyle: UIAlertControllerStyle.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
                //print("wrong entry \(self.number)")
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet var labelHeading: UILabel!
    @IBOutlet var randomFactLabel: UILabel!
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        // post a notification
      //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InitialValues"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
