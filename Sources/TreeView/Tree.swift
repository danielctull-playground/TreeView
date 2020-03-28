
public struct Tree<Value> {
    public let value: Value
    public var children: [Tree<Value>]

    public init(value: Value, children: [Tree<Value>] = []) {
        self.value = value
        self.children = children
    }
}
