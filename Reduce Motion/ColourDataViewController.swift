//
//  ColourDetailsViewController.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 23/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The view controller used to show a `ColourDetail`'s name and colour.
final class ColourDetailsViewController: UIViewController {
    
    /// The delegate of the receiver.
    weak var delegate: ColourDetailsViewControllerDelegate?
    
    private let childColourDisplayViewController: ColourDisplayViewController
    
    private let childNavigationController: UINavigationController
    
    init(colourDetails: ColourDetails) {
        childColourDisplayViewController = ColourDisplayViewController(colour: colourDetails.colour)
        childColourDisplayViewController.title = colourDetails.name
        childNavigationController = UINavigationController(rootViewController: childColourDisplayViewController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(childNavigationController)
        view.addSubview(childNavigationController.view)
        childNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            childNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        childNavigationController.didMove(toParent: self)
        
        childColourDisplayViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close(_:)))
    }
    
    @objc private func close(_ sender: Any) {
        delegate?.colourDetailsViewControllerDidFinish(self)
    }
}

/// The protocol to conform to for delegate's of `ColourDetailsViewController`.
protocol ColourDetailsViewControllerDelegate: AnyObject {
    
    /// The message sent when the user wishes to dismiss the sender.
    /// - Parameter colourDetailsViewController: The controller sending the
    /// message.
    func colourDetailsViewControllerDidFinish(_ colourDetailsViewController: ColourDetailsViewController)
}

/// A view controller used to display a colour.
private class ColourDisplayViewController: UIViewController {
    private let colour: UIColor
    
    init(colour: UIColor) {
        self.colour = colour
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let colourView = UIView()
        colourView.translatesAutoresizingMaskIntoConstraints = false
        colourView.backgroundColor = colour
        view.addSubview(colourView)
        NSLayoutConstraint.activate([
            colourView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colourView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colourView.topAnchor.constraint(equalTo: view.topAnchor),
            colourView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
