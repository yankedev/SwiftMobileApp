//
//  MapController.swift
//  devoxxApp
//
//  Created by maxday on 11.12.15.
//  Copyright (c) 2015 maximedavid. All rights reserved.
//

import Foundation
import UIKit
import MapKit

open class MapController : UIViewController, MKMapViewDelegate {
    
    open var index:Int = 0
    
    var mapView:MKMapView!
    
    override open func viewDidLoad() {
        self.title = "Map"
    }
    
    func reset() {
        
        mapView = MKMapView(frame: view.frame)
        self.view.backgroundColor = UIColor.white
        
        view.addSubview(mapView)
        
        var newRegion = MKCoordinateRegion()
        
        
        
        newRegion.center.latitude = CfpService.sharedInstance.getCoordLat()
        newRegion.center.longitude = CfpService.sharedInstance.getCoordLong()
        
        newRegion.span.latitudeDelta = 0.01;
        newRegion.span.longitudeDelta = 0.01;
        
        let coord = CLLocationCoordinate2D(latitude: newRegion.center.latitude, longitude: newRegion.center.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = CfpService.sharedInstance.getTitle()
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(newRegion, animated: false)
        
    }
    
}
