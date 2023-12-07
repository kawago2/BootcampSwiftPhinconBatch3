import UIKit

class LoadingViewController: BaseViewController {
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        return activityIndicator
    }()

    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Inter-Regular", size: 14)
        label.text = "Please wait, content of the page is loading..."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(named: "Primary")

        view.addSubview(activityIndicatorView)
        view.addSubview(loadingLabel)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 10),
            loadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        activityIndicatorView.startAnimating()
    }
}
