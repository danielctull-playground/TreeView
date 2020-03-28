
import SwiftUI

public struct TreeView<Value, ID: Hashable, Content: View>: View {

    fileprivate let tree: Tree<Value>
    fileprivate let id: KeyPath<Value, ID>
    fileprivate let content: (Value) -> Content

    public init(tree: Tree<Value>,
                id: KeyPath<Value, ID>,
                content: @escaping (Value) -> Content) {
        self.tree = tree
        self.id = id
        self.content = content
    }

    public var body: some View {
        ItemsView(tree: tree, id: id, content: content)
            .backgroundPreferenceValue(CenterKey.self) {
                LinesView(tree: self.tree, id: self.id, centers: $0)
            }
    }
}

fileprivate struct LinesView<Value, ID: Hashable>: View {

    let tree: Tree<Value>
    let id: KeyPath<Value, ID>
    let centers: [ID: Anchor<CGPoint>]

    private func point(for value: Value, in proxy: GeometryProxy) -> CGPoint? {
        guard let anchor = centers[id(value)] else { return nil }
        return proxy[anchor]
    }

    private func line(to child: Tree<Value>, in proxy: GeometryProxy) -> Line? {
        guard let start = point(for: tree.value, in: proxy) else { return nil }
        guard let end = point(for: child.value, in: proxy) else { return nil }
        return Line(start: start, end: end)
    }

    var body: some View {
        GeometryReader { proxy in
            ForEach(self.tree.children, id: \Tree.value + self.id) { child in
                Group {
                    self.line(to: child, in: proxy)?
                        .stroke()
                    LinesView(tree: child, id: self.id, centers: self.centers)
                }
            }
        }
    }
}

fileprivate struct Line: Shape {

    init(start: CGPoint, end: CGPoint) {
        animatableData = AnimatablePair(AnimatablePair(start.x, start.y), AnimatablePair(end.x, end.y))
    }

    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, AnimatablePair<CGFloat, CGFloat>>
    var start: CGPoint { CGPoint(x: animatableData.first.first, y: animatableData.first.second) }
    var end: CGPoint { CGPoint(x: animatableData.second.first, y: animatableData.second.second) }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
}

fileprivate struct ItemsView<Value, ID: Hashable, Content: View>: View {

    let tree: Tree<Value>
    let id: KeyPath<Value, ID>
    let content: (Value) -> Content

    var body: some View {
        VStack {
            content(tree.value)
                .anchorPreference(key: CenterKey.self, value: .center) { anchor in
                    [self.tree.value[keyPath: self.id]: anchor]
                }
            HStack(alignment: .top) {
                ForEach(tree.children, id: \Tree.value + self.id) { child in
                    ItemsView(tree: child, id: self.id, content: self.content)
                }
            }
        }
    }
}

extension KeyPath {
    func callAsFunction(_ root: Root) -> Value { root[keyPath: self] }
}

fileprivate func +<A, B, C>(
    lhs: KeyPath<A, B>,
    rhs: KeyPath<B, C>
) -> KeyPath<A, C> {
    lhs.appending(path: rhs)
}

fileprivate struct CenterKey<ID: Hashable>: PreferenceKey {
    static var defaultValue: [ID: Anchor<CGPoint>] { [:] }
    static func reduce(value: inout [ID: Anchor<CGPoint>], nextValue: () -> [ID: Anchor<CGPoint>]) {
        value = value.merging(nextValue(), uniquingKeysWith: { $1 })
    }
}
