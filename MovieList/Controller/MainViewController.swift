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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var segueOverview: String!
    var segueTitle: String!
    var segueMedia: String!
    var segueImage: UIImage!
    
    var movies: [NSDictionary]? = nil
    var filteredMovies: [NSDictionary]? = nil
    var currentDictionary: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        //carga de peliculas y llamada a la API
        loadMovies()
        
    }
    
    //oculto el teclado luego de la búsqueda
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    //carga de peliculas y llamada a la API.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            let destination = segue.destination as! MovieDetailViewController
            
            destination.overviewDetail = segueOverview
            destination.titleMovie = segueTitle
            destination.image = segueImage
            destination.vote = segueMedia
            destination.delegate = self
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    //controlo que se reciban datos de la API
    func getMovies() -> [NSDictionary]? {
        guard let filtered = filteredMovies, filteredMovies?.count ?? 0 > 0 else {
            return movies
        }
        return filtered
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMovies()?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell", for: indexPath) as! MoviesCell
        
        let movie = getMovies()![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let voteAverage = movie["vote_average"] as! Double
        
        var voteAverageString: String = "Media: "
        voteAverageString = voteAverageString + String(voteAverage)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.voteAverage.text = voteAverageString
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.imagePath.setImageWith(imageUrl! as URL)
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as! MoviesCell
        
        segueOverview = currentCell.overviewLabel.text!
        segueTitle = currentCell.titleLabel.text!
        segueImage = currentCell.imagePath.image!
        segueMedia = currentCell.voteAverage.text!
        
        performSegue(withIdentifier: "segueDetail", sender: self)
    }
    
    
}

extension MainViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies :
            movies?.filter({ movies -> Bool in
                if let str = movies.value(forKey: "title") as? String {
                    return str.range(of: searchText, options: .caseInsensitive) != nil
                }
                return false
            })
        tableView.reloadData()
    }
}
