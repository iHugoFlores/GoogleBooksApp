//
//  SpinnerView.swift
//  GoogleBooks
//
//  Created by Hugo Flores Perez on 4/10/20.
//

import UIKit

class SpinnerView: UIView {
    private let spinnerBackdropColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)

    let spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    func showSpinner(in view: UIView) {
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.backgroundColor = spinnerBackdropColor

        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalTo: view.widthAnchor),
            spinner.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }

    func stopSpinner() {
        spinner.backgroundColor = nil
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}
