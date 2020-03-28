
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
    }
}

fileprivate struct ItemsView<Value, ID: Hashable, Content: View>: View {

    let tree: Tree<Value>
    let id: KeyPath<Value, ID>
    let content: (Value) -> Content

    var body: some View {
        VStack {
            content(tree.value)
                .anchorPreference(key: CenterKey.self, value: .center, transform: { anchor in
                    [self.tree.value[keyPath: self.id]: anchor]
                })
            HStack(alignment: .top) {
                ForEach(tree.children.indices) { index in
                    ItemsView(tree: self.tree.children[index], id: self.id, content: self.content)
                }
            }
        }
    }
}

fileprivate struct CenterKey<ID: Hashable>: PreferenceKey {
    static var defaultValue: [ID: Anchor<CGPoint>] { [:] }
    static func reduce(value: inout [ID: Anchor<CGPoint>], nextValue: () -> [ID: Anchor<CGPoint>]) {
        value = value.merging(nextValue(), uniquingKeysWith: { $1 })
    }
}
