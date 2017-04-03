//
//  MovieDetailsViewController.swift
//  ReelReview
//
//  Created by Bria Wallace on 4/1/17.
//  Copyright © 2017 Bria Wallace. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var poster_url: String?
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
        if let posterUrlString: String = poster_url {
            let smallPosterUrl = URL(string: "https://image.tmdb.org/t/p/w45\(posterUrlString)")!
            let smallPosterUrlRequest = NSURLRequest(url: smallPosterUrl)
            let largePosterUrl = URL(string: "https://image.tmdb.org/t/p/original\(posterUrlString)")!
            let largePosterUrlRequest = NSURLRequest(url: largePosterUrl)
            self.posterImageView.setImageWith(
                smallPosterUrlRequest as URLRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        
                        self.posterImageView.alpha = 1.0
                        
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.posterImageView.setImageWith(
                            largePosterUrlRequest as URLRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.posterImageView.image = largeImage;
                                
                        },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                    })
            },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                    // possibly try to get the large image
            })
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
