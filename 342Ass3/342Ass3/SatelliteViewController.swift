//
//  SatteliteViewController.swift
//  342Ass3
//
//  Created by Peter Mavridis on 15/05/2016.
//  Copyright © 2016 Peter Mavridis. All rights reserved.
//

import Foundation
import UIKit

struct retrievedData {

    let rImage: UIImage
    let rDate: String
}

class SatelliteViewController: UIViewController {
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    let api_key:String = "kDL3uN6O7Dfe1pdladM4OYlIGcwe2J6e4rnUoC5F"
    let baseURL:String = "https://api.nasa.gov/planetary/earth/imagery"
    var lat:String = ""
    var lon:String = ""
    
    let cache = NSCache()
    let SEQUENCE = 5
    var timer = NSTimer()
    var index = 0
    var loading = UIActivityIndicatorView()
   
    
    
    var imageSequence = [retrievedData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Spinning gear indicating load happening.
        loading.center = self.view.center
        loading.hidesWhenStopped = true
        loading.activityIndicatorViewStyle = .Gray
        loading.color = UIColor.blackColor()
        view.addSubview(loading)

        performNASARequestSequence()
    }
    
    func performNASARequestSequence(){
        // Getting the current date to access the month for the sequence.
        let currentDate = NSDate()
        let currentCalendar = NSCalendar.currentCalendar()
        let dateComponents = currentCalendar.components([.Day, .Month, .Year], fromDate: currentDate)
        var year = dateComponents.year
        var month = dateComponents.month
        let day = dateComponents.day
        var date = String(year) + "-" + String(month) + "-" + String(day)
        date = String(year) + "-" + String(month) + "-" + String(day)

        for _ in 0..<SEQUENCE {
            if month > 0 {
                performNASARequest(date)
                month -= 1
                date = String(year) + "-" + String(month) + "-" + String(day)
            }else {
                month = 12
                year -= 1
                date = String(year) + "-" + String(month) + "-" + String(day)
                performNASARequest(date)
                month -= 1
                date = String(year) + "-" + String(month) + "-" + String(day)
            }
        }
    }
    
    func performNASARequest(date: String){
        
        let urlComp = NSURLComponents(string: baseURL)
        let urlLongitude = NSURLQueryItem(name: "lon", value: self.lon)
        let urlLatitude = NSURLQueryItem(name: "lat", value: self.lat)
        let api = NSURLQueryItem(name: "api_key", value: self.api_key)
        let urlDate = NSURLQueryItem(name: "date", value: date)
        urlComp!.queryItems = [urlLongitude, urlLatitude, api, urlDate]
     

        self.loading.startAnimating()
        self.dateLabel.text = "Loading, Please wait..."
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
        let data = NSData(contentsOfURL: NSURL(string: mapURL)!)
        let tmp = retrievedData(rImage: UIImage(data: data!)!, rDate: mapDate)
        self.imageSequence.append(tmp)
        dispatch_async(dispatch_get_main_queue()){
            self.timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: (#selector(SatelliteViewController.loadImages)), userInfo: nil, repeats: true)
        }
    }
    
    
    func loadImages() {
        self.loading.stopAnimating()
        self.mapImage.image = self.imageSequence[self.index].rImage
        self.dateLabel.text = self.imageSequence[self.index].rDate
        self.index += 1
        if self.index == 4 {
            self.index = 0
        }
       
        
        
    }
    
    
    
}