//
//  ViewController.swift
//  ArtLibrary
//
//  Created by Polina on 12.02.2024.
//


import UIKit
import Combine

final class MainViewController: UIViewController {
    private var viewModel: MainViewModel
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var filter: Bool = false
        
    init(viewModel: MainViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        upDateteArtist()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        configureTableView()
        setUpSearchController()
        setConstrains()
    }
    
    @objc private func addAction() {
        let addNewArtist = AddNewArtistVC()
        addNewArtist.$textArray
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { aray in
                if aray.count == 6{
                    self.viewModel.newArtist = aray
                }
            })
            .store(in: &cancellables)
        addNewArtist.modalPresentationStyle = .overFullScreen
        addNewArtist.modalTransitionStyle = .crossDissolve
        self.present(addNewArtist, animated: true)
    }
    
//MARK: - UPdate Artists
    private func upDateteArtist(){
        viewModel.$artistArray
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$filterArtistArray
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else {return}
                guard let text = searchController.searchBar.text else {return}
                if filter || text.isEmpty{
                   tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$addNewArtist
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { newArtist in
                let newIndexPath = IndexPath(row: 0, section: 0)
                self.viewModel.artistArray.insert(newArtist, at: 0)
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            .store(in: &cancellables)
    }
}

//MARK: - Configure UIBarButton
private extension MainViewController{
    func configNavigationBar(){
        navigationItem.title = "ArtLibrary"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        addButton.tintColor = .gray
        navigationItem.rightBarButtonItem = addButton
    }
}

//MARK: - Configure UITableView
private extension MainViewController{
    private func configureTableView() {
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainCell.self, forCellReuseIdentifier: MainCell.resuseID)
    }
}

//MARK: - Configure SearchController
private extension MainViewController{
    func setUpSearchController(){
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.tintColor = .gray
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.gray.cgColor
        searchController.searchBar.searchTextField.layer.borderWidth = 1.0
        searchController.searchBar.searchTextField.layer.cornerRadius = 15.0
        searchController.searchBar.searchTextField.layer.shadowColor = UIColor.black.cgColor
        searchController.searchBar.searchTextField.layer.shadowOpacity = 0.8
        searchController.searchBar.searchTextField.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        navigationItem.searchController = searchController
        searchController.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}
//MARK: - SearchController
extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        filter = text.isEmpty ? false : true
        viewModel.filterArtistArray = filter ? viewModel.artistArray.filter { $0.name.contains(text) || $0.works.contains { $0.title.contains(text) } } : []
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // dismiss keyBoard
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filter ? viewModel.filterArtistArray.count : viewModel.artistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCell.resuseID, for: indexPath) as? MainCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        let info = self.filter ? self.viewModel.filterArtistArray[indexPath.row] : self.viewModel.artistArray[indexPath.row]
        cell.configArtistImage(image: UIImage(named: info.image))
        cell.configTitleLabel(titleLabelText: info.name)
        cell.configInfoLabel(infoLabelText: info.bio)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artistWorks = filter ? viewModel.filterArtistArray[indexPath.row] : viewModel.artistArray[indexPath.row]
        let artistWorksVC = ArtistWorksViewController(viewModel: ArtistWorksViewModel(works: artistWorks.works))
        artistWorksVC.navigationItem.title = artistWorks.name
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24)]
        navigationController?.pushViewController(artistWorksVC, animated: true)
    }
}

//MARK: - Set Constrains
private extension MainViewController{
    func setConstrains(){
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
}
