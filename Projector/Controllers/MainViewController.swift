
import UIKit
import SDWebImage
import AnimatedCollectionViewLayout
import Alamofire

class MainViewController: UIViewController {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private var moviesViewModel: MoviesViewModel?
    private var genreViewModel: GenreViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerCollectionView.delegate = self
        genreCollectionView.delegate = self
        moviesCollectionView.delegate = self
        
        headerCollectionView.dataSource = self
        genreCollectionView.dataSource = self
        moviesCollectionView.dataSource = self
        
        genreCollectionView.allowsMultipleSelection = true
        
        headerCollectionView.register(UINib(nibName: "HeaderCellView", bundle: nil), forCellWithReuseIdentifier: "HeaderCell")
        genreCollectionView.register(UINib(nibName: "GenreCellView", bundle: nil), forCellWithReuseIdentifier: "GenreCell")
        moviesCollectionView.register(UINib(nibName: "MovieCellView", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(toSearchVC))
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        fetchMovieList(listName: Header.nowPlaying.rawValue)
        fetchGenres()
        collectionViewAnimate()
   
    }
    
    @objc func toSearchVC() {
        
        performSegue(withIdentifier: "toSearchVC", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        headerCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        let cell = headerCollectionView.cellForItem(at: indexPath) as! HeaderCell
        cell.headerLabel.textColor = .black
        cell.headerLabel.font = .boldSystemFont(ofSize: 20)
  
    }
    
    func collectionViewAnimate() {
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator()
        layout.scrollDirection = .horizontal
        
        moviesCollectionView.collectionViewLayout = layout
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                
        if segue.identifier == "toMovieDetail"  {
            
            let vc = segue.destination as! MovieDetailVC
            let indexPath = sender as! IndexPath
                        
            vc.movieId = moviesViewModel?.movieAtIndex(indexPath.row).id

        }
    }

    
    func fetchMovieList(listName: String) {
        
        WebService().downloadMovies(listName: listName) { movies in
            
            guard let movies = movies?.results else {return}
            
            self.moviesViewModel = MoviesViewModel(movieList: movies)
            
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
    }
    
    
    func fetchGenres() {
        
        WebService().downloadGenres { genreList in
            guard let genreList = genreList else {return}
            
            self.genreViewModel = GenreViewModel(genreList: genreList.genres)

            DispatchQueue.main.async {
                self.genreCollectionView.reloadData()
            }
        }
    }
    
    
}


extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case headerCollectionView:
            
            return Header.allCases.count
            
        case genreCollectionView:
            
            guard let count = genreViewModel?.genreList?.count else {return 0}
            return count
            
        case moviesCollectionView:
            
            guard let count = moviesViewModel?.movieList.count else {return 0}
            return count
            
        default:
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case headerCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            
            cell.headerLabel.text = Header.allCases[indexPath.row].headerTitle
            
            return cell
            
        case genreCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as! GenreCell

            if let genre = genreViewModel?.genreList?[indexPath.row] {
                
                cell.genreLabel.text = genre.name

                if genre.isSelected == false || genre.isSelected == nil {
                    cell.backView.backgroundColor = .clear
                    cell.genreLabel.textColor = .black
                } else if genre.isSelected == true {
                    cell.backView.backgroundColor = .darkGray
                    cell.genreLabel.textColor = .white
                }
            }
        
            return cell
            
        case moviesCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell

            if let movieViewModel = moviesViewModel?.movieAtIndex(indexPath.row) {
                
                cell.movieTitleLabel.text = movieViewModel.MovieTitle

                if let posterPath = movieViewModel.movie.posterPath {

                    cell.movieImageView.sd_setImage(with: URL(string: API.ImageBaseURL+posterPath))
                }

                let rating = movieViewModel.movie.voteAverage ?? 0
                cell.ratingLabel.text = String(describing: rating)
                
            }
            
            cellLayout(cell.movieImageView)
            
            return cell
            
        default:
            
            return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {

        case headerCollectionView:
            
            let item = Header.allCases[indexPath.row].headerTitle

            let itemWidth = (item.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)]).width) + 40
            
            let itemHeight = collectionView.bounds.height * 0.5
                        
            return CGSize(width: itemWidth, height: itemHeight)
            
        case genreCollectionView:
            
            let item = genreViewModel?.genreList?[indexPath.row].name

            let itemWidth = (item?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width)! + 40
            
            let itemHeight = collectionView.bounds.height * 0.5
                        
            return CGSize(width: itemWidth, height: itemHeight)

        case moviesCollectionView:
            
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height

            return CGSize(width: itemWidth, height: itemHeight)
            
        default:
            
            return CGSize()
            
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var headerIndex = Int()
        
        if collectionView == moviesCollectionView {
            performSegue(withIdentifier: "toMovieDetail", sender: indexPath)
        }
        
        if collectionView == headerCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath) as! HeaderCell

            cell.headerLabel.textColor = .black
            cell.headerLabel.font = .boldSystemFont(ofSize: 20)

            headerIndex = indexPath.row
            fetchMovieList(listName: Header.allCases[headerIndex].rawValue)
        }
        
        if collectionView == genreCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath) as! GenreCell
            
            genreViewModel?.selectGenreAtIndex(indexPath.row)

            cell.backView.backgroundColor = .darkGray
            cell.genreLabel.textColor = .white
                        
            var selectedGenres = [Genre]()
            
            if let indexPaths = collectionView.indexPathsForSelectedItems {
                
                for indexPath in indexPaths {
                    
                    if let genre = genreViewModel?.genreList?[indexPath.row] {
                        if genre.isSelected == true {
                            selectedGenres.append(genre)
                        }
                    }
                }
            }
            
            guard let filteredMovies = moviesViewModel?.filterByGenre(selectedGenres) else {return}
            
            if selectedGenres.count > 0 {
                moviesViewModel = MoviesViewModel(movieList: filteredMovies)
            } else {
                fetchMovieList(listName: Header.allCases[headerIndex].rawValue)
            }
            
                
            moviesCollectionView.reloadData()
            collectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == headerCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath) as! HeaderCell
            cell.headerLabel.textColor = .lightGray
            cell.headerLabel.font = .systemFont(ofSize: 20)
            
        }
        
        if collectionView == genreCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath) as! GenreCell

            cell.backView.backgroundColor = .clear
            cell.genreLabel.textColor = .black

            if collectionView.indexPathsForSelectedItems?.count == 0 {
                guard let indexPath = headerCollectionView.indexPathsForSelectedItems?.first else {return}
                fetchMovieList(listName: Header.allCases[indexPath.row].rawValue)
            }
        }
        
    }
    
    
}

