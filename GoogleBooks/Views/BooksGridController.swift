//
//  BooksTableController.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BooksGridController: UIViewController {
    let searchBar: UISearchBar = {
        let srchBr = UISearchBar()
        srchBr.sizeToFit()
        srchBr.placeholder = "Search for book by title"
        srchBr.translatesAutoresizingMaskIntoConstraints = false
        srchBr.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return srchBr
    }()

    let collectionView: UICollectionView = {
        let collVw = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collVw.translatesAutoresizingMaskIntoConstraints = false
        collVw.backgroundColor = .white
        return collVw
    }()

    let viewModel = BooksGridViewModel()

    let spinnerView = SpinnerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Books App"
        setUpSearchBar()
        setUpCollectionView()
        setUpViewModel()
        setUpNavBar()
        checkIfCollectionViewHasItems()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        viewModel.retrieveFavorites()
    }

    func setUpSearchBar() {
        searchBar.delegate = self

        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = self
        collectionView.register(BookCollectionCell.self, forCellWithReuseIdentifier: BookCollectionCell.identifier)

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
    }

    func setUpNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.navbarRightButtonText, style: .plain, target: viewModel, action: #selector(viewModel.toggleViewMode))
    }

    func checkIfCollectionViewHasItems() {
        if viewModel.volumes.isEmpty {
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.size.width, height: self.view.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = viewModel.query.isEmpty
                ? "Search for a book"
                : "No Books Found"
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
            messageLabel.sizeToFit()

            collectionView.backgroundView = messageLabel
            return
        }
        collectionView.backgroundView = nil
    }

    func setUpViewModel() {
        viewModel.onDataReload = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.checkIfCollectionViewHasItems()
            }
        }
        viewModel.onSingleRowReload = { indexPath in
            self.collectionView.reloadItems(at: [indexPath])
        }
        viewModel.onViewModeChanged = {
            self.navigationItem.rightBarButtonItem?.title = self.viewModel.navbarRightButtonText
            self.searchBar.isHidden = !self.viewModel.showQueryBooks
        }
        viewModel.setUpNotifications()
        //viewModel.query = "Flowertttg"
        //viewModel.searchNewQuery()
    }
}

extension BooksGridController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
        viewModel.searchNewQuery()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension BooksGridController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //performSegue(withIdentifier: BookDetailsController.segueIdentifier, sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let indexPath = sender as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? BookCollectionCell
        else { return }
        let viewController = segue.destination as? BookDetailsController
        viewController?.viewModel.model = viewModel.volumes[indexPath.row]
        viewController?.bookImage.image = cell.bookImage.image
    }
}

extension BooksGridController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return BookCollectionCell.preferredSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return centerItemsInCollectionView(cellWidth: BookCollectionCell.preferredSize.width, numberOfItems: Double(viewModel.volumes.count), spaceBetweenCell: 0, collectionView: collectionView)
    }

    func centerItemsInCollectionView(cellWidth: CGFloat, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        return UIEdgeInsets(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
