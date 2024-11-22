//
//  UsersViewController.swift
//  SampleApp
//
//  Created by Daniel Velikov on 18.02.24.
//

import UIKit

struct UserDetails {
    let id: String
    let alias: String
    let isAdmin: Bool
}

class UsersViewModel {
    private(set) var details: [UserDetails] = []
    private let service: RegistrationService
    
    init(service: RegistrationService) {
        self.service = service
    }
    
    func fetchUserDetails() async throws {
        details = try await service.fetchAllAcountDetails()
    }
    
    func updateUser(index: IndexPath, alias: String, isAdmin: Bool) async throws {
        let id = details[index.row].id
        try await service.storeAccountDetails(id: id, data: ["alias": alias, "isAdmin": isAdmin])
        
        details.remove(at: index.row)
        details.insert(.init(id: id, alias: alias, isAdmin: isAdmin), at: index.row)
    }
}

class UsersViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let model: UsersViewModel
    
    init(model: UsersViewModel) {
        self.model = model
        super.init(nibName: Self.identifier, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .main
        tableView.backgroundColor = .main
        configureTableView()
        
        fetchData()
    }
    
    // MARK: - Private
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerCelNib(UserTableViewCell.self)
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func presentMissingDataAlert() {
        presentAlert(
            config: .init(
                title: "Could not load data!",
                message: "Do you want to try again?",
                actions: [
                    .cancel,
                    .init(text: "Try Again") { [weak self] _ in
                        self?.fetchData()
                    }
                ]
            )
        )
    }
    
    private func presentFailedToUpdateAlert() {
        presentAlert(
            config: .init(
                title: "Something went wrong",
                message: "Failed to update user details",
                actions: [.init(text: "OK")]
            )
        )
    }
    
    private func fetchData() {
        Task {
            do {
                try await model.fetchUserDetails()
                onMain { [weak self] in
                    self?.tableView.reloadData()
                }
            } catch {
                presentMissingDataAlert()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(UserTableViewCell.self, for: indexPath) else { return .init() }
        let data = model.details[indexPath.row]
        
        cell.configure(index: indexPath, id: data.id, alias: data.alias, isAdmin: data.isAdmin)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UserTableViewDelegate
extension UsersViewController: UserTableViewDelegate {
    func didTapUpdateButton(_ sender: UserTableViewCell, index: IndexPath, alias: String, isAdmin: Bool) {
        view.resignFirstResponder()
        
        Task {
            do {
                try await model.updateUser(index: index, alias: alias, isAdmin: isAdmin)
                onMain { [weak self] in
                    self?.tableView.reloadRows(at: [index], with: .automatic)
                }
            } catch {
                presentFailedToUpdateAlert()
            }
        }
    }
}
