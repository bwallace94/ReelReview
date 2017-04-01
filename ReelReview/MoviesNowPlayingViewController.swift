//
//  MoviesNowPlayingViewController.swift
//  ReelReview
//
//  Created by Bria Wallace on 4/1/17.
//  Copyright © 2017 Bria Wallace. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesNowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movies: [NSDictionary] = []
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var isMoreDataLoading: Bool = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = moviesTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - moviesTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && moviesTableView.isDragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.isMoreDataLoading = false
                        let responseFieldDictionary = responseDictionary["results"] as! [NSDictionary]
                        self.movies += responseFieldDictionary
                        self.moviesTableView.reloadData()
                    }
                }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Movie Cell") as! MovieCell
        let movie = movies[indexPath.row]
        if let poster_path = movie.value(forKey: "poster_path") as? String {
            let imageUrlString = "https://image.tmdb.org/t/p/w342\(poster_path)"
            cell.movieImageView.setImageWith(URL(string: imageUrlString)!)
        }
        if let movie_title = movie.value(forKey: "title") as? String {
            cell.movieTitleLabel.text = movie_title
        }
        if let movie_details = movie.value(forKey: "overview") as? String {
            cell.movieDetailsLabel.text = movie_details
            cell.movieDetailsLabel.sizeToFit()
        }
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        loadMoreData()
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.moviesTableView.tableFooterView = tableFooterView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}