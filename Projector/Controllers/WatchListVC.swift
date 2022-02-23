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
    
    private var moviesViewModel: MoviesViewModel?
    var movieIdList = [WatchList]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        searchBar.delegate = self
        hideKeyboard()
        
        movieTableView.register(UINib(nibName: "MovieTableCellView", bundle: nil), forCellReuseIdentifier: "MovieTableCell")
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        
        fetchWatchList()
    
    }
    
    func fetchWatchList() {

        movieIdList = CoreService().fetchWatchList()
        
        moviesViewModel = MoviesViewModel(movieList: [])
        
        for item in movieIdList {
            
            if let movieId = item.movieId {
                
                WebService().downloadMovieDetail(movieId: movieId) { movie in
                    guard let movie = movie else {return}
                    
                    self.moviesViewModel?.addMovie(movie: movie)
                    
                    DispatchQueue.main.async {
                        self.movieTableView.reloadData()
                    }
                }
            }
        }
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
            cell.addButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            cell.addButton.setImage(UIImage(systemName: "questionmark"), for: .normal)

            
            
        }
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            CoreService().deleteItem(with: movieIdList[indexPath.row])
            CoreService().saveToCoreData()
            fetchWatchList()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toMovieDetailVC", sender: indexPath)

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "toMovieDetailVC" {

            let vc = segue.destination as! MovieDetailVC
            let indexPath = sender as! IndexPath
            vc.movieViewModel = moviesViewModel?.movieAtIndex(indexPath.row)

        }
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
