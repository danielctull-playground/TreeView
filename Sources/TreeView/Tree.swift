
public struct Tree<Value> {
    let value: Value
    let children: [Tree<Value>]

    public init(value: Value, children: [Tree<Value>] = []) {
        self.value = value
        self.children = children
    }
}
