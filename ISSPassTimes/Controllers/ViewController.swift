//
//  ViewController.swift
//  ISSPassTimes
//
//  Created by Fabriccio De la Mora on 3/13/18.
//  Copyright © 2018 Fabriccio De la Mora. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate{

    private let locationManager = CLLocationManager()
    private var didUpdateInfo = false
    private var passTimes = [ISSPassTime]()
    private var timer = Timer()
    
    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var nextPassDateLabel: UILabel?
    @IBOutlet private var nextPassDurationLabel: UILabel?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0.0
        
        // CHECK FOR LOCATION VALIDATION
        self.locationManager.requestWhenInUseAuthorization()
        
        // If location services are enabled get the users location and start updates
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location
    
    // Ask for the times once the location has been obtained
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first, !didUpdateInfo{
            let passTimesFetch = ISSPassTimesFetch()
            passTimesFetch.fetchPassTimes(forLocation: location, success: { (passTimes, error) in
                // UPDATE INTERFACE
                if passTimes.count != 0 {
                    // Show interface once data has been validated
                    self.view.alpha = 1.0
                    self.displayData(passTimes)
                } else {
                    // Show error alert
                    self.showErrorAlert(error)
                }
            })
        }
    }
    
    // If we have been deined access give the user the option to change it
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    
    private func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "When In Use Location Access Disabled",
                                                message: "In order to check for the pass times we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                // Updates 'didUpdateInfo' value to let user re-check the pass times right after turning location services back on
                self.didUpdateInfo = false
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(_ error:String) {
        let alertController = UIAlertController(title: "Error",
                                                message: error,
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Interface
    
    private func displayData(_ times: [ISSPassTime]?) {
        guard var times = times else { return }
        
        // Turn off location updates
        self.locationManager.stopUpdatingLocation()
        
        if let nextPass = times.first,
            let minutes = times.first?.durationMinutes {
            // Start countdown timer
            self.setupTimerForPass(nextPass)
        
            // Update Next Pass duration label
            self.nextPassDurationLabel?.text = "\(minutes) minutes"
        }
        
        // Fill table with next times minus the current countdown item
        times.remove(at: 0)
        self.passTimes = times
        self.tableView?.reloadData()
    }
    
    private func setupTimerForPass(_ pass:ISSPassTime) {
        //var timeLeft = Date().timeIntervalSince(Date(timeIntervalSince1970: Double(pass.riseTime)))
        var timeLeft = -10.00000
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if timeLeft < 0 {
                let hours = Int(timeLeft) / 3600
                let minutes = Int(timeLeft) / 60 % 60
                let seconds = Int(timeLeft) % 60
                let timeLeftString = String(format: "%02i:%02i:%02i", abs(hours), abs(minutes), abs(seconds))
                self.nextPassDateLabel?.text = timeLeftString
                timeLeft += 1
            } else {
                self.nextPassDateLabel?.text = "ISS should be visible now"
                timer.invalidate()
            }
        })
    }
    
    // MARK: - Table View Protocol
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = passTimes[indexPath.row].timeZonedRiseTime
        
        return cell
    }

}

