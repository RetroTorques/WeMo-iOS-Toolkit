# Wemo iOS Toolkit

**_Wemo iOS Toolkit_** is an application built with Xcode for iOS that allows you to scan your LAN (Local Area Network) and find Wemo devices using the Wemo iOS Toolkit and port scanning libraries. _(Ex Used Ports: 49152, 49153, 49154)_. After you have found devices on your network that are from the Wemo product suite you are able to view information, and send commands to control the wemo devices on your network.

![alt text](https://github.com/RetroTorques/Wemo-iOS-Toolkit/blob/master/Demo.gif)

### Features
- [x] Scan your LAN (Local Area Network) for Wemo devices
- [x] View list of all Wemo devices connected to network
- [x] Send Commands to your devices as well as get device information

### Installation

- Dowload and install with Xcode 8.3+

### Libraries Used
- [Alamofire](https://github.com/Alamofire/Alamofire/) - Used to send requests and recieve responses to and from the Wemo devices
- [SwiftSocket](https://github.com/swiftsocket/SwiftSocket) - Used to send TCP port tests over LAN network to check for devices with open ports _(Ex: 49152, 49153, 49154)_
- [MBProgressHUD](https://github.com/jdg/MBProgressHUD) - Used to indicate when loading data in the application
- [MMLanScan](https://github.com/mavris/MMLanScan) - Used to get a LAN scan of network
- [AlamoFuzi](https://github.com/thebluepotato/AlamoFuzi) - Used with Alamofire requests using `.responseXML`
- [SwiftyXMLParser](https://github.com/yahoojapan/SwiftyXMLParser) - Used to parse XML data recieved from Wemo devices

### Requirements

- iOS 10+
- Xcode 8.3+
- Swift 3.1+

### Communication
- If you found a **bug** report an issue.
- If you have a **feature request** open an issue.
- If you want to **contribute** send a pull request.
