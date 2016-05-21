//
//  SatteliteViewController.swift
//  342Ass3
//
//  Created by Peter Mavridis on 15/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//

import Foundation
import UIKit
class SatelliteViewController: UIViewController {
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let api_key:String = "kDL3uN6O7Dfe1pdladM4OYlIGcwe2J6e4rnUoC5F"
    let apiURL:String = "https://api.nasa.gov/planetary/earth/imagery"
    let lat:String = "-34.424984"
    let lon:String = "150.8931239"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        performNASARequest()
    }
    
    func fetchImage(mapURL: String){
        
    }
    
    func performNASARequest(){
        let urlComp = NSURLComponents(string: apiURL)
        let longitudeParam = NSURLQueryItem(name: "lon", value: String(self.lon))
        let latitudeParam = NSURLQueryItem(name: "lat", value: String(self.lat))
        let apiParam = NSURLQueryItem(name: "api_key", value: self.api_key)
        urlComp!.queryItems = [longitudeParam, latitudeParam, apiParam]
    }
}