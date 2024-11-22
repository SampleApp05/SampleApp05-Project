//
//  EditRestaurantController.swift
//  SampleApp
//
//  Created by Daniel Velikov on 17.02.24.
//

import UIKit

typealias ImagePickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate
class EditRestaurantController: EditRestaurantViewController<RestaurantsViewModel> {} // Dummy needed for nib

class EditRestaurantViewController<T: EditRestaurantViewModel>: UIViewController, CoordinatorModelController, ImagePickerDelegate, UITextFieldDelegate {
    @IBOutlet private var logoImageView: UIImageView!
    @IBOutlet private var selectImageButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var ratingTextField: UITextField!
    @IBOutlet private var submitButton: UIButton!
    
    private(set) var model: T
    
    init(model: T) {
        self.model = model
        super.init(nibName: Self.identifier, bundle: .main)
    }
    
    deinit {
        model.selectedRestaurant = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - Configure
    private func configure() {
        configureLogoImageView()
        configureButtons()
        configureLabels()
        configureTextFields()
    }
    
    private func configureLogoImageView() {
        logoImageView.rounded()
        logoImageView.bordered(width: 0.3)
        
        Task {
            guard let image = await model.fetchPhoto(for: nil) else { return }
            
            onMain { [weak self] in
                self?.logoImageView.image = image
            }
        }
    }
    
    private func configureButtons() {
        selectImageButton.setTitle("Select Image")
        selectImageButton.titleLabel?.font = .systemFont(ofSize: 10)
//        selectImageButton.contentEdgeInsets = .init(vertical: 0, horizonal: 10)
        
        submitButton.setTitle("Submit")
        submitButton.titleLabel?.font = .systemFont(ofSize: 20)
        submitButton.isEnabled = false
//        submitButton.contentEdgeInsets = .init(vertical: 8, horizonal: 8)
        submitButton.alpha = 0.65
        
        [selectImageButton, submitButton].forEach {
            $0.backgroundColor = .accent
            $0.setTitleColor(.main, for: .normal)
            $0.setTitleColor(.main.withAlphaComponent(0.65), for: .disabled)
            $0.rounded(radius: 10)
        }
    }
    
    private func configureLabels() {
        titleLabel.text = "Enter Restaurant Name"
        ratingLabel.text = "Enter Restaurant Rating"
        
        [titleLabel, ratingLabel].forEach {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .accent
        }
    }
    
    private func configureTextFields() {
        titleTextField.text = model.selectedRestaurant?.name
        if let rating = model.selectedRestaurant?.rating { ratingTextField.text = String(rating) }
        
        titleTextField.placeholder = "Restaurant"
        ratingTextField.placeholder = "0.0...5.0"
        
        [titleTextField, ratingTextField].forEach {
            $0.font = .systemFont(ofSize: 14, weight: .thin)
            $0.textColor = .accent
            $0.delegate = self
        }
    }
    
    private func presentImagePicker() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true)
    }
    
    private func updateButtonStateIfNeeded(enabled: Bool) {
        guard enabled != submitButton.isEnabled else { return }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.submitButton.alpha = enabled ? 1.0 : 0.65
            self?.submitButton.isEnabled = enabled
        }
    }
    
    // MARK: - Actions
    @IBAction
    private func didTapSelectImageButton(_ sender: UIButton) {
        presentImagePicker()
    }
    
    @IBAction
    private func didTapSubmitButton(_ sender: UIButton) {
        model.didTapSubmitReviewButton()
        submitButton.isEnabled = false
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        model.editingName = titleTextField.text
        model.editingRating = ratingTextField.text?.toDouble
        
        updateButtonStateIfNeeded(enabled: model.canSubmitReview)
        return true
    }
    
    // MARK: - ImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer { dismiss(animated: true) }
        
        guard let image = info[.originalImage] as? UIImage else { return }
        logoImageView.image = image
        model.newLogoImage = logoImageView.image
        updateButtonStateIfNeeded(enabled: model.canSubmitReview)
    }
}
