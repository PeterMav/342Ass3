//
//  MapViewController.swift
//  342Ass3
//
//  Created by Peter Mavridis on 23/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
   
    @IBOutlet weak var mapImage: MKMapView!
    @IBOutlet weak var historyButton: UIButton!
    
    @IBOutlet weak var changeMapButton: UIBarButtonItem!
    
    
    var selectedLatitude: String = ""
    var selectedLongitude: String = ""
    let newAnotation = MKPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.changeMapButton.title = "Standard View"
        locationManager = CLLocationManager()
        // Get current location and show on map.
        if CLLocationManager.locationServicesEnabled() {
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager!.startUpdatingLocation()
        }else {
            locationManager?.requestWhenInUseAuthorization()
        }
        mapImage.delegate = self
        mapImage.showsUserLocation = true
        historyButton.alpha = 0
        mapImage.mapType = MKMapType.Satellite
    }
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.mapImage.removeAnnotation(newAnotation)
        historyButton.alpha = 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showHistory" {
            let vc = segue.destinationViewController as! SatelliteViewController
            vc.lat = self.selectedLatitude
            vc.lon = self.selectedLongitude
        }
        
        
    }
    
    // Zoom into current location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapImage.setRegion(region, animated: true)
    }
    
    // Changes from satellite view to standard view.
    @IBAction func changeMap(sender: AnyObject) {
        if mapImage.mapType == MKMapType.Satellite {
            mapImage.mapType = MKMapType.Standard
            self.changeMapButton.title = "Satellite View"
        }else{
            mapImage.mapType = MKMapType.Satellite
            self.changeMapButton.title = "Standard View"
        }
    }
    
    
    
    @IBAction func longPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = gestureRecognizer.locationInView(self.mapImage)
        let newCoord:CLLocationCoordinate2D = mapImage.convertPoint(touchPoint, toCoordinateFromView: self.mapImage)
        
        newAnotation.coordinate = newCoord
        newAnotation.title = String(newCoord.latitude)
        newAnotation.subtitle = String(newCoord.longitude)
        mapImage.addAnnotation(newAnotation)
        self.selectedLatitude = String(newCoord.latitude)
        self.selectedLongitude = String(newCoord.longitude)
        historyButton.alpha = 1
        
    }
}