//
//  MainViewController.swift
//  MovieList
//
//  Created by Sailor on 01/08/2019.
//  Copyright © 2019 Sailor. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class MainViewController: UIViewController {

    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    
    var movies: [NSDictionary]? = nil
    var currentArray: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //deja buscar la seleccion despues de la busqueda
        searchController.obscuresBackgroundDuringPresentation = false
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
       
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //carga de peliculas y llamada a la API
        loadMovies()
       
    }
    
    @IBAction func cleanSearch(_ sender: Any) {
        restoreData()
    }
    
    
   /* func filterData(searchItem: String){
        if searchItem.count > 0 {
            currentArray = movies!
            
            //remplazo los espacios vacios y lo convierto en minuscula
            let filtrerResult = currentArray.filter {$.replacingOccurrences(of: " ", with: "").lowercased().contains(searchItem.replacingOccurrences(of: " ", with: "").lowercased())
            }
            
            currentArray = filtrerResult
            tableView.reloadData()
        }
    }
    */
    
    
    func restoreData(){
        currentArray = movies!
        tableView.reloadData()
    }
 
    
    //carga de peliculas y llamada a la API
    func loadMovies(){
      let apiKey = "d8ca9341ddf109600aafc5beb184e3d9"
      let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
      
        let request = NSURLRequest(url: url! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil{
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
                    self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    
                }
            }
        })
        task.resume()
        
    }

}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            //filterData
            tableView.reloadData()
        }
    }
}


extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchController.isActive = false
        
        if let searchText = searchBar.text {
            //filterData
           tableView.reloadData()
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
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
        let movie = movies![indexPath.row] 
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.imagePath.setImageWith(imageUrl! as URL)
        
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Selección", message: "Has seleccionado \(currentArray[indexPath.row])", preferredStyle: .alert)
        
        //quito el foco de la busqueda y me centro en el alert
        searchController.isActive =  false
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    */
    
}
