import UIKit

class HomeController: UIViewController,UITableViewDelegate {
    
    private var movies = [Movie]()
    private var currentPage = 1
    private let tableView = UITableView()
    private var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchPopularMovies()
        self.navigationItem.title = "Movies List"
        tableView.delegate = self // Set the delegate
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.rowHeight = 200
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func fetchPopularMovies() {
      
        guard !isFetching else { return }
        isFetching = true // Set flag to indicate fetch is in progress
        NetworkManager.shared.fetchPopularMovies(page:currentPage) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies.append(contentsOf: movies)
                self?.currentPage += 1
                self?.tableView.reloadData()
            case .failure(let error):
                AlertManager.showLoadingDataErrorAlert(on: self!)
                print("Failed to fetch movies: \(error)")
            }
            self?.isFetching = false
        }
    }
}

extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          
          let movie = movies[indexPath.row]
          cell.textLabel?.text = movie.title
          
        if let posterPath = movie.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 150))
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            imageView.load(url: posterURL)
            cell.accessoryView = imageView // Set as accessoryView
        }
          return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMovie = movies[indexPath.row]
        let detailsViewController = DetailsController()
        detailsViewController.movieId = selectedMovie.id
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
  
}

extension UIImageView {
    func load(url: URL?) {
        guard let url = url else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

extension HomeController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        let fetchThreshold = screenHeight * 0.8
        
        // Check if user has scrolled to the bottom (within a certain threshold)
        if offsetY > contentHeight - screenHeight - fetchThreshold {
            // Fetch more data
            fetchPopularMovies()
        }
    }
}
