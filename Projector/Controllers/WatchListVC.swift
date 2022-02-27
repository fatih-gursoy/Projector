//
//  WatchListVC.swift
//  Projector
//
//  Created by Fatih Gursoy on 8.02.2022.
//

import UIKit
import CoreData

class WatchListVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    var CoreDataService = CoreService()
    var watchList = [WatchList]()

    private var moviesViewModel: MoviesViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        searchBar.delegate = self
        hideKeyboard()
        
        movieTableView.register(UINib(nibName: "MovieTableCellView", bundle: nil), forCellReuseIdentifier: "MovieTableCell")
        
        let notificationCenter: NotificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("UpdateWatchList") , object: nil)

        fetchWatchList()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "toMovieDetailVC" {

            let vc = segue.destination as! MovieDetailVC
            let indexPath = sender as! IndexPath
            vc.movieId = moviesViewModel?.movieAtIndex(indexPath.row).id

        }
    }
    
    func fetchWatchList() {

        moviesViewModel = MoviesViewModel(movieList: [])
        watchList = CoreService().watchList

        for item in watchList {
            
            if let movieId = item.movieId {
                
                WebService().downloadMovieDetail(movieId: movieId) { movie in
                    guard let movie = movie else {return}
                    
                    var movieViewModel = MovieViewModel(movie: movie)
                    movieViewModel.updateWatchStatus()
                    self.moviesViewModel?.addMovie(movie: movieViewModel.movie)

                    DispatchQueue.main.async {
                        self.movieTableView.reloadData()
                    }
                }
            }
        }
        movieTableView.reloadData()
    }
    
    @objc func updateUI() {
        
        fetchWatchList()
        
    }

}

extension WatchListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let count = moviesViewModel?.count else {return 0}
        return count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as! MovieTableCell
        
        if let movieViewModel = moviesViewModel?.movieAtIndex(indexPath.row) {
            
            cell.movieTitle.text = movieViewModel.MovieTitle
            if let posterPath = movieViewModel.movie.posterPath {

                cell.movieImage.sd_setImage(with: URL(string: API.ImageBaseURL+posterPath))
            }

            let rating = movieViewModel.movie.voteAverage ?? 0
            cell.movieRating.text = String(describing: rating)
            
            if let isWatched = movieViewModel.movie.isWatched {
            
                if isWatched {
                    cell.watchButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
                } else {
                    cell.watchButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                }
            }
        }
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            CoreDataService.deleteItem(with: watchList[indexPath.row])
            moviesViewModel?.movieList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toMovieDetailVC", sender: indexPath)

    }
    
}


extension WatchListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let filtered = moviesViewModel?.movieList.filter({ ($0.title?.contains(searchText) == true)}) {
    
            if filtered.count > 0 {
            moviesViewModel = MoviesViewModel(movieList: filtered)
            } else {
                fetchWatchList()
            }
        }
        movieTableView.reloadData()
    }
    
}
