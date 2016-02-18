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

public class MapController : UIViewController, MKMapViewDelegate, ScrollableItemProtocol {
    
    public var index:Int = 0
    
    var mapView:MKMapView!
    
    override public func viewDidLoad() {
        self.title = "Map"
        
        
        
        
        
        
        
    }
    
    func reset() {
        
        mapView = MKMapView(frame: view.frame)
        self.view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(mapView)

        
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = 48.8794887
        newRegion.center.longitude = 2.2812642
        
        
        
        
        newRegion.span.latitudeDelta = 0.01;
        newRegion.span.longitudeDelta = 0.01;
        
        
        let coord = CLLocationCoordinate2D(latitude: 48.8794887, longitude: 2.2812642)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = "Devoxx France 2016"
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(newRegion, animated: false)
        
    }
    
}
