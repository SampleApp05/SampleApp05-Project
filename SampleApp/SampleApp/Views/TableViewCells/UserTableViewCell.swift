//
//  UserTableViewCell.swift
//  SampleApp
//
//  Created by Daniel Velikov on 18.02.24.
//

import UIKit

protocol UserTableViewDelegate: UIViewController {
    func didTapUpdateButton(_ sender: UserTableViewCell, index: IndexPath, alias: String, isAdmin: Bool)
}

class UserTableViewCell: UITableViewCell {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var aliasLabel: UILabel!
    @IBOutlet private var hasAdminPriviligesLabel: UILabel!
    @IBOutlet private var aliasTextField: UITextField!
    @IBOutlet private var isAdminSwitch: UISwitch!
    @IBOutlet private var updateButton: UIButton!
    
    private var indexPath: IndexPath = .init(index: 0)
    private var alias: String = ""
    private var isAdmin = false
    
    weak var delegate: UserTableViewDelegate?
    
    private func updateButtonState(enabled: Bool? = nil) {
        let enabled: Bool = enabled ?? {
            guard let newAlias = aliasTextField.text else { return false }
            return newAlias != alias || isAdminSwitch.isOn != isAdmin
        }()
        
        updateButton.isEnabled = enabled
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.updateButton.alpha = enabled ? 1.0 : 0.65
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }
    
    // MARK: - Private
    private func configure() {
        selectionStyle = .none
        contentView.backgroundColor = .main
        
        containerView.backgroundColor = .accent
        containerView.rounded(radius: 15)
        
        configureLabels()
        configureUpdateButton()
        configureTextField()
        isAdminSwitch.onTintColor = .main
    }
    
    private func configureLabels() {
        idLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        idLabel.textColor = .main
        
        [aliasLabel, hasAdminPriviligesLabel].forEach {
            $0?.font = .systemFont(ofSize: 18, weight: .medium)
            $0?.textColor = .main
        }
    }
    
    private func configureUpdateButton() {
        updateButton.setTitle("Update")
        updateButton.titleLabel?.font = .systemFont(ofSize: 16)
        updateButton.backgroundColor = .main
        updateButton.setTitleColor(.accent, for: .normal)
        updateButton.contentEdgeInsets = .init(vertical: 10, horizonal: 10)
        updateButton.rounded(radius: 8)
        
        updateButtonState(enabled: false)
    }
    
    private func configureTextField() {
        aliasTextField.placeholder = "Enter user Alias here..."
        aliasTextField.font = .systemFont(ofSize: 14, weight: .thin)
        aliasTextField.textColor = .accent
        aliasTextField.delegate = self
    }
    
    // MARK: - Public
    func configure(index: IndexPath, id: String, alias: String, isAdmin: Bool) {
        self.indexPath = index
        self.alias = alias
        self.isAdmin = isAdmin
        
        idLabel.text = "ID: \(id)"
        aliasTextField.text = alias
        isAdminSwitch.isOn = isAdmin
    }
    
    // MARK: - Actions
    @IBAction
    private func didTapUpdateButton(_ sender: UIButton) {
        guard let newAlias = aliasTextField.text else { return }
        updateButtonState(enabled: false)
        delegate?.didTapUpdateButton(self, index: indexPath, alias: newAlias, isAdmin: isAdminSwitch.isOn)
    }
    
    @IBAction
    private func isAdminSwitchValueChanged(_ sender: UISwitch) {
        updateButtonState()
    }
}

// MARK: - UITextFieldDelegate
extension UserTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateButtonState()
        return true
    }
}
