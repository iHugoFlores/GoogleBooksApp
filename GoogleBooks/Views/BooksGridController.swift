//
//  BooksTableController.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BooksGridController: UIViewController {
    // MARK: Properties

    let viewModel = BooksGridViewModel()

    // MARK: UI Components
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

    let spinnerView = SpinnerView()

    // MARK: Life Cycle Methods
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

    // MARK: Searchbar constraints setup
    func setUpSearchBar() {
        searchBar.delegate = self

        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    // MARK: Collection View constraints setup
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

    // MARK: Navigation Bar setup
    func setUpNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.navbarRightButtonText, style: .plain, target: viewModel, action: #selector(viewModel.toggleViewMode))
    }

    // MARK: Empty List handler
    func checkIfCollectionViewHasItems() {
        if viewModel.volumes.isEmpty {
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.size.width, height: self.view.bounds.size.height))
            let messageLabel = UILabel(frame: rect)
            messageLabel.text = viewModel.query.isEmpty
                ? "Search for a book using Google Books API\n\nMark your favorite books, see your favorite books, download available books and read them!"
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

    // MARK: View model listener methods setup
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
            if self.viewModel.showQueryBooks {
                self.setUpSearchBar()
                self.collectionView.removeFromSuperview()
                self.setUpCollectionView()
                return
            }
            self.searchBar.removeFromSuperview()
            NSLayoutConstraint.activate([
                self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
            ])
        }
        viewModel.setUpNotifications()
        //viewModel.query = "Harry Potter"
        //viewModel.searchNewQuery()
    }
}

// MARK: Search Bar Delegate Handler
extension BooksGridController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(performSearch), object: nil)
        perform(#selector(performSearch), with: nil, afterDelay: 0.2)
    }

    @objc
    func performSearch() {
        viewModel.searchNewQuery()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

// MARK: Collection View Delegate Handler
extension BooksGridController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: BookDetailsController.segueIdentifier, sender: indexPath)
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

// MARK: Collection View Flow Layout Delegate Handler
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
