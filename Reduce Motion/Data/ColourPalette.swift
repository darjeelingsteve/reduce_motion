//
//  ColourPalette.swift
//  Reduce Motion
//
//  Created by Stephen Anthony on 20/06/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// Represents a palette of colours.
struct ColourPalette: Codable, Hashable {
    static let systemColours = try! JSONDecoder().decode(ColourPalette.self, from: Data(contentsOf: Bundle.main.url(forResource: "System Colours", withExtension: "json")!))
    
    /// The name of the palette.
    let name: String
    
    /// The colour groups contained in the palette.
    let colourGroups: [ColourGroup]
}

/// Represents a group of colours.
struct ColourGroup: Codable, Hashable {
    
    /// The name of the group.
    let name: String
    
    /// The colour data contained in the group.
    let colours: [ColourData]
}

/// Represents the information about a colour.
struct ColourData: Codable, Hashable {
    
    /// The name of the colour.
    let name: String
    
    /// The colour instance.
    let colour: UIColor
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        colour = UIColor.value(forKey: name + "Color") as! UIColor
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
