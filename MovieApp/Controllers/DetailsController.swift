import UIKit

class DetailsController: UIViewController {
    var movieId: Int!
    
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let ratingLabel = UILabel()
    private let posterImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchMovieDetails()
    }
    private func setupViews() {
        view.backgroundColor = .white
        
        // Movie poster image view
       
        posterImageView.contentMode = .scaleToFill
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(posterImageView)
        
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        
        overviewLabel.numberOfLines = 0
        
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, overviewLabel, releaseDateLabel, ratingLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // Constraints for poster image view
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            posterImageView.heightAnchor.constraint(equalToConstant: 300) // Adjust height as needed
        ])
        
        // Constraints for stack view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    
    private func fetchMovieDetails() {
        NetworkManager.shared.fetchMovieDetails(movieId: movieId) { [weak self] result in
            switch result {
            case .success(let movieDetail):
                self?.titleLabel.text = movieDetail.title
                self?.overviewLabel.text = movieDetail.overview
                self?.releaseDateLabel.text = "Release Date: \(movieDetail.releaseDate)"
                self?.ratingLabel.text = "Rating: \(movieDetail.rating)"
                if let posterPath = movieDetail.posterPath {
                    let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
                    self?.posterImageView.load(url: posterURL)
                }
            case .failure(let error):
                AlertManager.showLoadingDataErrorAlert(on: self!)
                print("Failed to fetch movie details: \(error)")
            }
        }
    }
}
