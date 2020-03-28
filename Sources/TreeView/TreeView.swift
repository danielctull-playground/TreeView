
import SwiftUI

public struct TreeView<Value, Content: View>: View {

    fileprivate let tree: Tree<Value>
    fileprivate let content: (Value) -> Content

    public init(tree: Tree<Value>,
                content: @escaping (Value) -> Content) {
        self.tree = tree
        self.content = content
    }

    public var body: some View {
        ItemsView(tree: tree, content: content)
    }
}

fileprivate struct ItemsView<Value, Content: View>: View {

    let tree: Tree<Value>
    let content: (Value) -> Content

    var body: some View {
        VStack {
            content(tree.value)
            HStack(alignment: .top) {
                ForEach(tree.children.indices) { index in
                    ItemsView(tree: self.tree.children[index], content: self.content)
                }
            }
        }
    }
}
