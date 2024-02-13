//
//  ArtistWorksViewController.swift
//  ArtLibrary
//
//  Created by Polina on 13.02.2024.
//

import UIKit
import Combine
class ArtistWorksViewController: UIViewController {
    
    private let viewModel: ArtistWorksViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    init(viewModel: ArtistWorksViewModel, cancellables: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.viewModel = viewModel
        self.cancellables = cancellables
        super.init(nibName: nil, bundle: nil)
        upDateteArtist()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setConstrains()
 
    }
    
//MARK: - UpdateCategory
    private func upDateteArtist(){
        viewModel.$works
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                print("reloadCollection")
                collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

//MARK: - Configure UiCollectionView
private extension ArtistWorksViewController{
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ArtistWorksCell.self, forCellWithReuseIdentifier: ArtistWorksCell.resuseID) 
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ArtistWorksViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.works.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistWorksCell.resuseID, for: indexPath) as? ArtistWorksCell else {
            return UICollectionViewCell()
        }
        cell.configCategoryLabel(categoryLabelText: viewModel.works[indexPath.row].title)
        cell.configCategoryImage(image: UIImage(named: viewModel.works[indexPath.row].image))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailWorkVC()
        let data =  viewModel.works[indexPath.row]
        detailVC.configWorkImage(image: UIImage(named: data.image))
        detailVC.configworkTitleLabel(workTitleText: data.title)
        detailVC.configInfoWorkLabel(infoText: data.info)
        detailVC.modalPresentationStyle = .overCurrentContext
        self.present(detailVC, animated: true)
    }
    

}
//MARK: - Constrains
private extension ArtistWorksViewController{
    func setConstrains(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ArtistWorksViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 // from left and right of the screen
        let minimumItemSpacing: CGFloat = 11 // between columns
        let availableWidth = view.bounds.width - (padding * 2) - (minimumItemSpacing)
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem + 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        11
    }
}
