//
//  ReviewTableViewCell.swift
//  SampleApp
//
//  Created by Daniel Velikov on 15.02.24.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var commentLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    // MARK: - Private
    private func configure() {
        selectionStyle = .none
        
        ratingLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        commentLabel.font = .systemFont(ofSize: 16, weight: .light)
        dateLabel.font = .systemFont(ofSize: 12, weight: .thin)
        
        commentLabel.numberOfLines = 0
    }
    
    // MARK: - Public
    func configure(variant: ReviewVariant, rating: String, comment: String, date: String) {
        iconImageView.image = .init(systemName: variant.imageName)?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = variant.tintColor
        
        ratingLabel.textColor = variant.tintColor
        ratingLabel.text = rating
        
        commentLabel.text = comment.isEmpty ? "No comment left by user" : comment
        dateLabel.text = date
    }
}
