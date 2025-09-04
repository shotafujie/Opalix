//
//  ArtworkThumbnailView.swift
//  NuriNuri
//
//  Created by Fujie Shota on 2025/09/03.
//

import SwiftUI

struct ArtworkThumbnailView: View {
    let artwork: Artwork
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // サムネイル
            ZStack {
                // 背景
                Rectangle()
                    .fill(artwork.backgroundColor.color)
                    .aspectRatio(artwork.canvasSize.width / artwork.canvasSize.height, contentMode: .fit)
                
                // フレーム
                Rectangle()
                    .stroke(artwork.frameColor.color, lineWidth: 3)
                    .aspectRatio(artwork.canvasSize.width / artwork.canvasSize.height, contentMode: .fit)
                
                // 図形プレビュー
                Canvas { context, size in
                    let scaleX = size.width / artwork.canvasSize.width
                    let scaleY = size.height / artwork.canvasSize.height
                    let scale = min(scaleX, scaleY)
                    
                    for shape in artwork.shapes.prefix(5) { // 最初の5つだけ表示
                        let scaledPosition = CGPoint(
                            x: shape.position.x * scaleX,
                            y: shape.position.y * scaleY
                        )
                        let scaledSize = CGSize(
                            width: shape.size.width * scale,
                            height: shape.size.height * scale
                        )
                        
                        context.fill(
                            Path(ellipseIn: CGRect(
                                x: scaledPosition.x - scaledSize.width/2,
                                y: scaledPosition.y - scaledSize.height/2,
                                width: scaledSize.width,
                                height: scaledSize.height
                            )),
                            with: .color(shape.color.color)
                        )
                    }
                }
                .aspectRatio(artwork.canvasSize.width / artwork.canvasSize.height, contentMode: .fit)
            }
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            .onTapGesture {
                onTap()
            }
            .contextMenu {
                Button("編集", systemImage: "pencil") {
                    onTap()
                }
                
                Button("削除", systemImage: "trash", role: .destructive) {
                    showingDeleteAlert = true
                }
            }
            
            // 作品情報
            VStack(alignment: .leading, spacing: 4) {
                Text(artwork.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(artwork.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if artwork.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert("作品を削除", isPresented: $showingDeleteAlert) {
            Button("削除", role: .destructive) {
                onDelete()
            }
            Button("キャンセル", role: .cancel) { }
        } message: {
            Text("「\(artwork.name)」を削除しますか？この操作は取り消せません。")
        }
    }
}

#Preview {
    let sampleArtwork = Artwork(name: "サンプル作品")
    
    ArtworkThumbnailView(
        artwork: sampleArtwork,
        onTap: { print("タップされました") },
        onDelete: { print("削除されました") }
    )
    .frame(width: 250)
    .padding()
}
