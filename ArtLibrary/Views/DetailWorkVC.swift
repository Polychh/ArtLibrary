//
//  DetailWorkVC.swift
//  ArtLibrary
//
//  Created by Polina on 13.02.2024.
//

import UIKit
final class DetailWorkVC: UIViewController {
    
    private let workTitle = UILabel()
    private let infoWork = UILabel()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.backgroundColor = .white
        scroll.layer.cornerRadius = 15
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "close"), for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(nil, action: #selector(dismissVC), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var workImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .white
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func configLabel(label: UILabel, sizeText: CGFloat, weithText: UIFont.Weight, lines: Int, color: UIColor){
        label.textAlignment = .left
        label.textColor = color
        label.numberOfLines = lines
        label.font = .systemFont(ofSize: sizeText, weight: weithText)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLabel(label: workTitle, sizeText: 24, weithText: .medium, lines: 3, color: .black)
        configLabel(label: infoWork, sizeText: 18, weithText: .regular, lines: 0, color: .gray)
        setConstrains()
        addScrollViewZoom()
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
      }
    
    private func addScrollViewZoom(){
        scrollView.delegate = self
        scrollView.maximumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.setZoomScale(1, animated: true)
    }

}
//MARK: - Configure UI
extension DetailWorkVC{
    func configworkTitleLabel(workTitleText: String){
        workTitle.text = workTitleText
    }
    
    func configInfoWorkLabel(infoText: String){
        infoWork.text = infoText
    }
    
    func configWorkImage(image: UIImage?){
        if let image = image{
            workImage.image = image
        } else{
            workImage.image = UIImage(named: "defaultCategoryImage")
        }
    }
}

//MARK: - Constrains
private extension DetailWorkVC{
    func setConstrains(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(workImage)
        stackView.addArrangedSubview(workTitle)
        stackView.addArrangedSubview(infoWork)
       // view.addSubview(workImage)
        view.addSubview(dismissButton)
        view.addSubview(stackView)

        let pad: CGFloat = 16

        NSLayoutConstraint.activate([
            
//            workImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            workImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            workImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            workImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            workImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            workImage.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            workImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            workImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            dismissButton.widthAnchor.constraint(equalToConstant: 50),
            dismissButton.heightAnchor.constraint(equalToConstant: 50),

            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            scrollView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -8),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: pad),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -pad),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant:  -pad),
        ])
    }
}
//MARK: - UIScrollViewDelegate
extension DetailWorkVC: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return workImage
    }
}
