//
//  BooksTableController.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BooksTableController: UIViewController {
    let searchBar: UISearchBar = {
        let srchBr = UISearchBar()
        srchBr.sizeToFit()
        srchBr.placeholder = "Search for book by title"
        srchBr.translatesAutoresizingMaskIntoConstraints = false
        srchBr.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return srchBr
    }()

    let tableView: UITableView = {
        let tblVw = UITableView()
        tblVw.translatesAutoresizingMaskIntoConstraints = false
        return tblVw
    }()

    let viewModel = BooksTableViewModel()

    let spinnerView = SpinnerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Books App"
        setUpSearchBar()
        setUpTableView()
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

    func setUpTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
    }
}

extension BooksTableController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchNewQuery()
        spinnerView.showSpinner(in: view)
        searchBar.endEditing(true)
    }
}
