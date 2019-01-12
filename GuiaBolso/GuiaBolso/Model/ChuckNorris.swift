//
//  ChuckNorris.swift
//  GuiaBolso
//
//  Created by Gustavo Quenca on 03/01/19.
//  Copyright © 2019 Quenca. All rights reserved.
//

import Foundation

class Category: Codable {
    var categoryResult: [CategoryDetail]
}

struct CategoryDetail: Codable {
    let category: [String]
    let icon_url: String
    let id: String
    let url: String
    let value: String
}

