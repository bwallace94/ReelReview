//
//  MovieCell.swift
//  ReelReview
//
//  Created by Bria Wallace on 4/1/17.
//  Copyright © 2017 Bria Wallace. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
