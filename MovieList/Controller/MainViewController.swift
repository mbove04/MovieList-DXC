//
//  MainViewController.swift
//  MovieList
//
//  Created by Sailor on 01/08/2019.
//  Copyright © 2019 Sailor. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var originalArray:[String] = []
    var currentArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addProduct(productCount: 25, product: "MacBook Pro 2015")
        addProduct(productCount: 13, product: "MacBook Pro 2016")
        addProduct(productCount: 10, product: "MacBook Pro 2017")
        addProduct(productCount: 22, product: "MacBook Air 2018")
        
        currentArray = originalArray
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //deja buscar la seleccion despues de la busqueda
        searchController.obscuresBackgroundDuringPresentation = false
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
       
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func cleanSearch(_ sender: Any) {
        restoreData()
    }
    
    
    func addProduct(productCount: Int, product: String) {
        for index in 1...productCount{
            originalArray.append("\(product)#\(index)")
        }
    }
    
    func filterData(searchItem: String){
        if searchItem.count > 0 {
            currentArray = originalArray
            
            //remplazo los espacios vacios y lo convierto en minuscula
            let filtrerResult = currentArray.filter {$0.replacingOccurrences(of: " ", with: "").lowercased().contains(searchItem.replacingOccurrences(of: " ", with: "").lowercased())
            }
            
            currentArray = filtrerResult
            tableView.reloadData()
        }
    }
    
    func restoreData(){
        currentArray = originalArray
        tableView.reloadData()
    }

}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterData(searchItem: searchText)
        }
    }
}


extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchController.isActive = false
        
        if let searchText = searchBar.text {
            filterData(searchItem: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        
        //si tocamos el boton de cancelar por error
        if let searchText = searchBar.text, !searchText.isEmpty{
            restoreData()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Seleccionar", message: "Has seleccioando \(currentArray[indexPath.row])", preferredStyle: .alert)
        
        //quito el foco de la busqueda y me centro en el alert
        searchController.isActive =  false
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
}
