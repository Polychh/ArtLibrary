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
        addDoubleTapZoom()
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = workImage.frame.size
    }
}

//MARK: - ConfigureScrollView
private extension DetailWorkVC{
    func addScrollViewZoom(){
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 4
        scrollView.setZoomScale(1, animated: true)
    }
    
    func addDoubleTapZoom(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAction))
        tap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc func handleAction(gesture: UITapGestureRecognizer){
        if scrollView.zoomScale == 1{
            scrollView.zoom(to: zoomImage(scale: scrollView.maximumZoomScale, center: gesture.location(in: gesture.view)), animated: true)
        }else{
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    func zoomImage(scale:CGFloat, center: CGPoint) -> CGRect{
        var zoomRect = CGRect.zero
        zoomRect.size.width = workImage.frame.size.width / scale
        zoomRect.size.height = workImage.frame.size.height / scale
        let centerNew = workImage.convert(center, to: scrollView)
        zoomRect.origin.x = centerNew.x - (zoomRect.size.width) / 2.0
        zoomRect.origin.y = centerNew.y - (zoomRect.size.height) / 2.0
        return zoomRect
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
        scrollView.backgroundColor = .red
        view.addSubview(scrollView)
        scrollView.addSubview(workImage)
        stackView.addArrangedSubview(workTitle)
        stackView.addArrangedSubview(infoWork)
        view.addSubview(dismissButton)
        view.addSubview(stackView)
        
        let pad: CGFloat = 16
        
        NSLayoutConstraint.activate([
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
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale <  1.0 {
            scrollView.setZoomScale(1, animated: true)
        }
    }
}
