//
//  MovieDetailVC.swift
//  Projector
//
//  Created by Fatih Gursoy on 4.02.2022.
//

import UIKit
import CoreData
import SDWebImage

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    var movieViewModel: MovieViewModel?
    var creditsViewModel: CreditsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        castCollectionView.delegate = self
        castCollectionView.dataSource = self
        
        genreCollectionView.register(UINib(nibName: "GenreCellView", bundle: nil), forCellWithReuseIdentifier: "GenreCell")
        
        castCollectionView.register(UINib(nibName: "CastCellView", bundle: nil), forCellWithReuseIdentifier: "CastCell")
        
        fetchData()
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        cellLayout(movieImage)
        movieImage.layer.maskedCorners = [.layerMinXMaxYCorner]
        
        cardView.layer.cornerRadius = 40.0
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cardView.layer.shadowRadius = 10.0
        cardView.layer.shadowOpacity = 0.7
        cardView.layer.masksToBounds = false
        
        moreButton.titleLabel?.numberOfLines = 0
        moreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    
    func fetchData() {
        
        guard let movieViewModel = movieViewModel else {return}
        
        if let photoURL = movieViewModel.backdropURL {
            movieImage.sd_setImage(with: URL(string: API.backdropBaseURL+photoURL))
        }
        
        overviewText.text = movieViewModel.movie.overview
        movieNameLabel.text = movieViewModel.MovieTitle
        ratingLabel.text = "\(movieViewModel.rating)"
        yearLabel.text = movieViewModel.year
        voteCountLabel.text = "\(movieViewModel.voteCount) votes"
        
        guard let movieId = movieViewModel.id else {return}

        WebService().downloadMovieDetail(movieId: movieId ) { movie in
            
            guard let movie = movie else {return}
            self.movieViewModel = MovieViewModel(movie: movie)
            guard let movieViewModel = self.movieViewModel else {return}
            
            DispatchQueue.main.async {
                self.genreCollectionView.reloadData()
                self.runTimeLabel.text = "\(movieViewModel.runTime) min"

            }
        }
        
        WebService().downloadCredits(movieId: movieId) { credits in
            guard let credits = credits else {return}
            self.creditsViewModel = CreditsViewModel(cast: credits.cast, crew: credits.crew)
            
            DispatchQueue.main.async {
                self.castCollectionView.reloadData()
            }
        }
    }
    
    
    
    @IBAction func addButtonClicked(_ sender: Any) {

        let items = CoreService().fetchWatchList()
        let context = CoreDataModel.context
        
        if items.count < 1 {
            
            let newMovie = NSEntityDescription.insertNewObject(forEntityName: CoreDataModel.entitiyName, into: context)
            
            newMovie.setValue(movieViewModel?.id, forKey:"movieId")
            
        } else {
            
            if !(items.contains(where: { $0.movieId == movieViewModel?.id})) {
                let newMovie = NSEntityDescription.insertNewObject(forEntityName: CoreDataModel.entitiyName, into: context)
                
                newMovie.setValue(movieViewModel?.id, forKey:"movieId")
            } else {
                makeAlert(titleString: "The movie exists in Watch List", messageString: "")
            }
        }
        
        do {
           try context.save()
            
            makeAlert(titleString: "Added to Watch List", messageString: "")
            
        } catch {
            print(error.localizedDescription)
        }
    }


}

extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case genreCollectionView:
            return movieViewModel?.movie.genres?.count ?? 0
    
        case castCollectionView:
            
            return creditsViewModel?.cast.count ?? 0
            
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case genreCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as! GenreCell

            cell.genreLabel.text = movieViewModel?.movie.genres?[indexPath.row].name

            return cell
         
        case castCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCell

            cell.castName.text = creditsViewModel?.cast[indexPath.row].name
            cell.castRole.text = creditsViewModel?.cast[indexPath.row].character
            
            if let photoURL = creditsViewModel?.cast[indexPath.row].profilePath {
                cell.castImage.sd_setImage(with: URL(string: API.ImageBaseURL+photoURL))
            }
            
            return cell
            
        default:
            
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
            
        case genreCollectionView:
            guard let item = movieViewModel?.movie.genres?[indexPath.row].name else {return CGSize()}
            
            let itemWidth = (item.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width) + 40
            let itemHeight = collectionView.bounds.height * 0.5
                        
            return CGSize(width: itemWidth, height: itemHeight)
            
        case castCollectionView:
            
            let itemWidth = collectionView.bounds.width * 0.25
            let itemHeight = collectionView.bounds.height

            return CGSize(width: itemWidth, height: itemHeight)
            
        default:
            
            return CGSize()
        }
        
    }
    
    
    
}
