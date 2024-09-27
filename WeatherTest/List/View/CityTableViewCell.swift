//
//  CityTableViewCell.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import UIKit

final class CityTableViewCell: UITableViewCell {
    static let reuseID = "CityTableViewCell"

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var coordinatesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with city: CityViewModel) {
        nameLabel.attributedText = city.nameCity
        coordinatesLabel.attributedText = city.coordinates
        temperatureLabel.attributedText = city.temperature
    }
}

private extension CityTableViewCell {
    func setupLabel() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, temperatureLabel, coordinatesLabel])
        let padding: CGFloat = 20
    
        stackView.spacing = padding
        stackView.axis = .horizontal

        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
       ])
    }
}
