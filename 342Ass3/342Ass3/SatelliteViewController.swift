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
    // Pass an object around for map and date.
    struct mapInfo {
        var mapURL: String
        var locationDate: String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveData("2013-09-19"){ result, dataRetrieved in
            if result{
                self.getImage(dataRetrieved!)
            } else {
                print("Nothing to retrieve")
            }
        }
    }
    
    func getImage(location: mapInfo){
        if let url = NSURL(string: location.mapURL){
            let ns = NSURLSession.sharedSession()
            ns.dataTaskWithURL(url, completionHandler: {(data, response, error) in
                if error != nil {
                    print("error with image url")
                } else if let imageData = data, image = UIImage(data: imageData) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mapImage.image = image
                        self.dateLabel.text = location.locationDate
                    })
                }
            }).resume()
        }
    }
    
    func retrieveData(date: String, completion: (result: Bool, data:mapInfo?) -> ()){
        let keys: Dictionary = [
            "api_key"	:	api_key,
            "lat"		:	lat,
            "lon"		:	lon,
            "date"		:	date,
            "cloud_score":	"True"
        ]
        
        let urlComp = NSURLComponents(string: apiURL)!
        
        var query = [NSURLQueryItem]()
        for (key, value) in keys {
            query.append(NSURLQueryItem(name: key, value: value))
        }
        urlComp.queryItems = query
        
        let url = urlComp.URL!
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                do{
                    let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments )
                    if let result = JSON as? NSDictionary{
                        let mapURL = result["url"] as? String
                        let locationDate = result["date"] as? String
                        if mapURL != nil {
                            completion(result: true, data: mapInfo(mapURL: mapURL!, locationDate: locationDate!))
                        }else{
                            print("Error getting image")
                        }
                        
                    }
                } catch {
                    print("Nothing found")
                    completion(result: false, data: nil)
                 }
            }
        }.resume()
    }
   
    
}
