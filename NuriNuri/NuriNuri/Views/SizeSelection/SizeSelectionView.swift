import SwiftUI

struct SizeSelectionView: View {
    @ObservedObject var artworkStore: ArtworkStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedSize: CGSize = .landscape43
    @State private var artworkName = "新規作品"
    
    private let sizeOptions: [(CGSize, String, String)] = [
        (.landscape43, "横長（4:3）", "風景・自然に最適"),
        (.square, "正方形（1:1）", "SNS投稿に最適"),
        (.portrait34, "縦長（3:4）", "ポートレートに最適"),
        (.wide169, "ワイド（16:9）", "映画風の構図")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("新規作品を作成")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("キャンバスサイズを選択してください")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 24)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("作品名")
                        .font(.headline)
                    TextField("作品名を入力", text: $artworkName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.body)
                }
                .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("キャンバスサイズ")
                        .font(.headline)
                        .padding(.horizontal, 24)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(sizeOptions, id: \.0) { size, title, description in
                                SizeOptionView(
                                    size: size,
                                    title: title,
                                    description: description,
                                    isSelected: selectedSize == size,
                                    onTap: { selectedSize = size }
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                
                Spacer()

                Button("作品を作成開始") {
                    let finalName = artworkName.trimmingCharacters(in: .whitespacesAndNewlines)
                    artworkStore.createArtwork(
                        name: finalName.isEmpty ? "新規作品" : finalName,
                        canvasSize: selectedSize
                    )
                    dismiss()
                }
                .font(.headline)
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
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") { dismiss() }
                }
            }
        }
    }
}

struct SizeOptionView: View {
    let size: CGSize
    let title: String
    let description: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primary, lineWidth: 1)
                    )
                    .frame(width: 60, height: 60 * (size.height / size.width))
                    .aspectRatio(size.width / size.height, contentMode: .fit)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(size.width)) × \(Int(size.height))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color(.separator), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SizeSelectionView(artworkStore: ArtworkStore())
}

