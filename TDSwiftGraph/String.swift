//
//  String.swift
//  TDSwiftGraph
//
//  Created by Tieshow Daniels on 4/17/17.
//  Copyright © 2017 Ty Daniels. All rights reserved.
//

import Foundation

extension String {
    public func indexOfCharacter(char: Character) -> Int? {
        if let idx = self.characters.index(of: char) {
            return self.distance(from: startIndex, to: idx)
        }
        return nil
    }
}
