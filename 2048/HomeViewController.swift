//
//  HomeViewController.swift
//  2048
//
//  Created by Kenes Yerassyl on 4/10/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    let welcomeLabel = UILabel()
    let textField = UITextField()
    let nextButton = UIButton()
    let warningLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 250/255, green: 248/255, blue: 240/255, alpha: 1.0)
        configureWelcomeLabel()
        configureTextField()
        configureButton()
        configureWarningLabel()
    }

    func configureWelcomeLabel() {
        view.addSubview(welcomeLabel)
        welcomeLabel.text = "Hello dear ... team!\nThis is my 2048 implementation.\nPlease enter the size of the game board. By default it is 4."
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.sizeToFit()
        welcomeLabel.numberOfLines = 0
        welcomeLabel.adjustsFontSizeToFitWidth = true
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .black)
        let constraints = [
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            welcomeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    func configureTextField() {
        view.addSubview(textField)
        textField.placeholder = "4"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftViewMode = .always
        textField.leftView = UIView(frame: CGRect(x:0,y:0,width:10,height:0))
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .white
        textField.layer.borderWidth = 2
        textField.keyboardType = .asciiCapableNumberPad
        textField.layer.borderColor = UIColor.lightGray.cgColor
        let constraints = [
            textField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
            textField.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureButton() {
        view.addSubview(nextButton)
        nextButton.setTitle("LET'S GO", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.setTitleColor(.white, for: .highlighted)
        nextButton.layer.borderWidth = 2
        nextButton.layer.borderColor = UIColor.black.cgColor
        nextButton.backgroundColor = UIColor(hexCode: "#FFDAB9")
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.layer.cornerRadius = 10
        let constraints = [
            nextButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
            nextButton.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        textField.inputAccessoryView = bar
    }
    
    func configureWarningLabel() {
        view.addSubview(warningLabel)
        warningLabel.text = "We can make a bigger board, but why make life harder??"
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.sizeToFit()
        warningLabel.numberOfLines = 0
        warningLabel.adjustsFontSizeToFitWidth = true
        warningLabel.textAlignment = .center
        warningLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .black)
        let constraints = [
            warningLabel.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 20),
            warningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warningLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
            warningLabel.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(constraints)
        warningLabel.isHidden = true
    }
    
    @objc private func didTapNextButton() {
        let boardSize = Int((textField.text ?? "4").trimmingCharacters(in: .whitespacesAndNewlines)) ?? 4
        if (2 < boardSize && boardSize < 13) {
            navigationController?.pushViewController(GameViewController(boardSize: CGFloat(boardSize)), animated: true)
            print("ASDASD")
        } else {
            warningLabel.isHidden = false
        }
        
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
