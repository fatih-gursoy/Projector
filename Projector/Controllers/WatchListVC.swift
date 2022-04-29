//
//  WatchListVC.swift
//  Projector
//
//  Created by Fatih Gursoy on 8.02.2022.
//

import UIKit

class WatchListVC: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var movieTableView: UITableView!
    
    private var coreDataManager = CoreDataManager()
    private var moviesViewModel = MoviesViewModel()
    
    private let notificationCenter: NotificationCenter = NotificationCenter.default
        
    override func viewDidLoad() {
        super.viewDidLoad()

        movieTableView.delegate = self
        movieTableView.dataSource = self
        searchBar.delegate = self
        
        hideKeyboard()
        
        movieTableView.register(UINib(nibName: "MovieTableCellView", bundle: nil), forCellReuseIdentifier: "MovieTableCell")
                
        notificationCenter.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name("UpdateWatchList") , object: nil)

        fetchWatchList()
        moviesViewModel.delegate = self

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    
    func fetchWatchList() {

        let watchList = coreDataManager.watchList
        moviesViewModel.movieList.removeAll(keepingCapacity: false)
        
        for movie in watchList {
            guard let movieId = movie.movieId else { return }
            moviesViewModel.addMovie(movieId: movieId)
        }
        movieTableView.reloadData()
        
    }
    
    @objc func updateUI() {
        fetchWatchList()
    }

}

extension WatchListVC: MoviesViewModelDelegate {
    
    func updateMoviesView() {
        movieTableView.reloadData()
    }
    
}


extension WatchListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return moviesViewModel.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as? MovieTableCell else { fatalError("Could not load") }
            
        let movieViewModel = moviesViewModel.movieAtIndex(indexPath.row)
        cell.configure(viewModel: movieViewModel)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let movie = coreDataManager.watchList[indexPath.row]
            coreDataManager.deleteMovie(with: movie)
            moviesViewModel.movieList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didselect")
        
        guard let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC else { fatalError("Error")}
                
        movieDetailVC.movieViewModel = moviesViewModel.movieAtIndex(indexPath.row)
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
                
    }
    
}


extension WatchListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let filtered = moviesViewModel.movieList.filter({ ($0.title?.contains(searchText) == true)})
    
        if filtered.count > 0 {
//        moviesViewModel = MoviesViewModel(movieList: filtered)
        } else {
            fetchWatchList()
        }
        
        movieTableView.reloadData()
    }
    
}
