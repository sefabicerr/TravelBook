//
//  DetailMapViewTableViewCell.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 4.03.2022.
//

import UIKit
import MapKit
import CoreLocation

class DetailMapViewTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var mapViewLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createAnnotation(place : Places){
        
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        annotation.coordinate = coordinate
        annotation.title = place.name
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func goToNavigation(place : Places){
        
        let requestLocation = CLLocation(latitude: place.latitude, longitude: place.longitude)
        CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
            if let placemark = placemarks {
                if placemark.count > 0 {
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }

}
