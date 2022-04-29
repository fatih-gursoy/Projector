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
        moviesViewModel.delegate = self
        
        hideKeyboard()

        movieTableView.register(UINib(nibName: "MovieTableCellView", bundle: nil), forCellReuseIdentifier: "MovieTableCell")
        
    }
    
    
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        moviesViewModel.fetchMovies(from: MovieDetailEndPoint.search(query: searchText))
        
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesViewModel.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as? MovieTableCell else { fatalError("Error") }
        
        cell.configure(viewModel: moviesViewModel.movieAtIndex(indexPath.row))
        
        
//            cell.watchButton.isHidden = true
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC else { fatalError("Error")}
                
        movieDetailVC.movieViewModel = moviesViewModel.movieAtIndex(indexPath.row)
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
        
    }
    
    
}

extension SearchViewController: MoviesViewModelDelegate {
    
    func updateMoviesView() {
        movieTableView.reloadData()
    }
    
    
    
}
    
