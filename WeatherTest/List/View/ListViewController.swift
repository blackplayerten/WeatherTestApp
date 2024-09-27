//
//  ListViewController.swift
//  WeatherTest
//
//  Created by Alexandra Kurganova on 27.09.2024.
//

import UIKit

final class ListViewController: UIViewController {
    private let output: ListViewOutput

    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Input city name"
        search.searchBar.delegate = self
        return search
    }()

    private lazy var table: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.reuseID)
        return tableView
    }()

    init(output: ListViewOutput) {
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

extension ListViewController: ListViewInput {
    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func showTable(is show: Bool) {
        table.isHidden = !show
    }

    func showError(with title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in
            self.hideLoading()
            self.showTable(is: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func configure() {
        table.reloadData()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = output.item(at: indexPath.row)
        output.didTapShowCityInfo(city: city)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        output.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseID, for: indexPath) as? CityTableViewCell else {
            return UITableViewCell()
        }
        let city = output.item(at: indexPath.row)
        cell.configure(with: city)
        return cell
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        output.didTapSearchButton(with: searchText)
    }
}

private extension ListViewController {
    func setup() {
        view.backgroundColor = .white
        navigationItem.searchController = searchController

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        view.addSubview(table)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
