//
//  MovieDetailsViewController.swift
//  ReelReview
//
//  Created by Bria Wallace on 4/1/17.
//  Copyright © 2017 Bria Wallace. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var posterUrl: URL?
    var movieTitle: String?
    var releaseDate: String?
    var review: Double?
    var length: String?
    var movieOverview: String?

    @IBOutlet weak var movieScrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if posterUrl != nil {
            posterImageView.setImageWith(posterUrl!)
        }
        if movieTitle != nil {
            movieTitleLabel.text = movieTitle!
        }
        if releaseDate != nil {
            releaseDateLabel.text = releaseDate!
        }
        if review != nil {
            reviewLabel.text = "\(review!*10)%"
        }
        if length != nil {
            lengthLabel.text = length!
        }
        if movieOverview != nil {
            overviewLabel.text = movieOverview!
            overviewLabel.sizeToFit()
            let contentWidth = movieScrollView.bounds.width
            let contentHeight = overviewLabel.bounds.height * 1.5
            movieScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
