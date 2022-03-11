//
//  ViewController.swift
//  TravelBook
//
//  Created by Muhammed Sefa Biçer on 2.03.2022.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController, UISearchResultsUpdating {
    
    //MARK: IBOutlets
    @IBOutlet weak var placeTableView: UITableView!
    @IBOutlet var emptyPlaceView: UIView!
   
    //MARK: Vars
    var places = [Places]()
    let context = appDelegate.persistentContainer.viewContext
    var searchController : UISearchController!
    var searchResults = [Places]()
    
    //MARK: VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        placeTableView.delegate = self
        placeTableView.dataSource = self
        
        //Prepare the emty view
        placeTableView.backgroundView = emptyPlaceView
        placeTableView.backgroundView?.isHidden = true
        //SearchBar methods
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Kaydedilen yerlerde ara..."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        placeTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellToDetail" {
            let indeks = sender as! Int
            let goToVC = segue.destination as? DetailViewController
            goToVC?.place = (searchController.isActive) ? searchResults[indeks] : places[indeks]
        }
    }
    
    //MARK: CoreData get data method
    func getData(){
        do {
            places = try context.fetch(Places.fetchRequest())
        }catch{
            print("error")
        }
    }
    
    //MARK: SearchBar Methods
    func filterContent(for searchText: String) {
        searchResults = places.filter({ (place) -> Bool in
            if let name = place.name{
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            placeTableView.reloadData()
        }
    }
}



//MARK: Tableview datasource extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive{
            return false
        }else{
            return true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if places.count > 0{
            placeTableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
            navigationItem.searchController?.searchBar.isHidden = false
            
        }else {
            placeTableView.backgroundView?.isHidden = false
            placeTableView.separatorStyle = .none
            navigationItem.searchController?.searchBar.isHidden = true
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return searchResults.count
        }else {
            return places.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let place = (searchController.isActive) ? searchResults[indexPath.row] : places[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeTableViewCell", for: indexPath) as! PlaceTableViewCell
        cell.placeNameLabel.text = place.name
        cell.cityNameLabel.text = place.city
        cell.typeLabel.text = place.type
        
        if let dataArray = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: place.image!){
            if let data = dataArray[0] as? Data{
                cell.placeImageView.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellToDetail", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { contextualAction,view, boolValue in
            
            let place = self.places[indexPath.row]
            self.context.delete(place)
            appDelegate.saveContext()
            self.getData()
            self.placeTableView.reloadData()
            }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

