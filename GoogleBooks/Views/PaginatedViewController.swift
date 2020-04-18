//
//  PaginatedViewController.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/15/20.
//

import PDFKit
import UIKit

class PaginatedViewController: UIPageViewController {
    // MARK: Properties
    static let segueIdentifier = "toPDFView"
    var loadedPDF: PDFDocument?

    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let path = Bundle.main.path(forResource: "placeholder", ofType: "pdf") {
            let url = URL(fileURLWithPath: path)
            if let pdfDocument = PDFDocument(url: url) {
                loadedPDF = pdfDocument
                setViewControllers([getViewControllerAtIndex(index: 0)], direction: .forward, animated: false, completion: nil)
            }
        }
    }

    // MARK: Return View Controller at index
    func getViewControllerAtIndex(index: Int) -> PageContentViewController {
        guard let pageController = storyboard?.instantiateViewController(identifier: PageContentViewController.storyboardIdentifier) as? PageContentViewController else { return PageContentViewController() }
        let page = PDFDocument()
        page.insert((loadedPDF?.page(at: index))!, at: 0)
        pageController.pageView.document = page
        pageController.pageIndex = index
        title = "Page \(index + 1) - of \(String(describing: loadedPDF!.pageCount))"
        return pageController
    }
}

// MARK: Page View Controller Delegate Handler
extension PaginatedViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageContent = viewController as? PageContentViewController else { return nil }
        var index = pageContent.pageIndex

        if (index == 0) || (index == NSNotFound) {
            return nil
        }

        index -= 1

        return getViewControllerAtIndex(index: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageContent = viewController as? PageContentViewController else { return nil }
        var index = pageContent.pageIndex

        if index == NSNotFound {
            return nil
        }

        index += 1
        if index == loadedPDF?.pageCount {
            return nil
        }

        return getViewControllerAtIndex(index: index)
    }
}
