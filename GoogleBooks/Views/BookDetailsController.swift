//
//  BookDetailsController.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BookDetailsController: UIViewController {
    static let segueIdentifier: String = "toBookDetails"
    let viewModel = BookDetailsViewModel()

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let mainContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 32
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let bookImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 3
        return lbl
    }()

    private let authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.numberOfLines = 1
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        setUpMain()

        titleLabel.text = viewModel.model?.volumeInfo.title
    }

    func setUpScrollView() {
           view.addSubview(scrollView)
           scrollView.addSubview(mainContainer)

           NSLayoutConstraint.activate([
               scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
               scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
               scrollView.topAnchor.constraint(equalTo: view.topAnchor),
               scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

               mainContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
               mainContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
               mainContainer.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor, constant: 16),
               mainContainer.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16.0),

               mainContainer.widthAnchor.constraint(equalTo: view.widthAnchor)
           ])
       }

    func setUpMain() {
        mainContainer.addArrangedSubview(bookImage)
        mainContainer.addArrangedSubview(titleLabel)
        mainContainer.addArrangedSubview(authorLabel)

        NSLayoutConstraint.activate([
            bookImage.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            bookImage.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            bookImage.heightAnchor.constraint(equalToConstant: view.frame.height / 4)
        ])
    }
}
