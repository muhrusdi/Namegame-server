import Vapor
import Fluent

final class User: Model {
    var id: Node?
    var name: String
    var matchNamePlays:Int
    var matchPicturePlays:Int
    var mattModePlays:Int
    var hintModePlays:Int
    
    init(name: String) {
        self.name = name
        matchNamePlays = 0
        matchPicturePlays = 0
        mattModePlays = 0
        hintModePlays = 0
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        matchNamePlays = try node.extract("matchNamePlays")
        matchPicturePlays = try node.extract("matchPicturePlays")
        mattModePlays = try node.extract("mattModePlays")
        hintModePlays = try node.extract("hintModePlays")
    }

    func makeNode() throws -> Node {
        return try Node(node: [
            "name": name
        ])
    }

    static func prepare(_ database: Database) throws {
        try database.create("user") { users in
            users.id()
            users.string("name")
            users.int("matchNamePlays")
            users.int("matchPicturePlays")
            users.int("mattModePlays")
            users.int("hintModePlays")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete("user")
    }
}
