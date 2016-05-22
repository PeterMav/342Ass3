//
//  MapViewController.swift
//  342Ass3
//
//  Created by Peter Mavridis on 23/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
   
    @IBOutlet weak var mapImage: MKMapView!
    @IBOutlet weak var historyButton: UIButton!
    
    var selectedLatitude: String = ""
    var selectedLongitude: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
     
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        if segue.identifier == "showHistory" {
//            let vc = segue.destinationViewController as! SatelliteViewController
//            vc.lat = self.selectedLatitude
//            vc.lon = self.selectedLongitude
//        }
    }
    
    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        
        print("I long pressed")
    }
    
}