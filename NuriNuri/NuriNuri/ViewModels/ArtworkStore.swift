//
//  ArtworkStore.swift
//  NuriNuri
//
//  Created by Fujie Shota on 2025/09/03.
//import Foundation
import SwiftUI

@MainActor
class ArtworkStore: ObservableObject {
    @Published var artworks: [Artwork] = []
    @Published var currentArtwork: Artwork?

    init() {
        loadArtworks()
    }

    func createArtwork(name: String = "新規作品", canvasSize: CGSize = .landscape43) {
        let artwork = Artwork(name: name, canvasSize: canvasSize)
        artworks.append(artwork)
        currentArtwork = artwork
        saveArtworks()
    }

    func updateArtwork(_ artwork: Artwork) {
        if let index = artworks.firstIndex(where: { $0.id == artwork.id }) {
            artworks[index] = artwork
            if currentArtwork?.id == artwork.id {
                currentArtwork = artwork
            }
            saveArtworks()
        }
    }

    func deleteArtwork(_ artwork: Artwork) {
        artworks.removeAll { $0.id == artwork.id }
        if currentArtwork?.id == artwork.id {
            currentArtwork = nil
        }
        saveArtworks()
    }

    private func loadArtworks() {
        // 仮のサンプルデータ
        createSampleData()
    }

    private func saveArtworks() {
        // Core Data実装が後日
    }

    private func createSampleData() {
        var sample1 = Artwork(name: "サンプル作品1", canvasSize: .landscape43)
        sample1.addShape(Shape(type: .circle, position: CGPoint(x: 200, y: 150), color: .red))
        sample1.addShape(Shape(type: .star5, position: CGPoint(x: 400, y: 300), color: .yellow))
        var sample2 = Artwork(name: "サンプル作品2", canvasSize: .square)
        sample2.addShape(Shape(type: .heart, position: CGPoint(x: 300, y: 300), color: .pink))
        var sample3 = Artwork(name: "サンプル作品3", canvasSize: .wide169)
        sample3.addShape(Shape(type: .triangle, position: CGPoint(x: 480, y: 270), color: .green))
        artworks = [sample1, sample2, sample3]
    }
}


