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
    let baseURL:String = "https://api.nasa.gov/planetary/earth/imagery"
    let lat:String = "-34.424984"
    let lon:String = "150.8931239"
    let date:String = "2014-08-19"
    let cache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performNASARequest(lat, lon: lon, date: date)
    }
    
    
    
    func performNASARequest(lat: String, lon: String, date: String){
        
        let urlComp = NSURLComponents(string: baseURL)
        let urlLongitude = NSURLQueryItem(name: "lon", value: String(self.lon))
        let urlLatitude = NSURLQueryItem(name: "lat", value: String(self.lat))
        let api = NSURLQueryItem(name: "api_key", value: self.api_key)
        let urlDate = NSURLQueryItem(name: "date", value: self.date)
        urlComp!.queryItems = [urlLongitude, urlLatitude, api, urlDate]
        
//        print(lat)
//        print(lon)
//        print(date)
//        print(urlLatitude)
//        print(urlLongitude)
//        print(urlDate)
//        print(urlComp!)
        let urlRequest = NSMutableURLRequest(URL: urlComp!.URL!)
        let ss = NSURLSession.sharedSession()
        
        let task = ss.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
//            print(statusCode)
            // Status code of 200 returns OK
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.AllowFragments)
                    if let result = json as? NSDictionary {
//                        print(result)
                        let mapURL = result["url"] as? String
                        let mapDate = result["date"] as? String
                        self.fetchImage(mapURL!, mapDate: mapDate!)
                    }else {
                        print("The world in no more!")
                    }
                    
                    
                }catch {
                    fatalError("Error with Json: \(error)")
                }
            }else {
                print("Response Code: \((response as? NSHTTPURLResponse)!.statusCode)")
            }
        }
        task.resume()
        
    }
    
    func fetchImage(mapURL: String, mapDate: String){
//        print(mapURL)
//        print(mapDate)
        var loadImage = self.cache.objectForKey(mapURL) as? NSData
        if loadImage == nil {
            let data = NSData(contentsOfURL: NSURL(string: mapURL)!)
            self.cache.setObject(data!, forKey: mapURL)
            loadImage = self.cache.objectForKey(mapURL) as? NSData
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.dateLabel.text = mapDate
            self.mapImage.image = UIImage(data: loadImage!)
            })
    }
}