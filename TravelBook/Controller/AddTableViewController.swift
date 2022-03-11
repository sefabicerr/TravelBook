//
//  AddTableViewController.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 4.03.2022.
//

import UIKit
import Gallery
import MapKit
import CoreLocation
import CoreData

class AddTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: Vars
    var itemImages: [UIImage?] = []
    var gallery: GalleryController!
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var choosenLatitude : Double = 0
    var choosenLongitude : Double = 0
    var imageDataArray = NSMutableArray()

    //MARK: IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!{
        didSet{
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
            nameTextField.autocapitalizationType = .words
        }
    }
    @IBOutlet weak var cityTextField: UITextField!{
        didSet{
            cityTextField.tag = 2
            cityTextField.delegate = self
            cityTextField.autocapitalizationType = .words
        }
    }
    @IBOutlet weak var typeTextField: UITextField!{
        didSet{
            typeTextField.tag = 3
            typeTextField.delegate = self
            typeTextField.autocapitalizationType = .words
        }
    }
    @IBOutlet weak var descriptionTextView: UITextView!{
        didSet{
            descriptionTextView.tag = 4
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }

        //MARK: Create gesture recognizer for mapview annotation
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }

    //MARK: Table View delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            self.gallery = GalleryController()
            self.gallery.delegate = self
            
            Config.tabsToShow = [.imageTab, .cameraTab]
            Config.Camera.imageLimit = 4
            self.present(self.gallery, animated: true, completion: nil)
        }
    }
    
    
    //MARK: IBActions methods
    @IBAction func backToHome(segue: UIStoryboardSegue){
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if nameTextField.text == "" || cityTextField.text == "" || typeTextField.text == "" || descriptionTextView.text == "" || choosenLatitude == 0 || choosenLongitude == 0 || itemImages.count < 2 {
            let alertController = UIAlertController(title: "Uyarı", message: "Lütfen yer ve en az 2 adet fotoğraf seçtiğinizden, tüm alanları doldurduğunuzdan emin olun.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alertController.addAction(alertAction)
            
            present(alertController, animated: true, completion: nil)
            return
        }else{
            
            //UIImage to Data converter
            for img in itemImages{
                if let data = img?.pngData(){
                    imageDataArray.add(data)
                }
            }
            
            //save coredata
            let context = appDelegate.persistentContainer.viewContext
            let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
            let data = try? NSKeyedArchiver.archivedData(withRootObject: imageDataArray, requiringSecureCoding: true)
            
            newPlace.setValue(data, forKey: "image")
            newPlace.setValue(UUID(), forKey: "id")
            newPlace.setValue(nameTextField.text, forKey: "name")
            newPlace.setValue(cityTextField.text, forKey: "city")
            newPlace.setValue(typeTextField.text, forKey: "type")
            newPlace.setValue(descriptionTextView.text, forKey: "inform")
            newPlace.setValue(choosenLatitude, forKey: "latitude")
            newPlace.setValue(choosenLongitude, forKey: "longitude")
            
            do {
                try context.save()
                print("success")
            } catch {
                print("error")
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: TextField methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    //create touched place annotation
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinate = mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            choosenLatitude = touchedCoordinate.latitude
            choosenLongitude = touchedCoordinate.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            annotation.title = ""
            annotation.subtitle = ""
            self.mapView.addAnnotation(annotation)
        }
    }
}



extension AddTableViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        Image.resolve(images: images) { (resolvedImages) in
            self.itemImages = resolvedImages
            self.image.image = self.itemImages[0]
        }
        
        //İmage Constraint Update
        self.image.contentMode = .scaleAspectFill
        self.image.clipsToBounds = true
        self.image.layer.cornerRadius = 50
        let leadingConstraint = NSLayoutConstraint(item: image as Any, attribute: .leading, relatedBy: .equal, toItem: image.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: image as Any, attribute: .trailing, relatedBy: .equal, toItem: image.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: image as Any, attribute: .top, relatedBy: .equal, toItem: image.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: image as Any, attribute: .bottom, relatedBy: .equal, toItem: image.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
    
        controller.dismiss(animated: true, completion: nil)
    }
}


extension AddTableViewController: MKMapViewDelegate, CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}



    
    
    

