//
//  RestaurantDetailsController.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit

class RestaurantDetailsController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    private let model: RestaurantDetailsViewModel
    
    init(model: RestaurantDetailsViewModel) {
        self.model = model
        super.init(nibName: Self.identifier, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        model.fetchReviews()
        tableView.reloadData()
    }
    
    // MARK: - Private
    private func configure() {
        titleLabel.text = model.restaurant.name
        ratingLabel.text = model.restaurant.displayRating
        
        ratingLabel.textColor = {
            guard model.restaurant.rating < 4 else { return .accent }
            return model.restaurant.rating > 3 ? .main : .red
        }()
        
        ratingLabel.font = .systemFont(ofSize: 24)
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.registerCelNib(ReviewTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = .init(vertical: 15, horizonal: 0)
        tableView.rounded(radius: 10)
        tableView.bordered(width: 0.35)
    }
}

// MARK: - UITableViewDataSource
extension RestaurantDetailsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(ReviewTableViewCell.self, for: indexPath) else { return .init() }
        
        let (variant, review) = model.data[indexPath.row]
        cell.configure(variant: variant, rating: review.rating.asFormattedStringDouble, comment: review.comment, date: review.date.shortPretty)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RestaurantDetailsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        ReviewTableHeaderView(text: model.filterButtonText, delegate: self)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard model.isAdmin else { return nil }
        
        let delete = UIContextualAction.delete { [weak self] in
            self?.model.didTapDelete(at: indexPath.row)
            self?.onMain { self?.tableView.reloadData() }
            
            return true
        }
        
        let edit = UIContextualAction.edit { [weak self] in
            self?.model.didTapEdit(at: indexPath.row)
            return true
        }
        
        return .init(actions: [delete, edit])
    }
}

// MARK: - ReviewTableHeaderViewDelegate
extension RestaurantDetailsController: ReviewTableHeaderViewDelegate {
    func didTapButton(_ sender: ReviewTableHeaderView) {
        model.didTapFilterButton()
        tableView.reloadData()
    }
}
