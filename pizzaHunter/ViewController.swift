//
//  ViewController.swift
//  pizzaHunter
//
//  Created by david on 1/18/22.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    var shops: [MKMapItem] = []
    var selectedShop: pizzaShop?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
    }

    @IBAction func searchPress(_ sender: UIBarButtonItem)
    {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Pizza"
        searchRequest.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        let search = MKLocalSearch(request: searchRequest )
        search.start { response, error in
            if let response = response
            {
                for mapItem in response.mapItems
                {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = mapItem.placemark.coordinate
                    annotation.title = mapItem.name
                    
                    
                    
                    
                    
                    
                    self.mapView.addAnnotation(annotation)
                    
                    self.shops.append(mapItem)
                    
                }
            }
        }
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation.isEqual(mapView.userLocation)
        {
            return nil
        }
    
    let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.image = UIImage(named: "pizza")
        pin.canShowCallout = true
        let button = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = button
        
        
        
        
        
    return pin

    
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
         var currentMapItem = MKMapItem()
        if let title = view.annotation?.title, let shopName = title
        {
            for mapItem in shops
            {
                if mapItem.name == shopName
                {
                    currentMapItem = mapItem
                }
            }
        }
           
        let placeMark = currentMapItem.placemark
        let name = placeMark.name ?? "unknown name"
        let state = placeMark.administrativeArea ?? "unknown state"
        let city = placeMark.locality ?? "unknown city"
        let street = placeMark.thoroughfare ?? "no address"
        let streetNumber = placeMark.subThoroughfare ?? "no street number"
        
        let fullAddressString = "\(streetNumber) \(street), \(city), \(state)"
        let phone = currentMapItem.phoneNumber ?? "no phone number"
        
        
        selectedShop = pizzaShop(name: name, address: fullAddressString, phoneNumer: phone)
        
        performSegue(withIdentifier: "shopInfo", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let nvc = segue.destination as! DetailsViewController
        nvc.currentPizzaShop = selectedShop
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
          currentLocation = location
        }
        setRegion()
        
    }
    
    
    
    
    func setRegion()
    {
        let region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    
    
    
    
    
}

