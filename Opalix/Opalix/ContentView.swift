import SwiftUI

// 図形タイプのenum（ラベル付き/拡張性あり）
enum ShapeType: String, CaseIterable {
    case circle, triangle, capsule, ellipse, square, roundedRect

    var label: String {
        switch self {
        case .circle: return "円"
        case .triangle: return "三角"
        case .capsule: return "カプセル"
        case .ellipse: return "楕円"
        case .square: return "四角"
        case .roundedRect: return "角丸四角"
        }
    }
}

// 履歴用
struct MoodSelection: Identifiable {
    let id = UUID()
    let color: Color
    let shape: ShapeType
}

// Shapeラッパー
struct AnyShape: Shape {
    private let _path: @Sendable(CGRect) -> Path
    init<S: Shape>(_ shape: S) { self._path = { shape.path(in: $0) } }
    func path(in rect: CGRect) -> Path { _path(rect) }
}

// 三角形実装
struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// ランダム選択肢生成
func makeRandomOptions() -> [(Color, ShapeType)] {
    var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .mint, .teal]
    var shapes: [ShapeType] = ShapeType.allCases
    colors.shuffle()
    shapes.shuffle()
    return (0..<4).map { (colors[$0], shapes[$0]) }
}

// メインビュー
struct ContentView: View {
    @State private var selectionOptions: [(Color, ShapeType)] = makeRandomOptions()
    @State private var selectedList: [MoodSelection] = []
    @State private var canAdd = true
    @State private var timer: Timer?
    @State private var intervalRemain: Int = 0

    var body: some View {
        VStack(spacing: 18) {
            Text("Opalix")
                .font(.largeTitle.bold())
                .padding(.top, 24)
            // 質問 or カウントダウン
            ZStack {
                if canAdd {
                    Text("今の気分は？")
                        .font(.caption)
                        .foregroundColor(.black)
                } else {
                    Text("次の選択まで \(intervalRemain) 秒")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .transition(.opacity)
                }
            }
            .frame(height: 16)

            // 4択ボタン
            HStack(spacing: 22) {
                ForEach(selectionOptions.indices, id: \.self) { idx in
                    let option = selectionOptions[idx]
                    Button(action: {
                        if canAdd {
                            selectedList.append(MoodSelection(color: option.0, shape: option.1))
                            canAdd = false
                            intervalRemain = 10
                            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tm in
                                if intervalRemain > 1 {
                                    intervalRemain -= 1
                                } else {
                                    canAdd = true
                                    selectionOptions = makeRandomOptions()
                                    tm.invalidate()
                                }
                            }
                        }
                    }) {
                        // 図形ごとにframeを変更し見た目を統一！
                        shapeButtonView(type: option.1, color: option.0)
                    }
                    .disabled(!canAdd)
                }
            }
            .padding(.bottom, 5)

            // アート領域
            OpalixArtView(selections: selectedList, seed: generateSeed(for: selectedList))
                .frame(width: 260, height: 260)
                .padding(.vertical)

            // 選択履歴表示（同じく見た目統一）
            if !selectedList.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(selectedList) { sel in
                            shapeMiniView(type: sel.shape, color: sel.color)
                        }
                    }
                }
                .padding(.top, 4)
            }

            Spacer()
        }
        .padding()
    }

    // ボタン用 Shape+ラベル
    func shapeButtonView(type: ShapeType, color: Color) -> some View {
        ZStack {
            switch type {
            case .ellipse:
                Ellipse()
                    .fill(color)
                    .frame(width: 56, height: 30)
            case .capsule:
                Capsule()
                    .fill(color)
                    .frame(width: 56, height: 24)
            case .circle:
                Circle()
                    .fill(color)
                    .frame(width: 48, height: 48)
            case .triangle:
                TriangleShape()
                    .fill(color)
                    .frame(width: 48, height: 48)
            case .square:
                Rectangle()
                    .fill(color)
                    .frame(width: 44, height: 44)
            case .roundedRect:
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: 48, height: 36)
            }
        }
        .shadow(radius: 2)
    }

    // 履歴小アイコン
    func shapeMiniView(type: ShapeType, color: Color) -> some View {
        switch type {
        case .ellipse:
            return AnyView(Ellipse().fill(color).frame(width: 28, height: 14))
        case .capsule:
            return AnyView(Capsule().fill(color).frame(width: 28, height: 10))
        case .circle:
            return AnyView(Circle().fill(color).frame(width: 20, height: 20))
        case .triangle:
            return AnyView(TriangleShape().fill(color).frame(width: 20, height: 20))
        case .square:
            return AnyView(Rectangle().fill(color).frame(width: 18, height: 18))
        case .roundedRect:
            return AnyView(RoundedRectangle(cornerRadius: 6).fill(color).frame(width: 20, height: 15))
        }
    }

    func generateSeed(for selections: [MoodSelection]) -> Int {
        var seed = 1
        for item in selections {
            seed = (seed &* 31) &+ item.color.description.hashValue &+ item.shape.rawValue.hashValue
        }
        return abs(seed)
    }
}

// アート描画ビュー
struct OpalixArtView: View {
    let selections: [MoodSelection]
    let seed: Int

    var body: some View {
        Canvas { ctx, size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let rbase: CGFloat = min(size.width, size.height) * 0.36
            for (i, sel) in selections.enumerated() {
                let angle = Double(i) * (2 * Double.pi / Double(max(1, selections.count)))
                let x = center.x + cos(angle) * Double(rbase)
                let y = center.y + sin(angle) * Double(rbase)

                switch sel.shape {
                case .circle:
                    let rect = CGRect(x: x-30, y: y-30, width: 60, height: 60)
                    ctx.fill(Path(ellipseIn: rect), with: .color(sel.color))
                case .ellipse:
                    let rect = CGRect(x: x-34, y: y-16, width: 68, height: 32)
                    ctx.fill(Path(ellipseIn: rect), with: .color(sel.color))
                case .capsule:
                    let rect = CGRect(x: x-34, y: y-12, width: 68, height: 24)
                    ctx.fill(Path(roundedRect: rect, cornerRadius: 12), with: .color(sel.color))
                case .triangle:
                    let rect = CGRect(x: x-30, y: y-30, width: 60, height: 60)
                    var path = Path()
                    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                    path.closeSubpath()
                    ctx.fill(path, with: .color(sel.color))
                case .square:
                    let rect = CGRect(x: x-24, y: y-24, width: 48, height: 48)
                    ctx.fill(Path(CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.width, height: rect.height)), with: .color(sel.color))
                case .roundedRect:
                    let rect = CGRect(x: x-30, y: y-18, width: 60, height: 36)
                    ctx.fill(Path(roundedRect: rect, cornerRadius: 12), with: .color(sel.color))
                }
            }
        }
        .background(.white.opacity(0.7))
        .cornerRadius(22)
        .shadow(radius: 8)
    }
}

#Preview { ContentView() }

