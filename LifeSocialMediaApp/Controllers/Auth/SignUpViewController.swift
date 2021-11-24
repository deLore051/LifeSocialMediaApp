//
//  SignUpViewController.swift
//  LifeSocialMediaApp
//
//  Created by Stefan Dojcinovic on 15.11.21..
//

import UIKit

class SignUpViewController: UIViewController {
    
    private var countries: [String] = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 900)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "Email"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.font = .systemFont(ofSize: 20)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 25
        return textField
    }()

    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.placeholder = "First Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.font = .systemFont(ofSize: 20)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 25
        return textField
    }()
    
    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.placeholder = "Last Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.font = .systemFont(ofSize: 20)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 25
        return textField
    }()

    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "Username"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.font = .systemFont(ofSize: 20)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 25
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "Password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.backgroundColor = .secondarySystemBackground
        textField.font = .systemFont(ofSize: 20)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 25
        return textField
    }()

    private let countryPickerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.placeholder = "Select Country"
        textField.font = .systemFont(ofSize: 20)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.cornerRadius = 25
        textField.textAlignment = .center
        return textField
    }()
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign Up"
        addSubviews()
        addConstraints()
        addTapGesture()
        getCountries()
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped(sender:)), for: .touchUpInside)
        scrollView.delegate = self
        setUpCountryPicker()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func signUpButtonTapped(sender: UIButton) {
        signUpButton.tapEffect(sender: signUpButton)
        guard let email = emailTextField.text, !email.isEmpty,
              let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let country = countryPickerTextField.text, !country.isEmpty else {
            let alert = ErrorManager.shared.emptyFieldErrorAlert()
            present(alert, animated: true, completion: nil)
            return
        }
        
        let user = UserInfo(
            email: email,
            username: username,
            firstName: firstName,
            lastName: lastName,
            country: country,
            profilePhotoURL: nil)
        
        AuthManager.shared.signUp(
            email: email,
            password: password,
            user: user) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            case .failure(let error):
                let alert = ErrorManager.shared.errorAlert(error)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc private func didTapContentView() {
        self.view.endEditing(true)
    }
    
    private func getCountries() {
        self.countries = Locale
            .isoRegionCodes
            .compactMap({Locale.current.localizedString(forRegionCode: $0)})
        self.countries.sort()
        print(countries)
    }
    
    private func setUpCountryPicker() {
        countryPickerTextField.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(emailTextField)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(countryPickerTextField)
        contentView.addSubview(signUpButton)
    }
    
    private func addConstraints() {
        // ScrollView
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        // ContentView
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 900).isActive = true
        
        // EmailTextField
        emailTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // FirstNameTextField
        firstNameTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        firstNameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        firstNameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // LastNameTextField
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 10).isActive = true
        lastNameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lastNameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // UsernameTextField
        usernameTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // PasswordTextField
        passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // CountryPickerTextField
        countryPickerTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        countryPickerTextField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        countryPickerTextField.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        countryPickerTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // SignUpButton
        signUpButton.topAnchor.constraint(equalTo: countryPickerTextField.bottomAnchor, constant: 50).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.emailTextField.layer.borderColor = UIColor.label.cgColor
        self.firstNameTextField.layer.borderColor = UIColor.label.cgColor
        self.lastNameTextField.layer.borderColor = UIColor.label.cgColor
        self.usernameTextField.layer.borderColor = UIColor.label.cgColor
        self.passwordTextField.layer.borderColor = UIColor.label.cgColor
        self.countryPickerTextField.layer.borderColor = UIColor.label.cgColor
        self.signUpButton.layer.borderColor = UIColor.label.cgColor
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

extension SignUpViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
}

//MARK: - UIPickerViewDataSource_Delegate

extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countryPickerTextField.text = countries[row]
    }
}
