//
//  MoreMoviesVC.swift
//  Projector
//
//  Created by Fatih Gursoy on 23.02.2022.
//

import UIKit

class MoreMoviesVC: UIViewController {

    @IBOutlet private weak var movieTableView: UITableView!
    
    private var moviesViewModel = MoviesViewModel()
    var movieId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        movieTableView.register(UINib(nibName: "MovieTableCellView", bundle: nil), forCellReuseIdentifier: "MovieTableCell")

        fetchMovies()
    }
    
    
    func fetchMovies() {
                
//        WebService().downloadSimilarMovies(movieId: movieId!) { movies in
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

extension MoreMoviesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = moviesViewModel.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as? MovieTableCell else { fatalError("Could not load") }
        
        let movieViewModel = moviesViewModel.movieAtIndex(indexPath.row)
        
        cell.configure(viewModel: movieViewModel)
        
            
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

        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toMovieDetailVC", sender: indexPath)
        
        let movieDetailVC = MovieDetailVC()
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
        movieDetailVC.movieViewModel = moviesViewModel.movieAtIndex(indexPath.row)
    }
    

    
    
    
}
