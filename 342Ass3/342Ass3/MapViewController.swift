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
    
    var selectedLatitude: String = ""
    var selectedLongitude: String = ""
    let newAnotation = MKPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
//        locationManager?.requestWhenInUseAuthorization()
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
//        zoomIn()
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showHistory" {
            let vc = segue.destinationViewController as! SatelliteViewController
            vc.lat = self.selectedLatitude
            vc.lon = self.selectedLongitude
        }
        self.mapImage.removeAnnotation(newAnotation)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapImage.setRegion(region, animated: true)
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
    
//    func zoomIn(){
//        let userLocation = self.mapImage.userLocation
////
////        let region = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 2000, 2000)
////        
////        self.mapImage.setRegion(region, animated: true)
//        let region = MKCoordinateRegionMakeWithDistance(userLocation, 20, 20)
//    }
    
    
}