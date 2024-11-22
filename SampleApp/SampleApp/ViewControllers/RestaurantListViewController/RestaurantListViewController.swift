//
//  RestaurantListViewController.swift
//  SampleApp
//
//  Created by Daniel Velikov on 5.02.24.
//

import UIKit

protocol RestaurantViewModelDelegate: UIViewController {
    func shouldReloadData()
}

class RestaurantListViewController: UIViewController, CoordinatorModelController {
    private let refreshControl = UIRefreshControl()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.color = .accent
        return indicator
    }()
    
    @IBOutlet private var tableView: UITableView!
    
    private var isLoading = false {
        didSet {
            guard isLoading != oldValue else { return }
            
            if isLoading {
                view.addSubview(loadingIndicator)
                NSLayoutConstraint.activate([
                    loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
                loadingIndicator.startAnimating()
            } else {
                loadingIndicator.removeFromSuperview()
            }
        }
    }
    
    let model: RestaurantsViewModel
    
    private func deleteAction(for row: Int) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else {
                completion(false)
                return
            }
            
            model.deleteRestaurant(at: row)
            tableView.reloadData()
            completion(model.requestStatus == .success)
        }
        action.image = .init(systemName: "trash")
        action.backgroundColor = .systemRed
        
        return action
    }
    
    init(model: RestaurantsViewModel) {
        self.model = model
        super.init(nibName: Self.identifier, bundle: .main)
        
        self.model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        isLoading = true
        Task { await model.fetchRestaurants() }
    }
    
    // MARK: - Private
    private func configure() {
        configureTableView()
        
        if model.injected.account?.isAdmin == true {
            navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        }
    }
    
    private func configureTableView() {
        tableView.registerCelNib(RestaurantTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - Actions
    @objc
    private func didTapAddButton(_ sender: UIBarButtonItem) {
        model.didTapAddButton()
    }
    
    @objc
    private func didPullToRefresh(_ sender: UIRefreshControl) {
        guard sender.isRefreshing else {
            refreshControl.endRefreshing()
            return
        }
        
        refreshControl.beginRefreshing()
        Task { await model.fetchRestaurants() }
    }
}

// MARK: - UITableViewDataSource
extension RestaurantListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isLoading ? 0 : model.restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(RestaurantTableViewCell.self, for: indexPath) else { return .init() }
        
        let data = model.restaurants[indexPath.row]
        cell.configure(with: data, delegate: self) { [weak self] (imageView) in
            Task {
                guard let image = await self?.model.fetchPhoto(for: data.url) else { return }
                imageView.image = image
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RestaurantListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        model.didTapCell(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard model.injected.account?.isAdmin == true else { return nil }
        
        let delete = UIContextualAction.delete { [weak self] in
            self?.model.deleteRestaurant(at: indexPath.row)
            self?.onMain {
                self?.tableView.reloadData()
            }
            
            return self?.model.requestStatus == .success
        }
        
        let edit = UIContextualAction.edit { [weak self] in
            self?.model.editRestaurant(at: indexPath.row)
            return true
        }
        
        return .init(actions: [delete, edit])
    }
}

// MARK: - RestaurantViewModelDelegate
extension RestaurantListViewController: RestaurantViewModelDelegate {
    func shouldReloadData() {
        onMain { [weak self] in
            self?.isLoading = false
            self?.tableView.reloadData()
        }
    }
}

// MARK: - RestaurantTableViewCellDelegate
extension RestaurantListViewController: RestaurantTableViewCellDelegate {
    func didTapFeedbackButton(for restaurant: Restaurant) {
        model.coordinator?.navigate(to: .feedback(restaurant: restaurant))
    }
}
