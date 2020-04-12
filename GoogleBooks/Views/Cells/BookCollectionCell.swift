//
//  BooksTableCell.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/11/20.
//

import UIKit

class BookCollectionCell: UICollectionViewCell {
    static let favoriteABookNotificationId = Notification.Name("favoriteABook")
    static let identifier = "BookCell"
    static var preferredSize = CGSize(width: 158, height: 208)
    static var imageSize: CGFloat = 150

    let viewModel = BookCollectionCellViewModel()
    var collectionView: UICollectionView? {
        return superview as? UICollectionView
    }

    let bookImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: imageSize),
            image.heightAnchor.constraint(equalToConstant: imageSize)
        ])
        return image
    }()

    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    let authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Arial", size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading..."
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    var favoriteIcon: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()

        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)

        viewModel.onModelSet = {
            self.titleLabel.text = self.viewModel.model!.volumeInfo.title
            self.authorLabel.text = self.viewModel.model?.volumeInfo.authors?.joined(separator: ", ")
            self.setUpFavoriteIcon()
        }
        viewModel.onImageSet = {
            self.bookImage.image = self.viewModel.image
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc
    func doubleTapped() {
        let selfIndexPath = (collectionView?.indexPath(for: self))!
        viewModel.onBookFavorited(indexPath: selfIndexPath)
    }

    func setUpView() {
        let stackView = UIStackView(arrangedSubviews: [bookImage, titleLabel, authorLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }

    func setUpFavoriteIcon() {
        if viewModel.isFavorite() {
            let icon = UIImageView(image: UIImage(systemName: "heart.circle")?.withRenderingMode(.alwaysTemplate))
            icon.tintColor = .systemPink
            icon.backgroundColor = .white
            icon.layer.cornerRadius = 10
            bookImage.addSubview(icon)
            return
        }

        if !bookImage.subviews.isEmpty {
            bookImage.subviews.forEach({ $0.removeFromSuperview() })
        }
    }
}
