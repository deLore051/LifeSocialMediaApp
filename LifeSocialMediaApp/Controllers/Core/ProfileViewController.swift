//
//  ProfileViewController.swift
//  LifeSocialMediaApp
//
//  Created by Stefan Dojcinovic on 20.11.21..
//

import UIKit


class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpLogOutButton()
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
    
}
