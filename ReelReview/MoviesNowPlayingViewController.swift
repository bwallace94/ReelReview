//
//  MoviesNowPlayingViewController.swift
//  ReelReview
//
//  Created by Bria Wallace on 4/1/17.
//  Copyright © 2017 Bria Wallace. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesNowPlayingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var movies: [NSDictionary] = []
    
    @IBOutlet weak var networkErrorView: UIView!
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var isMoreDataLoading: Bool = false
    
    var searchController: UISearchController!
    
    var filteredMovies: [NSDictionary] = []
    
    var endpoint = ""
    
    func loadMoreData() {
        let url_string = "https://api.themoviedb.org/3/movie/\(self.endpoint)?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:url_string)
        let request = URLRequest(url: url!)
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 3.0
        sessionConfig.timeoutIntervalForResource = 3.0
        let session = URLSession(
            configuration: sessionConfig,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
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
                MBProgressHUD.hide(for: self.view, animated: true)
                if self.movies.isEmpty {
                    self.networkErrorView.isHidden = false
                }
                else {
                    self.networkErrorView.isHidden = true
                }

        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredMovies.count
        }
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Movie Cell") as! MovieCell
        var movie = movies[indexPath.row]
        if searchController.isActive && searchController.searchBar.text != "" {
            movie = self.filteredMovies[indexPath.row]
        }
        if let poster_path = movie.value(forKey: "poster_path") as? String {
            let imageUrlString = "https://image.tmdb.org/t/p/w342\(poster_path)"
            let imageRequest = NSURLRequest(url: URL(string: imageUrlString)!)
            cell.movieImageView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    if imageResponse != nil {
                        cell.movieImageView.alpha = 0.0
                        cell.movieImageView.image = image
                        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                            cell.movieImageView.alpha = 1.0
                        })
                    } else {
                        cell.movieImageView.image = image
                    }
            },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
        }
        if let movie_title = movie.value(forKey: "title") as? String {
            cell.movieTitleLabel.text = movie_title
        }
        if let movie_details = movie.value(forKey: "overview") as? String {
            cell.movieDetailsLabel.text = movie_details
            cell.movieDetailsLabel.sizeToFit()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
            
        return headerView
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadMoreData()
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieDetailsViewController
        let indexPath = moviesTableView.indexPath(for: sender as! MovieCell)!
        var movie = movies[indexPath.row]
        if searchController.isActive && searchController.searchBar.text != "" {
            movie = self.filteredMovies[indexPath.row]
        }
        if let poster_path = movie.value(forKey: "poster_path") as? String {
            vc.poster_url = poster_path
        }
        if let title = movie.value(forKey: "original_title") as? String {
            vc.movieTitle = title
        }
        if let release = movie.value(forKey: "release_date") as? String {
            vc.releaseDate = release
        }
        if let review = movie.value(forKey: "vote_average") as? Double {
            vc.review = review
        }
        // GET MOVIE LENGTH
        if let overview = movie.value(forKey: "overview") as? String {
            vc.movieOverview = overview
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        loadMoreData()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies"
        searchController.hidesNavigationBarDuringPresentation = false
        moviesTableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(_ searchText: String) {
        self.filteredMovies = self.movies.filter({(movie) -> Bool in
            let movieTitle = movie.value(forKey: "original_title") as! String
            return movieTitle.lowercased().contains(searchText.lowercased())
        })
        moviesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MoviesNowPlayingViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension MoviesNowPlayingViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
