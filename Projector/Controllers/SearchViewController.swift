//
//  SearchViewController.swift
//  Projector
//
//  Created by Fatih Gursoy on 11.02.2022.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var movieTableView: UITableView!
    
    private var moviesViewModel = MoviesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        searchBar.delegate = self
        hideKeyboard()

        movieTableView.register(UINib(nibName: "MovieTableCellView", bundle: nil), forCellReuseIdentifier: "MovieTableCell")
        
    }
    
    
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

//        WebService().searchMovies(searchQuery: searchText) { movies in
//            
//            guard let movies = movies?.results else {return}
//            
//            self.moviesViewModel = MoviesViewModel(movieList: movies)
//            
//            DispatchQueue.main.async {
//                self.movieTableView.reloadData()
//            }
//        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = moviesViewModel.count
        return count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as! MovieTableCell
        
//        if let movieViewModel = moviesViewModel?.movieAtIndex(indexPath.row) {
            
//            cell.movieTitle.text = movieViewModel.MovieTitle
//            cell.watchButton.isHidden = true
//
//            if let posterPath = movieViewModel.movie.posterPath {
//
//                cell.movieImage.sd_setImage(with: URL(string: API.ImageBaseURL+posterPath))
//            }
//
//            let rating = movieViewModel.movie.voteAverage ?? 0
//            cell.movieRating.text = String(describing: rating)
//            cell.accessoryType = .detailDisclosureButton
//            
//        }
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movieDetailVC = MovieDetailVC()
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
        movieDetailVC.movieViewModel = moviesViewModel.movieAtIndex(indexPath.row)
        
    }
    
    
}
    
