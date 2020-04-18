//
//  BookDetailsController.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class BookDetailsController: UIViewController {
    // MARK: Properties
    static let segueIdentifier: String = "toBookDetails"
    let viewModel = BookDetailsViewModel()

    // MARK: UI Components
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
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        lbl.numberOfLines = 3
        return lbl
    }()

    private let authorLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        return lbl
    }()

    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.numberOfLines = 0
        return lbl
    }()

    private let openPDFButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemBlue
        btn.setTitle("View PDF", for: .normal)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return btn
    }()

    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
        setUpMain()

        titleLabel.text = viewModel.model?.volumeInfo.title
        authorLabel.text = viewModel.model?.volumeInfo.authors?.joined(separator: "\n")
        descriptionLabel.text = viewModel.model?.volumeInfo.description
    }

    // MARK: Scrollview constraints setup
    func setUpScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainContainer)

        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),

            mainContainer.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            mainContainer.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            mainContainer.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor, constant: 16),
            mainContainer.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -16.0),

            mainContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)
        ])
    }

    // MARK: Main constraints setup
    func setUpMain() {
        mainContainer.addArrangedSubview(bookImage)
        mainContainer.addArrangedSubview(titleLabel)
        mainContainer.addArrangedSubview(authorLabel)
        mainContainer.addArrangedSubview(descriptionLabel)
        mainContainer.addArrangedSubview(openPDFButton)

        NSLayoutConstraint.activate([
            bookImage.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            bookImage.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            bookImage.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
    }

    // MARK: View PDF Button press handler
    @objc
    func buttonAction(sender: UIButton!) {
        performSegue(withIdentifier: PaginatedViewController.segueIdentifier, sender: self)
    }
}
