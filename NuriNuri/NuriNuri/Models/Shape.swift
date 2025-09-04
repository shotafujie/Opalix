//
//  Shape.swift
//  NuriNuri
//
//  Created by Fujie Shota on 2025/09/03.
//

import Foundation
import SwiftUI

struct Shape: Identifiable, Codable, Hashable {
    let id: UUID
    let type: ShapeType
    var position: CGPoint
    var size: CGSize
    var rotation: CGFloat
    var color: CodableColor
    var opacity: CGFloat
    var zIndex: Int
    
    init(
        type: ShapeType,
        position: CGPoint = .zero,
        size: CGSize = CGSize(width: 100, height: 100),
        rotation: CGFloat = 0,
        color: CodableColor = CodableColor(.black),
        opacity: CGFloat = 1.0,
        zIndex: Int = 0
    ) {
        self.id = UUID()
        self.type = type
        self.position = position
        self.size = size
        self.rotation = rotation
        self.color = color
        self.opacity = opacity
        self.zIndex = zIndex
    }
}
