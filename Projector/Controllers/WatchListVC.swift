//
//  WatchListVC.swift
//  Projector
//
//  Created by Fatih Gursoy on 8.02.2022.
//

import UIKit
import CoreData

class WatchListVC: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var movieTableView: UITableView!
    
    var CoreDataService = CoreService()
    var watchList = [WatchList]()

    private var moviesViewModel = MoviesViewModel()
        
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func fetchWatchList() {

        watchList = CoreService().watchList

        for item in watchList {
            
            if let movieId = item.movieId {
                
//                WebService().downloadMovieDetail(movieId: movieId) { movie in
//                    guard let movie = movie else {return}
//                    
//                    var movieViewModel = MovieViewModel(movie: movie)
//                    movieViewModel.updateWatchStatus()
//                    self.moviesViewModel?.addMovie(movie: movieViewModel.movie)
//
//                    DispatchQueue.main.async {
//                        self.movieTableView.reloadData()
//                    }
//                }
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
        
        let count = moviesViewModel.count
        return count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableCell", for: indexPath) as? MovieTableCell else { fatalError("Could not load") }
            
        let movieViewModel = moviesViewModel.movieAtIndex(indexPath.row)
        cell.configure(viewModel: movieViewModel)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            CoreDataService.deleteItem(with: watchList[indexPath.row])
            moviesViewModel.movieList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toMovieDetailVC", sender: indexPath)

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
