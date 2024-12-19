//
//  SettingsViewController.swift
//  IOS-Monitor
//
//  Created by stud on 12/12/2024.
//


import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    struct Setting {
        let name: String
        let imageName: String
        let key: String // Key for UserDefaults
    }
    
    let settings: [Setting] = [
        Setting(name: "Temperatura", imageName: "thermometer", key: "temperature"),
        //https://www.flaticon.com/free-icon/thermometer_1843544
        Setting(name: "Pyłki", imageName: "pollen", key: "pollen"),
        //https://www.flaticon.com/free-icon/pollen_1581828
        Setting(name: "Wiatr", imageName: "wind", key: "wind"),
        //https://www.flaticon.com/free-icon/wind_2011448
        Setting(name: "Opady", imageName: "rain", key: "rain"),
        //https://www.flaticon.com/free-icon/rain_116251
        Setting(name: "Ciśnienie", imageName: "pressure", key: "pressure"),
        //https://www.pngwing.com/en/free-png-nfyik
        Setting(name: "Wilgotność", imageName: "humidity", key: "humidity"),
        //https://www.flaticon.com/free-icon/humidity_219816
        Setting(name: "Zachmurzenie", imageName: "clouds", key: "clouds"),
        //https://www.flaticon.com/free-icon/clouds_22533
        Setting(name: "Widoczność", imageName: "visibility", key: "visibility"),
        //https://www.flaticon.com/free-icon/visibility_4264841
        Setting(name: "Jakość powietrza", imageName: "aqi", key: "airQuality"),
        //drive
    ]
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .white
        
        // Set up the table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let setting = settings[indexPath.row]
        
        // Configure the cell
        cell.textLabel?.text = setting.name
        if let image = UIImage(named: setting.imageName) {
            let paddedImage = addPadding(to: image, padding: 5)
            cell.imageView?.image = paddedImage
        }
        
        // Add the switch
        let toggle = UISwitch()
        toggle.isOn = UserDefaults.standard.bool(forKey: setting.key) // Get saved value
        toggle.tag = indexPath.row // Use the row to identify which setting
        toggle.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        cell.accessoryView = toggle
        
        return cell
    }
    
    // MARK: - Switch Toggle Action
    @objc func switchToggled(_ sender: UISwitch) {
        let setting = settings[sender.tag]
        UserDefaults.standard.set(sender.isOn, forKey: setting.key) // Save the setting
        print("\(setting.name) is now \(sender.isOn ? "ON" : "OFF")")
    }
    
    func addPadding(to image: UIImage, padding: CGFloat) -> UIImage {
        let newHeight = image.size.height + 2*padding
        let wid = image.size.width
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: wid, height: newHeight), false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.clear(CGRect(x: 0, y: 0, width: wid, height: newHeight))
        image.draw(in: CGRect(x: 0, y: padding, width: wid, height: image.size.height))
        let paddedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return paddedImage ?? image
    }
}
