//
//  ViewController.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 2.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var placeTableView: UITableView!
    
    //MARK: Vars
    var places: [Place] = [Place(placeName: "Kraliyet Sarayı", cityName: "Almanya", type: "Tarih", image: "almanya kopyası", imagee: "almanya kopyası", imageee: "almanya kopyası"),
                           Place(placeName: "Kraliyet Sarayı", cityName: "Almanya", type: "Restoran", image: "almanya kopyası", imagee: "almanya kopyası", imageee: "almanya kopyası"),
                           Place(placeName: "Kraliyet Sarayı", cityName: "Almanya", type: "Kafe", image: "almanya kopyası", imagee: "almanya kopyası", imageee: "almanya kopyası"),
                           Place(placeName: "Kraliyet Sarayı", cityName: "Almanya", type: "Oyun", image: "almanya kopyası", imagee: "almanya kopyası", imageee: "almanya kopyası")]
    var placeNamesList: [String] = []
    var placeImagesList: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTableView.delegate = self
        placeTableView.dataSource = self
        
        
        placeNamesList.append("Kraliyet Müzesi")
        placeImagesList.append(UIImage(named: "almanya kopyası")!)
        
    }

}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeTableViewCell", for: indexPath) as! PlaceTableViewCell
        cell.placeNameLabel.text = places[indexPath.row].placeName
        cell.cityNameLabel.text = places[indexPath.row].cityName
        cell.typeLabel.text = places[indexPath.row].type
        cell.placeImageView.image = UIImage(named:places[indexPath.row].image)
        
        return cell
    }
    
    
    
    
    
    
    
}

