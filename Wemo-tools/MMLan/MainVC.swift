//
//  MainVC.swift
//  MMLanScanSwiftDemo
//
//  Created by Michalis Mavris on 06/11/2016.
//  Modified by Ian White on 01/11/2017
//
//  Copyright © 2016 Miksoft. All rights reserved.
//

import UIKit
import Foundation
import SwiftSocket
import MBProgressHUD

class MainVC: UIViewController, MainPresenterDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tableVTopContraint: NSLayoutConstraint!
    @IBOutlet weak var scanButton: UIBarButtonItem!
    
    private var myContext = 0
    var presenter: MainPresenter!
    var ipArray = Array<Any>() //IPData Array
    var successArray = Array<Any>() //IP's with IP's mathcing Wemo configuration. These IP's will be carried over to the SelectionViewController
    
    //MARK: - On Load Methods
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Init presenter. Presenter is responsible for providing the business logic of the MainVC (MVVM)
        self.presenter = MainPresenter(delegate:self)
        
        //Add observers to monitor specific values on presenter. On change of those values MainVC UI will be updated
        self.addObserversForKVO()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Setting the title of the navigation bar with the SSID of the WiFi
        self.navigationBarTitle.title = self.presenter.ssidName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - KVO Observers
    func addObserversForKVO ()->Void {
        
        self.presenter.addObserver(self, forKeyPath: "connectedDevices", options: .new, context:&myContext)
        self.presenter.addObserver(self, forKeyPath: "progressValue", options: .new, context:&myContext)
        self.presenter.addObserver(self, forKeyPath: "isScanRunning", options: .new, context:&myContext)
    }
    
    func removeObserversForKVO ()->Void {
        
        self.presenter.removeObserver(self, forKeyPath: "connectedDevices")
        self.presenter.removeObserver(self, forKeyPath: "progressValue")
        self.presenter.removeObserver(self, forKeyPath: "isScanRunning")
    }
    
    //MARK: - Button Action
    @IBAction func refresh(_ sender: Any) {
        //Shows the progress bar and start the scan. It's also setting the SSID name of the WiFi as navigation bar title
        self.showProgressBar()
        self.navigationBarTitle.title = self.presenter.ssidName()
        self.presenter.scanButtonClicked()
    }
    
    //MARK: - Show/Hide Progress Bar
    func showProgressBar()->Void {
        
        self.progressView.progress = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.tableVTopContraint.constant = 40
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    func hideProgressBar()->Void {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.tableVTopContraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    //MARK: - Presenter Delegates
    //The delegates methods from Presenters.These methods help the MainPresenter to notify the MainVC for any kind of changes
    
    
    func mainPresenterIPSearchFinished() {
        
        self.hideProgressBar()
        self.tableV.reloadData()
        
        //MBProgressHUD Loading Notification when data is being sorted through to see if Wemo IP Addresses are open
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading WeMo Devices..."
        
        //Wait 0.1 Seconds so that ProgressBar has time to dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.dataCycle()
        })
        
        
    }
    
    func mainPresenterIPSearchCancelled() {
        
        self.hideProgressBar()
        self.tableV.reloadData()
    }
    
    func mainPresenterIPSearchFailed() {
        
        self.hideProgressBar()
        self.showAlert(title: "Failed to scan", message: "Please make sure that you are connected to a WiFi before starting LAN Scan")
    }
    
    //MARK: - Alert Controller
    func showAlert(title:String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in}
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - UITableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.presenter.connectedDevices!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let device = self.presenter.connectedDevices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        
        cell.ipLabel.text = device.ipAddress //Cell Label
        
        ipArray.append(cell.ipLabel.text as! String) //Adding Data to the ipArray that will be sorted through with SwiftSocket
        
        return cell
        
    }
    
    func uniqueElementsFrom(array: [String]) -> [String] { /* Function to remove duplicates of data from the Array */
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        return result
    }
    
    //MARK: - KVO
    //This is the KVO function that handles changes on MainPresenter
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (context == &myContext) {
            
            switch keyPath! {
            case "connectedDevices":
                self.tableV.reloadData() //Reloading Table Data
            case "progressValue":
                self.progressView.progress = self.presenter.progressValue //Updating Progressview
            case "isScanRunning":
                let isScanRunning = change?[.newKey] as! BooleanLiteralType
                self.scanButton.image = isScanRunning ? #imageLiteral(resourceName: "stopBarButton") : #imageLiteral(resourceName: "refreshBarButton")
            default:
                print("Not valid key for observing")
            }
            
        }
    }
    
    //MARK: - Deinit
    deinit {
        
        self.removeObserversForKVO()
    }
    
    
    func dataCycle() {
        
        let uniqueStrings = uniqueElementsFrom(array:ipArray as! [String]) //Get Total amount of IP Addresses from ipArray
        print("Total Devices: \(self.presenter.connectedDevices.count)") //Total Devices from Scanner
        print("Total Devices Found: \(uniqueStrings.count)") //Total Unique devices found
        
        for var i in (0..<uniqueStrings.count).reversed()
        {
            var ipAddress = uniqueStrings[i]
            
            /* Scanning IP Addresses with the SwiftSocket library to see which ports are open and if we can find a wemo device with the default ports open */
            
            let client = TCPClient(address: ipAddress, port: 49152)
            switch client.connect(timeout: 1) {
            case .success:
                self.successArray.append(ipAddress) //Successful Port is Open
                print(successArray) //Successful Port is Open Print
            case .failure(let error):
                print("No Data Found" + ipAddress + " - 49152")
            }
            let client2 = TCPClient(address: ipAddress, port: 49153)
            switch client2.connect(timeout: 1) {
            case .success:
                self.successArray.append(ipAddress) //Successful Port is Open
                print(successArray) //Successful Port is Open Print
            case .failure(let error):
               print("No Data Found" + ipAddress + " - 49153")
            }
            let client3 = TCPClient(address: ipAddress, port: 49154)
            switch client3.connect(timeout: 1) {
            case .success:
                self.successArray.append(ipAddress) //Successful Port is Open
                print(successArray) //Successful Port is Open Print
            case .failure(let error):
                print("No Data Found" + ipAddress + " - 49154")
            }
        }
        
        if (successArray.isEmpty == false) { //If Data is found filter through data and remove Duplicates if any
            
            let uniqueArray = uniqueElementsFrom(array:successArray as! [String])
            
            MBProgressHUD.hideAllHUDs(for: view, animated: true) //Stop MBProgressHUD
            
            /* Redirect to SelectionView Controller */
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SelectedVC") as! SelectionViewController
            vc.passedArray = uniqueArray //Pass uniqueArray to SelectionViewController with data for Table
            navigationController?.pushViewController(vc, animated: true)

        } else { //If Else
            
            /* Show Alert no devices found. Kill MBProgressHUD */
            
            self.showAlert(title: "No Wemo Devices Found", message: "Try and scan your wifi network again.")
            MBProgressHUD.hideAllHUDs(for: view, animated: true)
            
        }
    }
}
