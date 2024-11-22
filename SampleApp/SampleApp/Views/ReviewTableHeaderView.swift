//
//  ReviewTableHeaderView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 17.02.24.
//

import UIKit

protocol ReviewTableHeaderViewDelegate: UIViewController {
    func didTapButton(_ sender: ReviewTableHeaderView)
}

class ReviewTableHeaderView: UITableViewHeaderFooterView {
    private let text: String
    private let button = UIButton(frame: .zero)
    weak var delegate: ReviewTableHeaderViewDelegate?
    
    init(text: String, delegate: ReviewTableHeaderViewDelegate?) {
        self.text = text
        self.delegate = delegate
        super.init(reuseIdentifier: Self.identifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func configure() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        
        button.setTitle(text)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .accent
        button.setTitleColor(.main, for: .normal)
//        button.contentEdgeInsets = .init(vertical: 10, horizonal: 10)
        button.rounded(radius: 10)
    }
    
    //MARK: - Actions
    @objc
    private func didTapFilterButton(_ sender: UIButton) {
        delegate?.didTapButton(self)
    }
}
