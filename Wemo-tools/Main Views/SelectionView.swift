//
//  SelectionView.swift
//  Wemo-tools
//
//  Created by Ian White on 1/11/18.
//  Copyright © 2018 Ian White. All rights reserved.
//

//
//  ViewController.swift
//  Wemo-tools
//
//  Created by Ian White on 1/11/18.
//  Copyright © 2018 Atomic Creations. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView! //Creating our table view
    var passedArray = Array<Any>() //Passed Data coming from the MainVC.swift file of the IP Addresses that have the open wemo ports.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") //Registereing UITableView Cell
        
        //print(passedArray)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.passedArray.count; //Get Passed Data in the Array Count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = self.passedArray[indexPath.row] as? String //Setting the Cell Label text to data from the passedArray
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         //On Selecting the TableView Row Redirect to the SecondViewController. Here you will be shown the data for your selected IP Address
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SecondVC") as! SecondViewController
        vc.passedIP = (self.passedArray[indexPath.row] as? String)! //Passing Selected IP Address Data
        navigationController?.pushViewController(vc,animated: true)
    }
    
    
    
}

