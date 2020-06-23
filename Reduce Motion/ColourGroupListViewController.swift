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
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(ColourTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private lazy var dataSource = ColourPaletteTableViewDataSource(tableView: tableView) { [weak self] (tableView, indexPath, colourData) -> UITableViewCell? in
        guard let self = self else { return nil }
        let colourCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ColourTableViewCell
        colourCell.colourData = colourData
        return colourCell
    }
    
    init(colourPalette: ColourPalette) {
        super.init(nibName: nil, bundle: nil)
        title = colourPalette.name
        var snapshot = NSDiffableDataSourceSnapshot<TableSection, ColourData>()
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
        tableView.dataSource = dataSource
    }
}

private enum TableSection: Hashable {
    case colourList(name: String)
}

private class ColourPaletteTableViewDataSource: UITableViewDiffableDataSource<TableSection, ColourData> {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch snapshot().sectionIdentifiers[section] {
        case .colourList(let name):
            return name
        }
    }
}
