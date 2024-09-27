//
//  DetailViewController.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    private let output: DetailViewOutput

    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var coordinatesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var forecastButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Get forecast for 3 days", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        let padding: CGFloat = 30
        button.configuration = .bordered()
        let color = CGColor(gray: 0.95, alpha: 1.0)
        button.backgroundColor = UIColor(cgColor: color)
        button.layer.backgroundColor = color
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapShowForecastButton), for: .touchUpInside)
        return button
    }()

    private var forecastStackView = UIStackView()

    init(output: DetailViewOutput) {
        self.output = output

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        output.didLoadView()
    }
}

extension DetailViewController: DetailViewInput {
    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func forecast(hide: Bool) {
        if hide {
            forecastStackView.removeFromSuperview()
        }
    }

    func showError(with title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {
            _ in self.hideLoading()
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func configure(with model: CityViewModel, _ forecast: ForecastViewModel? = nil) {
        nameLabel.attributedText = model.nameCity
        coordinatesLabel.attributedText = model.coordinates
        currentTemperatureLabel.attributedText = model.temperature

        if let forecast = forecast {
            let labels = forecast.dayTemperatures.map { generateLabel(text: $0) }
            self.forecastStackView = UIStackView(arrangedSubviews: labels)
            setupForecast(padding: 20)
        }
    }
}

private extension DetailViewController {
    @objc
    func didTapShowForecastButton() {
        output.didTapForecastButton()
    }

    func setup() {
        view.backgroundColor = .white

        let padding: CGFloat = 20
        setupMainLabels(padding: padding)
        setupAdditionalInfo(padding: padding)
    }

    func setupMainLabels(padding: CGFloat) {
        [activityIndicator, nameLabel, coordinatesLabel, currentTemperatureLabel, forecastButton].forEach {
            view.addSubview($0)
        }

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            coordinatesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            coordinatesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            currentTemperatureLabel.topAnchor.constraint(equalTo: coordinatesLabel.bottomAnchor, constant: padding),
            currentTemperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func setupAdditionalInfo(padding: CGFloat) {
        let labels = output.additionalInfo.map { generateLabel(text: $0) }
        let stackView = UIStackView(arrangedSubviews: labels)

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: padding),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            forecastButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            forecastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func setupForecast(padding: CGFloat) {
        view.addSubview(forecastStackView)
        forecastStackView.translatesAutoresizingMaskIntoConstraints = false
        forecastStackView.axis = .vertical

        NSLayoutConstraint.activate([
            forecastStackView.topAnchor.constraint(equalTo: forecastButton.bottomAnchor, constant: padding),
            forecastStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func generateLabel(text: NSAttributedString) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = text
        return label
    }
}
