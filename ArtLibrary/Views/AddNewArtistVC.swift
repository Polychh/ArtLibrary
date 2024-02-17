//
//  AddNewArtist.swift
//  ArtLibrary
//
//  Created by Polina on 14.02.2024.
//

import UIKit

final class AddNewArtistVC: UIViewController {
    @Published var textArray: [String] = []
    private let viewModel = AddNewArtistViewModel()
    
    private let backView = UIView()
    private let containerView = UIView()
    
    private let textView1 = UITextView()
    private let textView2 = UITextView()
    private let textView3 = UITextView()
    private let textView4 = UITextView()
    private let textView5 = UITextView()
    private let textView6 = UITextView()
    
    private var constrainBottomContainer: NSLayoutConstraint?
    private var constrainTopContainer: NSLayoutConstraint?
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.titleLabel?.textColor = .black
        button.setTitle("Сохранить", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(nil, action: #selector(dismissVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        setUpUI()
        setUpNotficationCenter()
        setConstrains()
        setDelegates()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpNotficationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setUpUI(){
        setUpUIView(view: containerView, color: .white, cornerRad: 12)
        setUpUIView(view: backView, color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.4))
        setUPTextView(textView: textView1, placeholder: "Имя")
        setUPTextView(textView: textView2, placeholder: "Биография")
        setUPTextView(textView: textView3, placeholder: "Фото")
        setUPTextView(textView: textView4, placeholder: "Название картины")
        setUPTextView(textView: textView5, placeholder: "Изображение картины")
        setUPTextView(textView: textView6, placeholder: "Информация о картине")
    }
    
    private func setUpUIView(view: UIView, color: UIColor, cornerRad: CGFloat = 0){
        view.backgroundColor = color
        view.layer.cornerRadius = cornerRad
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setUPTextView(textView: UITextView, placeholder: String){
        textView.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.text = placeholder
        textView.textColor = UIColor.lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createAlert(){
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func dismissVC() {
        resifnFirstResponderTextViews()
        if !viewModel.textArrayPrivate.contains("") {
            dismiss(animated: true)
            textArray.append(contentsOf: viewModel.textArrayPrivate)
        } else{
            createAlert()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        // Move the view only when the textView1 or textView2 or textView3  are being edited
        if textView1.isEditable || textView2.isEditable || textView3.isEditable{
            viewModel.moveKeyboard(notification: notification, keyboardWillShow: true, constraintTop: constrainTopContainer, constraintBottom: constrainBottomContainer, view: containerView, vc: self)
        }
    }
    
    @objc  private func keyboardWillHide(_ notification: NSNotification) {
        viewModel.moveKeyboard(notification: notification, keyboardWillShow: false, constraintTop: constrainTopContainer, constraintBottom: constrainBottomContainer, view: containerView, vc: self)
    }
    
    private func setDelegates(){
        textView1.delegate = self
        textView2.delegate = self
        textView3.delegate = self
        textView4.delegate = self
        textView5.delegate = self
        textView6.delegate = self
    }
    
    private func resifnFirstResponderTextViews(){
        textView1.resignFirstResponder()
        textView2.resignFirstResponder()
        textView3.resignFirstResponder()
        textView4.resignFirstResponder()
        textView5.resignFirstResponder()
        textView6.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resifnFirstResponderTextViews()
    }
}

//MARK: - Constrains
private extension AddNewArtistVC{
    func setConstrains(){
        view.addSubview(backView)
        backView.addSubview(containerView)
        containerView.addSubview(textView1)
        containerView.addSubview(textView2)
        containerView.addSubview(textView3)
        containerView.addSubview(textView4)
        containerView.addSubview(textView5)
        containerView.addSubview(textView6)
        containerView.addSubview(dismissButton)
        
        constrainBottomContainer =  containerView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -((UIScreen.main.bounds.height - 400) / 2))
        constrainBottomContainer?.isActive = true
        constrainTopContainer = containerView.topAnchor.constraint(equalTo: backView.topAnchor, constant: ((UIScreen.main.bounds.height - 400) / 2))
        constrainTopContainer?.isActive = true
        
        NSLayoutConstraint.activate([
            
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 250),
            
            textView1.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            textView1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView1.heightAnchor.constraint(equalToConstant: 35),
            
            textView2.topAnchor.constraint(equalTo: textView1.bottomAnchor, constant: 10),
            textView2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView2.heightAnchor.constraint(equalToConstant: 75),
            
            textView3.topAnchor.constraint(equalTo: textView2.bottomAnchor, constant: 10),
            textView3.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView3.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView3.heightAnchor.constraint(equalToConstant: 35),
            
            textView4.topAnchor.constraint(equalTo: textView3.bottomAnchor, constant: 10),
            textView4.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView4.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView4.heightAnchor.constraint(equalToConstant: 35),
            
            textView5.topAnchor.constraint(equalTo: textView4.bottomAnchor, constant: 10),
            textView5.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView5.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView5.heightAnchor.constraint(equalToConstant: 35),
            
            textView6.topAnchor.constraint(equalTo: textView5.bottomAnchor, constant: 10),
            textView6.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView6.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView6.heightAnchor.constraint(equalToConstant: 75),
            
            dismissButton.topAnchor.constraint(equalTo: textView6.bottomAnchor,constant: 10),
            dismissButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dismissButton.heightAnchor.constraint(equalToConstant: 30),
            dismissButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
}

//MARK: - TextViewDelegate
extension AddNewArtistVC: UITextViewDelegate{
    private func changeColorToBlack(textView: UITextView){
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    private func changeColorIfEmpty(textView: UITextView, placeholder: String){
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView{
        case textView1: changeColorToBlack(textView: textView1)
        case textView2: changeColorToBlack(textView: textView2)
        case textView3: changeColorToBlack(textView: textView3)
        case textView4: changeColorToBlack(textView: textView4)
        case textView5: changeColorToBlack(textView: textView5)
        case textView6: changeColorToBlack(textView: textView6)
        default: break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView{
        case textView1:
            viewModel.text1 = textView1.text
            changeColorIfEmpty(textView: textView1, placeholder: "Имя")
        case textView2:
            viewModel.text2 = textView2.text
            changeColorIfEmpty(textView: textView2, placeholder: "Биография")
        case textView3:
            viewModel.text3 = textView3.text
            changeColorIfEmpty(textView: textView3, placeholder: "Фото")
        case textView4:
            viewModel.text4 = textView4.text
            changeColorIfEmpty(textView: textView4, placeholder: "Название картины")
        case textView5:
            viewModel.text5 = textView5.text
            changeColorIfEmpty(textView: textView5, placeholder: "Изображение картины")
        case textView6:
            viewModel.text6 = textView6.text
            changeColorIfEmpty(textView: textView6, placeholder: "Информация о картине")
        default: break
        }
    }
}

