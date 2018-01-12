//
//  SecondViewController.swift
//  Wemo-tools
//
//  Created by Ian White on 1/11/18.
//  Copyright © 2018 Ian White. All rights reserved.
//

import UIKit
import Alamofire
import AlamoFuzi
import SwiftyXMLParser

class SecondViewController: UIViewController {
    
    @IBOutlet var deviceName: UILabel! //Device Name
    @IBOutlet var ipAddress: UILabel! //Device IP
    @IBOutlet var MACaddress: UILabel! //Device MAC
    @IBOutlet var signalStrength: UILabel! //Signal Strength
    @IBOutlet var serialNo: UILabel! //Signal Strength
    @IBOutlet var currentStatus: UISwitch! //Current Status
    @IBOutlet var currentStatusLabel: UILabel! //Current Status
    
    var passedIP = String() //IP Passed From Selection View
    var status = Int() //Variable representing On/Off Status
    var clicked = Int() //Variable representing if the user has clicked the UISwitch
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /* Functions called to Fetch Data from Wemo Device */
        
        getSignalStrength()
        getDeviceName()
        getMACAddr()
        getDeviceStatus()
        
        ipAddress.text? = "IP Address: " + passedIP
        
    }
    
    func getSignalStrength() {
        
        let url = "http://" + passedIP + ":49153/upnp/control/basicevent1"; //URL For Wemo Device to send Commands
        
        /* URL Request: Sending the data via request with Alamofire. HTTP Method is POST, Headers are specific for what action is being executed, and the body is the most important part of the data that is sent off. */
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.setValue("\"urn:Belkin:service:basicevent:1#GetSignalStrength\"", forHTTPHeaderField: "SOAPACTION")
        request.setValue("", forHTTPHeaderField: "Accept")
        
        let body =  "<?xml version='1.0' encoding='utf-8'?><s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><s:Body><u:GetSignalStrength xmlns:u='urn:Belkin:service:basicevent:1'><GetSignalStrength>0</GetSignalStrength></u:GetSignalStrength></s:Body></s:Envelope>"
        
        let data = (body.data(using: .utf8))! as Data
        
        request.httpBody = data
        
        /* Alamofire recieves the response and uses AlamoFuzi .responseXML to gather the XML reponse. The XML response is then converted to a UTF8Text String and then the data is parsed and the response data is extracted from the recieved XML with SwiftyXMLParser. */
        
        Alamofire.request(request).responseXML { (response) in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print(response)
                let xml = try! XML.parse(utf8Text)
                if let text = xml["s:Envelope", "s:Body", "u:GetSignalStrengthResponse", "SignalStrength"].text {
                    
                    /* After the data is extracted as text it is added to the UILabel and the the infomration is sent back to the ViewDidLoad when this function is called. */
                    
                    self.signalStrength.text? = "Signal Strength: " + text
                }
                
            }
            
        }
        
    }
    
    func getMACAddr() {
        
        let url = "http://" + passedIP + ":49153/upnp/control/basicevent1"; //URL For Wemo Device to send Commands
        
        /* URL Request: Sending the data via request with Alamofire. HTTP Method is POST, Headers are specific for what action is being executed, and the body is the most important part of the data that is sent off. */
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.setValue("\"urn:Belkin:service:basicevent:1#GetMacAddr\"", forHTTPHeaderField: "SOAPACTION")
        request.setValue("", forHTTPHeaderField: "Accept")
        
        let body =  "<?xml version='1.0' encoding='utf-8'?><s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><s:Body><u:GetMacAddr xmlns:u='urn:Belkin:service:basicevent:1'><GetMacAddr>0</GetMacAddr></u:GetMacAddr></s:Body></s:Envelope>"
        
        let data = (body.data(using: .utf8))! as Data
        
        request.httpBody = data
        
        /* Alamofire recieves the response and uses AlamoFuzi .responseXML to gather the XML reponse. The XML response is then converted to a UTF8Text String and then the data is parsed and the response data is extracted from the recieved XML with SwiftyXMLParser. */
        
        Alamofire.request(request).responseXML { (response) in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print(response)
                let xml = try! XML.parse(utf8Text)
                if let text = xml["s:Envelope", "s:Body", "u:GetMacAddrResponse", "MacAddr"].text {
                    
                    /* After the data is extracted as text it is added to the UILabel and the the infomration is sent back to the ViewDidLoad when this function is called. */
                    
                    self.MACaddress.text? = "MAC Address: " + text
                }
                
            }
        }
        
    }
    
    
    func getDeviceName() {
        
        let url = "http://" + passedIP + ":49153/upnp/control/basicevent1";  //URL For Wemo Device to send Commands
        
        /* URL Request: Sending the data via request with Alamofire. HTTP Method is POST, Headers are specific for what action is being executed, and the body is the most important part of the data that is sent off. */
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.setValue("\"urn:Belkin:service:basicevent:1#GetFriendlyName\"", forHTTPHeaderField: "SOAPACTION")
        request.setValue("", forHTTPHeaderField: "Accept")
        
        let body =  "<?xml version='1.0' encoding='utf-8'?><s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><s:Body><u:GetFriendlyName xmlns:u='urn:Belkin:service:basicevent:1'></u:GetFriendlyName></s:Body></s:Envelope>"
        
        let data = (body.data(using: .utf8))! as Data
        
        request.httpBody = data
        
        /* Alamofire recieves the response and uses AlamoFuzi .responseXML to gather the XML reponse. The XML response is then converted to a UTF8Text String and then the data is parsed and the response data is extracted from the recieved XML with SwiftyXMLParser. */
        
        Alamofire.request(request).responseXML { (response) in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print(response)
                let xml = try! XML.parse(utf8Text)
                if let text = xml["s:Envelope", "s:Body", "u:GetFriendlyNameResponse", "FriendlyName"].text {
                    
                    /* After the data is extracted as text it is added to the UILabel and the the infomration is sent back to the ViewDidLoad when this function is called. */
                    
                    self.deviceName.text? = "Device Name: " + text
                }
                
            }
            
            /* This function is a alert that is triggered when the same port is opened as the wemo device, but the information can be recieved by Alamofire, because the device is not a wemo device. */
            
            if ((response.error) != nil){
                
                self.showAlert(title: "Interesting", message: "Looks like our scanner picked this up, but it isn't a wemo device.")
            }
            
        }
        
    }
    
    func getDeviceStatus() {
        
        let url = "http://" + passedIP + ":49153/upnp/control/basicevent1"; //URL For Wemo Device to send Commands
        
        /* URL Request: Sending the data via request with Alamofire. HTTP Method is POST, Headers are specific for what action is being executed, and the body is the most important part of the data that is sent off. */
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
        request.setValue("\"urn:Belkin:service:basicevent:1#GetBinaryState\"", forHTTPHeaderField: "SOAPACTION")
        request.setValue("", forHTTPHeaderField: "Accept")
        
        let body =  "<?xml version='1.0' encoding='utf-8'?><s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><s:Body><u:GetBinaryState xmlns:u='urn:Belkin:service:basicevent:1'><BinaryState>1</BinaryState></u:GetBinaryState></s:Body></s:Envelope>"
        
        let data = (body.data(using: .utf8))! as Data
        
        request.httpBody = data
        
        /* Alamofire recieves the response and uses AlamoFuzi .responseXML to gather the XML reponse. The XML response is then converted to a UTF8Text String and then the data is parsed and the response data is extracted from the recieved XML with SwiftyXMLParser. */
        
        Alamofire.request(request).responseXML { (response) in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                
                /* Alamofire recieves the response and uses AlamoFuzi .responseXML to gather the XML reponse. The XML response is then converted to a UTF8Text String and then the data is parsed and the response data is extracted from the recieved XML with SwiftyXMLParser. */
                
                
                let xml = try! XML.parse(utf8Text)
                if let text = xml["s:Envelope", "s:Body", "u:GetBinaryStateResponse", "BinaryState"].text {
                    
                    /* Here we are fetching the devices current Binary status which is either a 1 or a 0. 0 meaning Off and 1 meaning On. I am also setting the variables I called earlier equal to ints so it works with the IBAction func ChangeStatus below */
                    
                    if (text == "0") {
                        self.currentStatus.setOn(false, animated: true)
                        self.currentStatusLabel.text? = "Status: Off"
                        self.status = 0
                        self.clicked = 0
                    } else {
                        self.currentStatus.setOn(true, animated: true)
                        self.currentStatusLabel.text? = "Status: On"
                        self.status = 2
                        self.clicked = 2
                    }
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func ChangeStatus(_ sender: AnyObject) { //IBAction for our UISwitch
        
        let url = "http://" + passedIP + ":49153/upnp/control/basicevent1"; //URL For Wemo Device to send Commands
        
        status = status + 1 //Incrementing the currentStatus + 1
        clicked = clicked + 1 //Incrementing the clickedData + 1
        
        
        if status == 1 && clicked == 1 {
            
            /* If the current status is set to One. This means that before the device was turned off, because if we look above at our getDeviceStatus Function if the status and clicked was 0 the device was off, but now that we added 1 we have successfully turned on the device */
            
            currentStatus.setOn(true, animated: true) //Changing the currentStatus to On
            self.currentStatusLabel.text? = "Status: On" //Changing the currentStatus UILabel to On
            
            /* Below we are sending another Alamofire request to turn on the device just like we have been in the previous functions. */
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
            request.setValue("\"urn:Belkin:service:basicevent:1#SetBinaryState\"", forHTTPHeaderField: "SOAPACTION")
            request.setValue("", forHTTPHeaderField: "Accept")
            
            let body =  "<?xml version='1.0' encoding='utf-8'?><s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><s:Body><u:SetBinaryState xmlns:u='urn:Belkin:service:basicevent:1'><BinaryState>1</BinaryState></u:SetBinaryState></s:Body></s:Envelope>"
            
            let data = (body.data(using: .utf8))! as Data
            
            request.httpBody = data
            
            Alamofire.request(request).responseXML { (response) in }
            
            
        } else if status > 1 && clicked > 1 {
            
            /* if the status is greater than 1 we are turning the device off. If we look again to the getDeviceStatus function we set the status = 2 and clicked = 2. That means the device is On and now is ready to be turned off on the next User inputted click. */
            
            currentStatus.setOn(false, animated: true) //Changing UISwitch to Off
            self.currentStatusLabel.text? = "Status: Off" //Changing currentStatusLabel to Off
            status = 0 //Resetting Status to 0
            clicked = 0 //Resetting Clicked to 0
            
            /* Below we are sending another Alamofire request to turn off the device just like we have been in the previous functions. */
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("text/xml; charset=\"utf-8\"", forHTTPHeaderField: "Content-Type")
            request.setValue("\"urn:Belkin:service:basicevent:1#SetBinaryState\"", forHTTPHeaderField: "SOAPACTION")
            request.setValue("", forHTTPHeaderField: "Accept")
            
            let body =  "<?xml version='1.0' encoding='utf-8'?><s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><s:Body><u:SetBinaryState xmlns:u='urn:Belkin:service:basicevent:1'><BinaryState>0</BinaryState></u:SetBinaryState></s:Body></s:Envelope>"
            
            let data = (body.data(using: .utf8))! as Data
            
            request.httpBody = data
            
            Alamofire.request(request).responseXML { (response) in }
        }
        
    }
    
    /* This last function is the alert function that is used to signal an alert when we have detected that the device is not a wemo device */
    
    func showAlert(title:String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in}
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
