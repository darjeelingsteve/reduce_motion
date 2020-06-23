//
//  ColourTableViewCell.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 23/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The table cell used to show a `ColourData` instance.
final class ColourTableViewCell: UITableViewCell {
    
    /// The colour data displayed by the receiver.
    var colourData: ColourData? {
        didSet {
            textLabel?.text = colourData?.name
            colourWell.colourData = colourData
        }
    }
    
    private let colourWell = ColourWellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(colourWell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        colourWell.sizeToFit()
        colourWell.frame = CGRect(origin: CGPoint(x: contentView.bounds.maxX - contentView.layoutMargins.right - colourWell.frame.width, y: (contentView.bounds.height - colourWell.frame.height) / 2),
                                   size: colourWell.frame.size).integral
        
        guard let textLabel = textLabel else { return }
        textLabel.frame.size.width = contentView.bounds.width - textLabel.frame.minX - contentView.layoutMargins.right - colourWell.bounds.width - 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        colourData = nil
    }
}

private final class ColourWellView: UIView {
    var colourData: ColourData? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        colourData?.colour.set()
        UIBezierPath(roundedRect: rect, cornerRadius: 6).fill()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 24, height: 24)
    }
}
