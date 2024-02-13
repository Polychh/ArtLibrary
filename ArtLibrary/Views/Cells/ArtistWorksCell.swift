//
//  ArtistWorksCellCollectionViewCell.swift
//  ArtLibrary
//
//  Created by Polina on 13.02.2024.
//

import UIKit

import UIKit

final class ArtistWorksCell: UICollectionViewCell {
    static let resuseID = "ArtistWorksCell"
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpContentView()
        configureShadow()
        setConstrains()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImage.image = nil
        categoryLabel.text = nil
    }
}


//MARK: - Configure Cell UI
extension ArtistWorksCell{
    func configCategoryLabel(categoryLabelText: String){
        categoryLabel.text = categoryLabelText
    }
    
    func configCategoryImage(image: UIImage?){
        if let image = image{
            categoryImage.image = image
        } else{
            categoryImage.image = UIImage(named: "defaultCategoryImage")
        }
    }
    
    private func setUpContentView(){
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
    }
    
    private func configureShadow() {
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.8
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 20
        layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
    }
}

//MARK: - Constrains
extension ArtistWorksCell{
    private func setConstrains(){
        contentView.layer.cornerRadius = 16
        contentView.addSubview(categoryImage)
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: categoryImage.leadingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(equalTo: categoryImage.trailingAnchor , constant: -12),
            categoryLabel.bottomAnchor.constraint(equalTo: categoryImage.bottomAnchor, constant: -12)
        ])
    }
}
