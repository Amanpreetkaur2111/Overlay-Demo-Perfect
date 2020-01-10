//
//  ViewController.swift
//  Overlay Demo
//
//  Created by MacStudent on 2020-01-10.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    
    let places = Place.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        addAnnotations()
        addPolyLine()
          polygon()
        
    }
    
    func addAnnotations(){
        
        mapView.delegate = self
        mapView.addAnnotations(places)
        
        
        let overlays = places.map { (MKCircle(center: $0.coordinate, radius: 2000))
        }
        
        mapView.addOverlays(overlays)
    }

    func addPolyLine(){
        
        let locations = places.map{$0.coordinate}
        let polyLine = MKPolyline(coordinates: locations, count: locations.count)
        mapView.addOverlay(polyLine)
    }
    
    func polygon(){
        
        let location = places.map{$0.coordinate}
        let polygon = MKPolygon(coordinates: location, count: location.count)
        mapView.addOverlay(polygon)
        }

}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            
            return nil
        }  else {  let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            
            annotationView.image = UIImage(named: "ic_place_2x")
            
            return annotationView
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKCircle{
        
        
        let rendrer = MKCircleRenderer(overlay: overlay)
        rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
        rendrer.strokeColor = UIColor.green
        rendrer.lineWidth  = 2
        return rendrer
        } else if overlay is MKPolyline{
            
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.blue
            rendrer.lineWidth = 3
            return rendrer
        }
        else if overlay is MKPolygon{
            
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.orange
            rendrer.lineWidth = 2
            return rendrer
        }
        
    return MKOverlayRenderer()
}

}
