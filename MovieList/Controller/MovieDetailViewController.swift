//
//  MovieDetailViewController.swift
//  MovieList
//
//  Created by Sailor on 02/08/2019.
//  Copyright © 2019 Sailor. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var delegate: MainViewController?
    
    var image = UIImage()
    var vote = ""
    var titleMovie = ""
    var overviewDetail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTitleDetail.text = titleMovie
        overviewDetails.text = overviewDetail
        imagePathDetail.image = image
        voteAverageDetail.text = vote
    }

    @IBOutlet weak var voteAverageDetail: UILabel!
    @IBOutlet weak var imagePathDetail: UIImageView!
    @IBOutlet weak var movieTitleDetail: UILabel!
    @IBOutlet weak var overviewDetails: UILabel!
    
}
