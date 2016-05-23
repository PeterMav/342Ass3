//
//  MapViewController.swift
//  342Ass3
//
//  Created by Peter Mavridis on 23/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//


import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
   
    @IBOutlet weak var mapImage: MKMapView!
    @IBOutlet weak var historyButton: UIButton!
    
    var selectedLatitude: String = ""
    var selectedLongitude: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapImage.delegate = self
        mapImage.showsUserLocation = true
        historyButton.alpha = 0
        mapImage.mapType = MKMapType.Satellite
        zoomIn()
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showHistory" {
            let vc = segue.destinationViewController as! SatelliteViewController
            vc.lat = self.selectedLatitude
            vc.lon = self.selectedLongitude
        }
    }
    
    
    @IBAction func longPressed(gestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = gestureRecognizer.locationInView(self.mapImage)
        let newCoord:CLLocationCoordinate2D = mapImage.convertPoint(touchPoint, toCoordinateFromView: self.mapImage)
        
        let newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord
        newAnotation.title = String(newCoord.latitude)
        newAnotation.subtitle = String(newCoord.longitude)
        mapImage.addAnnotation(newAnotation)
        self.selectedLatitude = String(newCoord.latitude)
        self.selectedLongitude = String(newCoord.longitude)
        historyButton.alpha = 1
     
    }
    
    func zoomIn(){
        let userLocation = self.mapImage.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 2000, 2000)
        
        self.mapImage.setRegion(region, animated: true)
    }
    
    
}