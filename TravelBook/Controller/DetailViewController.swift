//
//  DetailViewController.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 2.03.2022.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var detailTableView: UITableView!

    //MARK: Vars
    var place: Places?
    var imgArr : [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.separatorStyle = .none
        
        //Data to UIImage converter
        if let inComingPlace = place {
            if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: inComingPlace.image!) {
                for data in dataArray {
                    if let data = data as? Data, let image = UIImage(data: data) {
                        imgArr.append(image)
                    }
                }
            }
        }
    }
}



extension DetailViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailNameCell", for: indexPath) as! DetailNameTableViewCell
            cell.nameLabel.text = "Yer Adı"
            cell.nameTextLabel.text = place?.name
            cell.selectionStyle = .none
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailNameCell", for: indexPath) as! DetailNameTableViewCell
            cell.nameLabel.text = "Şehir"
            cell.nameTextLabel.text = place?.city
            cell.selectionStyle = .none
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailNameCell", for: indexPath) as! DetailNameTableViewCell
            cell.nameLabel.text = "Tür"
            cell.nameTextLabel.text = place?.type
            cell.selectionStyle = .none
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailDescriptionCell", for: indexPath) as! DetailDescriptionTableViewCell
            cell.descriptionTextLabel.text = place?.inform
            cell.selectionStyle = .none

            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailMapViewCell", for: indexPath) as! DetailMapViewTableViewCell
            cell.mapViewLabel.text = "Nasıl giderim ?"
            cell.createAnnotation(place: place!)
            cell.selectionStyle = .none
        
            return cell
        default:
            fatalError("Detail controller table view cell hata")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailMapViewCell", for: indexPath) as! DetailMapViewTableViewCell
            cell.goToNavigation(place: place!)
        }
    }
}


extension DetailViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SliderCollectionViewCell
        cell.sliderImage.image = imgArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sliderCollectionView.frame.width, height: sliderCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }  
}
