//
//  PageContentViewController.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/15/20.
//

import PDFKit
import UIKit

class PageContentViewController: UIViewController {
    static let storyboardIdentifier = "PageContent"
    let pageView: PDFView = {
        let pageView = PDFView()
        pageView.displayMode = .singlePage
        pageView.autoScales = true
        pageView.translatesAutoresizingMaskIntoConstraints = false
        return pageView
    }()

    var pageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pageView)

        NSLayoutConstraint.activate([
            pageView.topAnchor.constraint(equalTo: view.topAnchor),
            pageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
