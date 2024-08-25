//
//  File.swift
//  Alias Game
//
//  Created by Егор Лукин on 11.07.2024.
//

import Foundation
class GussedAndMissed{
    static let shared = GussedAndMissed()
    private init(){}
    var GuessedArray: [String] = []
    var MissedArray: [String] = []
}
