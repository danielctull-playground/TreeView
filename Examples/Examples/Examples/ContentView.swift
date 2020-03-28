
import SwiftUI
import TreeView

struct ContentView: View {

    let tree = Tree(value: "One", children: [
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

    var body: some View {
        TreeView(tree: tree, id: \.self) { value in
            Text(value)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 4).stroke(Color.gray))
                .padding(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
