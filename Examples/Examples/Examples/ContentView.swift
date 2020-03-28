
import SwiftUI
import TreeView

fileprivate var index = (0...).makeIterator()

struct ContentView: View {

    @State var tree = Tree(value: "One", children: [
        Tree(value: "Two"),
        Tree(value: "Three", children: [
            Tree(value: "Four", children: [
                Tree(value: "Five")
            ]),
            Tree(value: "Six", children: [
                Tree(value: "Seven")
            ])
        ])
    ])

    func insertRandom() {
        withAnimation {
            tree.insertRandom("New \(index.next()!)")
        }
    }

    var body: some View {
        VStack {
            treeView
            Spacer()
            Button(action: insertRandom) { Text("Insert Random") }
        }
        .padding()
    }

    var treeView: some View {
        TreeView(tree: tree, id: \.self) { value in
            Text(value)
                .fixedSize()
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 4).fill(Color.white))
                .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                .padding(8)
                .foregroundColor(.black)
        }
        .foregroundColor(.gray)
    }
}

extension Tree {

    mutating func insertRandom(_ value: Value) {
        let index = children.indices.randomElement() ?? 0
        if children.isEmpty || Bool.random() {
            children.insert(Tree(value: value), at: index)
        } else {
            children[index].insertRandom(value)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
