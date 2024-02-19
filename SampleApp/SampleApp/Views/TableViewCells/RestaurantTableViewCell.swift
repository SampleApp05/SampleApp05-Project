//
//  RestaurantTableViewCell.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit

protocol RestaurantTableViewCellDelegate: AnyObject {
    func didTapFeedbackButton(for restaurant: Restaurant)
}

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet private var containerStackView: UIStackView!
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var ratingStackView: UIStackView!
    @IBOutlet private var feedbackButton: UIButton!
    
    private weak var delegate: RestaurantTableViewCellDelegate?
    private var restaurant: Restaurant!
    
    private var imageClosure: ItemClosure<UIImageView>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageClosure = nil
    }
    
    // MARK: - Private
    private func configure() {
        selectionStyle = .none
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .regular)
        ratingLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        feedbackButton.setTitle("Rate it now!", for: .normal)
        updateAppearance()
    }
    
    // MARK: - Private
    private func updateAppearance() {
        containerStackView.backgroundColor = .main.withAlphaComponent(0.45)
        containerStackView.rounded(radius: 10)
        
        nameLabel.textColor = .accent
        ratingLabel.textColor = .accent
        
        ratingStackView.bordered(width: 1, color: .main)
        ratingStackView.rounded()
        
        feedbackButton.setTitleColor(.main, for: .normal)
        feedbackButton.backgroundColor = .accent
        feedbackButton.rounded()
    }
    
    // MARK: - Public
    func configure(with data: Restaurant, delegate: RestaurantTableViewCellDelegate?, imageClosure: @escaping ItemClosure<UIImageView>) {
        restaurant = data
        nameLabel.text = data.name
        ratingLabel.text = String(data.rating)
        
        self.delegate = delegate
        
        self.imageClosure = imageClosure
        self.imageClosure?(logoImageView)
    }
    
    // MARK: - Actions
    @IBAction private func didTapFeedbackButton(_ sender: UIButton) {
        delegate?.didTapFeedbackButton(for: restaurant)
    }
}
