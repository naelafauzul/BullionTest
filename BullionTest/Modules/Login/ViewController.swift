//
//  ViewController.swift
//  BullionTest
//
//  Created by Naela Fauzul Muna on 12/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordText: UILabel!
    @IBOutlet weak var addUserButton: UIButton!
    
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.orange
        
        setupBackgroundRectangle()
        setupTextFieldStyles()
        setupButton()
        setupBindings()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Email dan password harus diisi")
            return
        }
        
        viewModel.email = email
        viewModel.password = password
        viewModel.login()
    }
    
    @IBAction func addUserButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Register", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func setupBindings() {
        viewModel.onLoginSuccess = { [weak self] user in
            DispatchQueue.main.async {
                self?.showAlert(message: "Login berhasil! Token: \(user.token)")
            }
        }
        
        viewModel.onLoginError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupBackgroundRectangle() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.customGrey
        backgroundView.layer.cornerRadius = 24
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.2
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backgroundView.layer.shadowRadius = 4
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            backgroundView.topAnchor.constraint(equalTo: self.emailText.topAnchor, constant: -20),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        
        self.view.bringSubviewToFront(emailTextField)
        self.view.bringSubviewToFront(passwordTextField)
        self.view.bringSubviewToFront(loginButton)
        self.view.bringSubviewToFront(emailText)
        self.view.bringSubviewToFront(passwordText)
        self.view.bringSubviewToFront(addUserButton)
    }
    
    func setupTextFieldStyles() {
        emailTextField.layer.cornerRadius = 25
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.darkGrey.cgColor
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.darkGrey.cgColor
        passwordTextField.layer.masksToBounds = true
    }
    
    func setupButton() {
        loginButton.layer.cornerRadius = 100
        addUserButton.layer.cornerRadius = 100
    }
}
