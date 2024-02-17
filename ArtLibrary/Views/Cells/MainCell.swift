//
//  MainCell.swift
//  ArtLibrary
//
//  Created by Polina on 12.02.2024.
//

import UIKit

final class MainCell: UITableViewCell {
    static let resuseID = "MainCell"
    
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let artistImage = UIImageView()
    private let stack = UIStackView()
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.cornerRadius = 20
        view.clipsToBounds = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUIElements()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUIElements(){
        configLabel(label: titleLabel, sizeText: 24, weithText: .bold, lines: 1)
        configLabel(label: infoLabel, sizeText: 18, weithText: .regular, lines: 0)
        configImageView(imageView: artistImage)
        configStack(stack: stack)
    }
    
    private func configLabel(label: UILabel, sizeText: CGFloat, weithText: UIFont.Weight, lines: Int){
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = lines
        label.font = .systemFont(ofSize: sizeText, weight: weithText)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configImageView(imageView: UIImageView){
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configStack(stack: UIStackView){
        stack.alignment = .center
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.spacing = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistImage.image = nil
        titleLabel.text = nil
        infoLabel.text = nil
    }
}

//MARK: - Configure Cell UI
extension MainCell{
    func configTitleLabel(titleLabelText: String){
        titleLabel.text = titleLabelText
    }
    
    func configInfoLabel(infoLabelText: String){
        infoLabel.text = infoLabelText
    }
    
    func configArtistImage(image: UIImage?){
        if let image = image{
            artistImage.image = image
        } else{
            artistImage.image = UIImage(named: "defaultCategoryImage")
        }
        
    }
}

//MARK: - Constrains
extension MainCell{
    private func setConstrains(){
        backView.addSubview(artistImage)
        backView.addSubview(titleLabel)
        backView.addSubview(infoLabel)
        contentView.addSubview(backView)
        
        NSLayoutConstraint.activate([
            
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            artistImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            artistImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5),
            artistImage.heightAnchor.constraint(equalToConstant: 200),
            artistImage.widthAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: artistImage.bottomAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor,constant: -5),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 5),
            infoLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor,constant: -5),
            infoLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -5),
            
        ])
    }
}


