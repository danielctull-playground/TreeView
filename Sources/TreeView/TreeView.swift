
import SwiftUI

public struct TreeView<Value, Content>: View
    where
Content: View {

    let tree: Tree<Value>
    let content: (Value) -> Content

    public init(tree: Tree<Value>,
                content: @escaping (Value) -> Content) {
        self.tree = tree
        self.content = content
    }

    public var body: some View {
        VStack {
            content(tree.value)
            HStack(alignment: .top) {
                ForEach(tree.children.indices) { index in
                    TreeView(tree: self.tree.children[index], content: self.content)
                }
            }
        }
    }
}
