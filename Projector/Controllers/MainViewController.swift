
import UIKit
import AnimatedCollectionViewLayout

class MainViewController: UIViewController {
    
    @IBOutlet private weak var headerCollectionView: UICollectionView!
    @IBOutlet private weak var genreCollectionView: UICollectionView!
    @IBOutlet private weak var moviesCollectionView: UICollectionView!
    
    private var moviesViewModel = MoviesViewModel()
    private var genresViewModel = GenresViewModel()
            
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        configureCollectionView()
        
        fetchMovieList(endpoint: .nowPlaying)
        fetchGenres()
        
    }
    
    
    func configureNavBar() {
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(toSearchVC))
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
    }
    
    @objc func toSearchVC() {
        
        guard let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as? SearchViewController else { fatalError("Error")}
        
        self.navigationController?.pushViewController(searchVC, animated: true)

    }
    
    func configureCollectionView() {
        
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
        
        // Movie Collection Animation
        
        let layout = AnimatedCollectionViewLayout()
        layout.animator = LinearCardAttributesAnimator()
        layout.scrollDirection = .horizontal
        moviesCollectionView.collectionViewLayout = layout
        
    }
    
    func fetchMovieList(endpoint: MoviesEndPoint) {
        
        moviesViewModel.delegate = self
        moviesViewModel.fetchMovies(from: endpoint)
        
    }

    func fetchGenres() {
        
        genresViewModel.delegate = self
        genresViewModel.fetchGenres()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        headerCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        // İlk değer default seçili yapılacak ??
    
    }
    
    
}

extension MainViewController: MoviesViewModelDelegate, GenresViewModelDelegate {
    
    func updateMoviesView() {
        self.moviesCollectionView.reloadData()
    }
    
    func updateGenreView() {
        self.genreCollectionView.reloadData()
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case headerCollectionView:
            
            return MoviesEndPoint.allCases.count
            
        case genreCollectionView:
            
            let count = genresViewModel.genreList.count
            return count
            
        case moviesCollectionView:
            
            let count = moviesViewModel.count
            return count
            
        default:
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case headerCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as? HeaderCell else { fatalError("Could not load") }
            
            cell.configure(MoviesEndPoint.allCases[indexPath.row].headerTitle)
            
            return cell
            
        case genreCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as? GenreCell else { fatalError("Could not load") }

            cell.configure(viewModel: genresViewModel.genreAtIndex(indexPath.row))
        
            return cell
            
        case moviesCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else { fatalError("Could not load") }
            
            cell.configure(viewModel: moviesViewModel.movieAtIndex(indexPath.row))
                        
            return cell
            
        default:
            
            return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {

        case headerCollectionView:
            
            let item = MoviesEndPoint.allCases[indexPath.row].headerTitle

            let itemWidth = (item.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)]).width) + 40
            
            let itemHeight = collectionView.bounds.height * 0.5
                        
            return CGSize(width: itemWidth, height: itemHeight)
            
        case genreCollectionView:
            
            let item = genresViewModel.genreList[indexPath.row].name

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
                        
        if collectionView == headerCollectionView {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? HeaderCell else { fatalError("Could not load") }
            
            cell.didSelect(indexPath.row)
            fetchMovieList(endpoint: MoviesEndPoint.allCases[indexPath.row])

        }
        
        if collectionView == genreCollectionView {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? GenreCell else { fatalError("Could not load") }
            
            genresViewModel.selectGenreAtIndex(indexPath.row)
            cell.didSelect(viewModel: genresViewModel.genreAtIndex(indexPath.row))
            
            let selectedGenres = genresViewModel.genreList.filter { $0.isSelected == true }
            
            let filteredMovies = moviesViewModel.filterByGenre(selectedGenres)
            moviesViewModel.movieList = filteredMovies
            
            moviesCollectionView.reloadData()
        }
        
        if collectionView == moviesCollectionView {
                        
            guard let movieDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC else { fatalError("Error")}
                    
            movieDetailVC.movieViewModel = moviesViewModel.movieAtIndex(indexPath.row)
            self.navigationController?.pushViewController(movieDetailVC, animated: true)

        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == headerCollectionView {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? HeaderCell else { fatalError("Could not load") }
            
            cell.didDeselect(indexPath.row)
            
        }
        
        if collectionView == genreCollectionView {
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? GenreCell else { fatalError("Could not load") }
            
            genresViewModel.selectGenreAtIndex(indexPath.row)
            cell.didDeSelect(viewModel: genresViewModel.genreAtIndex(indexPath.row))
            
            if collectionView.indexPathsForSelectedItems?.count == 0 {
                guard let indexPath = headerCollectionView.indexPathsForSelectedItems?.first else {return}
                fetchMovieList(endpoint: MoviesEndPoint.allCases[indexPath.row])
            }
        }
        
    }
    
    
}

