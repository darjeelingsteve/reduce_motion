//
//  ColourPaletteViewController.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 20/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// Displays a list of colour groups.
final class ColourPaletteViewController: UIViewController {
    
    /// The delegate of the receiver.
    weak var delegate: ColourPaletteViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ColourTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var dataSource = ColourPaletteTableViewDataSource(tableView: tableView) { [weak self] (tableView, indexPath, colourDetails) -> UITableViewCell? in
        guard let self = self else { return nil }
        let colourCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ColourTableViewCell
        colourCell.colourDetails = colourDetails
        colourCell.accessoryType = .disclosureIndicator
        return colourCell
    }
    
    init(colourPalette: ColourPalette) {
        super.init(nibName: nil, bundle: nil)
        title = colourPalette.name
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, ColourDetails>()
        colourPalette.colourGroups.forEach { (colourGroup) in
            snapshot.appendSections([.colourList(name: colourGroup.name)])
            snapshot.appendItems(colourGroup.colours)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.delegate = self
    }
}

// MARK: - UITableViewDelegate

extension ColourPaletteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedColourDetails = dataSource.itemIdentifier(for: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ColourTableViewCell
        delegate?.colourPaletteViewController(self,
                                              didSelectColourDetails: selectedColourDetails,
                                              selectionRect: view.convert(cell.colourWellFrame, from: cell))
    }
}

/// The protocol to conform to for delegates of `ColourPaletteViewController`.
protocol ColourPaletteViewControllerDelegate: AnyObject {
    
    /// The message sent when the user selects a colour from the sender's list.
    /// - Parameters:
    ///   - colourPaletteViewController: The controller sending the message.
    ///   - colourDetails: The colour details representing the colour the user
    ///   selected.
    ///   - selectionRect: The rect in the sender's view's coordinate space at
    ///   which the user selected the given colour data.
    func colourPaletteViewController(_ colourPaletteViewController: ColourPaletteViewController, didSelectColourDetails colourDetails: ColourDetails, selectionRect: CGRect)
}

private enum TableSection: Hashable {
    case colourList(name: String)
}

private class ColourPaletteTableViewDataSource: UITableViewDiffableDataSource<TableSection, ColourDetails> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch snapshot().sectionIdentifiers[section] {
        case .colourList(let name):
            return name
        }
    }
}
