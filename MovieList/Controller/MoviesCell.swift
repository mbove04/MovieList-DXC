//
//  MoviesCell.swift
//  MovieList
//
//  Created by Sailor on 01/08/2019.
//  Copyright © 2019 Sailor. All rights reserved.
//

import UIKit

class MoviesCell: UITableViewCell {

 
    @IBOutlet weak var imagePath: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
