//
//  ProfileViewController.swift
//  LifeSocialMediaApp
//
//  Created by Stefan Dojcinovic on 20.11.21..
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.layer.cornerRadius = 75
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private let firstAndLastNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 1
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpLogOutButton()
        addSubviews()
        addConstraints()
        getUserInfo()
        scrollView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(firstAndLastNameLabel)
        contentView.addSubview(countryLabel)
    }
    
    private func getUserInfo() {
        guard let email = Auth.auth().currentUser?.email else { return }
        DatabaseManager.shared.getUserInfo(for: email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.setUpProfile(with: user)
                print(user.username)
            case .failure(let error):
                let alert = ErrorManager.shared.errorAlert(error)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setUpProfile(with user: UserInfo) {
        self.usernameLabel.text = user.username
        self.firstAndLastNameLabel.text = "\(user.firstName) \(user.lastName)"
        self.countryLabel.text = user.country
    }
    
    private func setUpLogOutButton() {
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(didTapLogOut))
        navigationItem.rightBarButtonItem = logOutButton
    }

    @objc private func didTapLogOut() {
        AuthManager.shared.signOut { [weak self] success in
            guard let self = self else { return }
            guard success else { return }
            print("logged out")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func addConstraints() {
        // ScrollView
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        // ContentView
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
        // ProfileImageView
        profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // UsernameLabel
        usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        usernameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -180).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // FirstAndLastNameLabel
        firstAndLastNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        firstAndLastNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        firstAndLastNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -180).isActive = true
        firstAndLastNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // CountryLabel
        countryLabel.topAnchor.constraint(equalTo: firstAndLastNameLabel.bottomAnchor).isActive = true
        countryLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10).isActive = true
        countryLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -180).isActive = true
        countryLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.profileImageView.layer.borderColor = UIColor.label.cgColor
        self.usernameLabel.layer.borderColor = UIColor.label.cgColor
        self.firstAndLastNameLabel.layer.borderColor = UIColor.label.cgColor
        self.countryLabel.layer.borderColor = UIColor.label.cgColor
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.navigationItem.largeTitleDisplayMode = .always
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.navigationBar.sizeToFit()
                self.scrollView.contentOffset.x = 0
            },
            completion: nil)
    }
    
}

//MARK: - UIScrollViewDelegate

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
