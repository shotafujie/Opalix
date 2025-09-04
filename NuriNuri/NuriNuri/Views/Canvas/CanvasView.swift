import SwiftUI

struct CanvasView: View {
    @ObservedObject var artworkStore: ArtworkStore
    @State var artwork: Artwork
    @Environment(\.dismiss) private var dismiss
    @State private var selectedShapeID: UUID?
    @State private var isDragging = false

    // パレットに表示するShapeType
    let paletteTypes: [ShapeType] = [.rectangle, .circle, .triangle, .square, .star5]

    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Button("＜ホーム") {
                    artworkStore.updateArtwork(artwork)
                    dismiss()
                }
                Spacer()
                Text(artwork.name)
                    .font(.title3).fontWeight(.bold)
                Spacer()
                Button("保存") {
                    artworkStore.updateArtwork(artwork)
                }
            }
            .padding(.horizontal)
            .padding(.top,8)
            .padding(.bottom,8)
            .background(.ultraThinMaterial)

            // キャンバス本体
            GeometryReader { geo in
                ZStack {
                    // 背景
                    Rectangle()
                        .fill(artwork.backgroundColor.color)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(artwork.frameColor.color, lineWidth: 3))
                    // 配置済み図形
                    ForEach($artwork.shapes) { $shape in
                        CanvasShapeView(
                            shape: $shape,
                            isSelected: shape.id == selectedShapeID
                        )
                        .onTapGesture {
                            selectedShapeID = shape.id
                        }
                        // 移動
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if selectedShapeID == shape.id || selectedShapeID == nil {
                                        selectedShapeID = shape.id
                                        shape.position.x += value.translation.width
                                        shape.position.y += value.translation.height
                                        isDragging = true
                                    }
                                }
                                .onEnded { _ in isDragging = false }
                        )
                        // 拡大縮小
                        .simultaneousGesture(
                            MagnificationGesture()
                                .onChanged { scale in
                                    if selectedShapeID == shape.id {
                                        shape.size.width = max(30, shape.size.width * scale)
                                        shape.size.height = max(30, shape.size.height * scale)
                                    }
                                }
                        )
                    }
                }
                .padding()
                .frame(
                    width: min(geo.size.width, artwork.canvasSize.width) * 0.95,
                    height: min(geo.size.height * 0.88, artwork.canvasSize.height) * 0.95
                )
                .background(Color(UIColor.systemGroupedBackground))
            }

            // 下部: パレット
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(paletteTypes, id: \.rawValue) { type in
                        Button(action: {
                            let center = CGPoint(
                                x: artwork.canvasSize.width/2,
                                y: artwork.canvasSize.height/2
                            )
                            let newShape = Shape(type: type, position: center, color: CodableColor.black)
                            artwork.shapes.append(newShape)
                            selectedShapeID = newShape.id
                        }) {
                            VStack {
                                Image(systemName: type.systemImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(10)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .clipShape(Circle())
                                Text(type.displayName).font(.caption)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// ------- キャンバス上の図形1つ分 -------
struct CanvasShapeView: View {
    @Binding var shape: Shape
    let isSelected: Bool
    var body: some View {
        Group {
            switch shape.type {
            case .rectangle:
                Rectangle().fill(shape.color.color)
                    .frame(width: shape.size.width, height: shape.size.height)
                    .position(shape.position)
                    .overlay(
                        isSelected ?
                        RoundedRectangle(cornerRadius: 4).stroke(Color.blue, lineWidth: 2) : nil
                    )
            case .circle:
                Circle().fill(shape.color.color)
                    .frame(width: shape.size.width, height: shape.size.height)
                    .position(shape.position)
                    .overlay(
                        isSelected ?
                        Circle().stroke(Color.blue, lineWidth: 2) : nil
                    )
            case .triangle:
                Triangle()
                    .fill(shape.color.color)
                    .frame(width: shape.size.width, height: shape.size.height)
                    .position(shape.position)
                    .overlay(
                        isSelected ?
                        Triangle().stroke(Color.blue, lineWidth: 2) : nil
                    )
            case .square:
                Rectangle().fill(shape.color.color)
                    .frame(width: shape.size.width, height: shape.size.width)
                    .position(shape.position)
                    .overlay(
                        isSelected ?
                        RoundedRectangle(cornerRadius: 4).stroke(Color.blue, lineWidth: 2) : nil
                    )
            case .star5:
                Star5()
                    .fill(shape.color.color)
                    .frame(width: shape.size.width, height: shape.size.height)
                    .position(shape.position)
                    .overlay(
                        isSelected ?
                        Star5().stroke(Color.blue, lineWidth: 2) : nil
                    )
            default:
                Rectangle().fill(.gray)
                    .frame(width: shape.size.width, height: shape.size.height)
                    .position(shape.position)
            }
        }
        .shadow(color: isSelected ? .blue.opacity(0.3) : .gray.opacity(0.15), radius: 8)
    }
}

// ------- 三角形 -------
struct Triangle: SwiftUI.Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width, height = rect.height
        path.move(to: CGPoint(x: width/2, y: 0))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()
        return path
    }
}

// ------- 5角星 -------
struct Star5: SwiftUI.Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        var path = Path()
        for i in 0..<5 {
            let angle = CGFloat(i) * .pi * 2 / 5 - .pi/2
            let pt = CGPoint(
                x: center.x + r * cos(angle),
                y: center.y + r * sin(angle)
            )
            if i == 0 { path.move(to: pt) }
            else { path.addLine(to: pt) }
        }
        path.closeSubpath()
        return path
    }
}

