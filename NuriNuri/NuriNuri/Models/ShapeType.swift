import Foundation
import SwiftUI

enum ShapeType: String, CaseIterable, Identifiable, Codable {  // <- Codable追加
    // 基本図形（無料15種類）
    case circle = "circle"
    case rectangle = "rectangle"
    case square = "square"
    case triangle = "triangle"
    case star5 = "star5"
    case star6 = "star6"
    case pentagon = "pentagon"
    case hexagon = "hexagon"
    case ellipse = "ellipse"
    case heart = "heart"
    case droplet = "droplet"
    case cloud = "cloud"
    case crescent = "crescent"
    case flower5 = "flower5"
    case butterfly = "butterfly"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .circle: return "円"
        case .rectangle: return "長方形"
        case .square: return "正方形"
        case .triangle: return "三角形"
        case .star5: return "星（5角）"
        case .star6: return "星（6角）"
        case .pentagon: return "五角形"
        case .hexagon: return "六角形"
        case .ellipse: return "楕円"
        case .heart: return "ハート"
        case .droplet: return "水滴"
        case .cloud: return "雲"
        case .crescent: return "三日月"
        case .flower5: return "花（5弁）"
        case .butterfly: return "蝶々"
        }
    }
    
    var isFree: Bool {
        // 基本15種類は全て無料
        return true
    }
    
    var systemImage: String {
        // SF Symbolsで近い形を使用（仮）
        switch self {
        case .circle: return "circle"
        case .rectangle: return "rectangle"
        case .square: return "square"
        case .triangle: return "triangle"
        case .star5: return "star"
        case .star6: return "star"
        case .pentagon: return "pentagon"
        case .hexagon: return "hexagon"
        case .ellipse: return "oval"
        case .heart: return "heart"
        case .droplet: return "drop"
        case .cloud: return "cloud"
        case .crescent: return "moon"
        case .flower5: return "flower"
        case .butterfly: return "ladybug"
        }
    }
}

