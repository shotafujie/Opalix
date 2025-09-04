//
//  HomeView.swift
//  NuriNuri
//
//  Created by Fujie Shota on 2025/09/03.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var artworkStore = ArtworkStore()
    @State private var showingNewArtwork = false
    @State private var selectedArtwork: Artwork? = nil
    
    // グリッドレイアウト（iPad用3列）
    private let gridColumns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ヘッダー
                headerView
                
                // メインコンテンツ
                if artworkStore.artworks.isEmpty {
                    emptyStateView
                } else {
                    galleryView
                }
                
                Spacer()
                
                // 新規作成ボタン
                newArtworkButton
            }
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showingNewArtwork) {
            SizeSelectionView(artworkStore: artworkStore)
        }
        .navigationDestination(item: $selectedArtwork){ artwork in
            CanvasView(artworkStore: artworkStore, artwork: artwork)
        }
    }
    
    // MARK: - View Components
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("NuriNuri")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("あなただけの美術館")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("プレミアム") {
                // TODO: プレミアム画面
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 24)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(spacing: 12) {
                Text("まだ作品がありません")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("下の「新規作成」ボタンで\n最初の作品を作ってみましょう！")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var galleryView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 24) {
                ForEach(artworkStore.artworks) { artwork in
                    ArtworkThumbnailView(
                        artwork: artwork,
                        onTap: {
                            // TODO: 編集画面への遷移
                            selectedArtwork = artwork
                        },
                        onDelete: {
                            artworkStore.deleteArtwork(artwork)
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 100) // 新規作成ボタンの余白
        }
    }
    
    private var newArtworkButton: some View {
        Button(action: {
            showingNewArtwork = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("新規作成")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [.blue, .cyan],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }
}

#Preview {
    HomeView()
}
