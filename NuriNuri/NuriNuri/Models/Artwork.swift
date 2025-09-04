//
//  Artwork.swift
//  NuriNuri
//
//  Created by Fujie Shota on 2025/09/03.
//

import Foundation
import SwiftUI

struct CodableColor: Hashable, Codable {
    // 静的プロパティ
    static let red = CodableColor(.red)
    static let green = CodableColor(.green)
    static let blue = CodableColor(.blue)
    static let pink = CodableColor(.pink)
    static let white = CodableColor(.white)
    static let black = CodableColor(.black)
    static let yellow = CodableColor(.yellow)
    
    // インスタンスプロパティ
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double

    init(_ color: Color) {
        // UIColorに変換してからrgbaを取り出し
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.red = Double(r)
        self.green = Double(g)
        self.blue = Double(b)
        self.opacity = Double(a)
    }

    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}


struct Artwork: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    let createdAt: Date
    var updatedAt: Date
    let canvasSize: CGSize
    var backgroundColor: CodableColor
    var frameColor: CodableColor
    var shapes: [Shape]
    var isFavorite: Bool
    
    init(
        name: String = "あたらしいぬりえ",
        canvasSize: CGSize = .landscape43,
        backgroundColor: CodableColor = CodableColor(.white),
        frameColor: CodableColor = CodableColor(.black)
    ) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.updatedAt = Date()
        self.canvasSize = canvasSize
        self.backgroundColor = backgroundColor
        self.frameColor = frameColor
        self.shapes = []
        self.isFavorite = false
    }
    
    mutating func addShape(_ shape: Shape) {
        shapes.append(shape)
        updatedAt = Date()
    }
    
    mutating func removeShape(withId id: UUID) {
        shapes.removeAll { $0.id == id }
        updatedAt = Date()
    }
    
    mutating func updateShape(_ updatedShape: Shape) {
        if let index = shapes.firstIndex(where: { $0.id == updatedShape.id }) {
            shapes[index] = updatedShape
            updatedAt = Date()
        }
    }
}

// プリセットキャンバスサイズ
extension CGSize{
    static let landscape43 = CGSize(width: 800, height: 600)    // 4:3横長（デフォルト）
    static let square = CGSize(width: 600, height: 600)         // 1:1正方形
    static let portrait34 = CGSize(width: 600, height: 800)     // 3:4縦長
    static let wide169 = CGSize(width: 960, height: 540)        // 16:9ワイド
    
    var displayName: String {
        switch self {
        case .landscape43: return "横長（4:3）"
        case .square: return "正方形（1:1）"
        case .portrait34: return "縦長（3:4）"
        case .wide169: return "ワイド（16:9）"
        default: return "カスタム"
        }
    }
}
