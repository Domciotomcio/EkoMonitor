//
//  MapViewController.swift
//  IOS-Monitor
//
//  Created by stud on 12/12/2024.
//


import UIKit
import MapKit
import CoreLocation

// <key>NSLocationWhenInUseUsageDescription</key>
// <string>We need your location to center the map.</string>


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager() // For accessing user's location
    var selectedCoordinate: CLLocationCoordinate2D? // Stores the pin's coordinates

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//         Set up the map
        mapView.delegate = self
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        // Request location permissions
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true // Show the user's location on the map
        
        // Add a long press gesture to add a pin
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
        
//         Add buttons
        setupButtons()
        
        if UserDefaults.standard.object(forKey: "lat") != nil && UserDefaults.standard.object(forKey: "lon") != nil {
            let lat = UserDefaults.standard.double(forKey: "lat")
            let lon = UserDefaults.standard.double(forKey: "lon")
            
            let savedCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = savedCoordinate
            annotation.title = "Selected Location"
            mapView.addAnnotation(annotation)
            
            // Save the coordinate
            selectedCoordinate = savedCoordinate
            
        }
        
    }
    
    func setupButtons() {
        // Button to center map on user's location
        let userLocationButton = createStyledButton(title: "Center on Me")
        userLocationButton.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 60, width: 150, height: 40)
        userLocationButton.addTarget(self, action: #selector(centerOnUserLocation), for: .touchUpInside)
        view.addSubview(userLocationButton)
        
        // Button to center map on pin
        let pinLocationButton = createStyledButton(title: "Go to Pin")
        pinLocationButton.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 110, width: 150, height: 40)
        pinLocationButton.addTarget(self, action: #selector(centerOnPin), for: .touchUpInside)
        view.addSubview(pinLocationButton)
        
        // Button to center map on user's location and pins that location
        let userLocationPinButton = createStyledButton(title: "Create Pin on Me")
        userLocationPinButton.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 160, width: 150, height: 40)
        userLocationPinButton.addTarget(self, action: #selector(pinUserLocation), for: .touchUpInside)
        view.addSubview(userLocationPinButton)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let locationInView = gesture.location(in: mapView)
            let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            // Remove existing annotations
            mapView.removeAnnotations(mapView.annotations)
            
            // Add a new annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Selected Location"
            mapView.addAnnotation(annotation)
            
            // Save the coordinate
            selectedCoordinate = coordinate
            
            UserDefaults.standard.set(selectedCoordinate!.latitude as Double, forKey: "lat")
            UserDefaults.standard.set(selectedCoordinate!.longitude as Double, forKey: "lon")
        }
    }
    
    @objc func centerOnUserLocation() {
        guard let userLocation = locationManager.location else {
            let alert = UIAlertController(title: "Error", message: "Unable to determine your location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func pinUserLocation() {
        guard let userLocation = locationManager.location else {
            let alert = UIAlertController(title: "Error", message: "Unable to determine your location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        
        // Add a new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
        
        // Save the coordinate
        selectedCoordinate = userLocation.coordinate
        
        UserDefaults.standard.set(selectedCoordinate!.latitude as Double, forKey: "lat")
        UserDefaults.standard.set(selectedCoordinate!.longitude as Double, forKey: "lon")
    }
    
    @objc func centerOnPin() {
        guard let pinCoordinate = selectedCoordinate else {
            let alert = UIAlertController(title: "Error", message: "No pin has been placed on the map.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        let region = MKCoordinateRegion(center: pinCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    // Handle location permission changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            let alert = UIAlertController(title: "Location Access Denied", message: "Please enable location permissions in settings to use this feature.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // Add beutiful buttons
    private func createStyledButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4
        
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchDragExit])
        
        return button
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform.identity
        })
    }
}
