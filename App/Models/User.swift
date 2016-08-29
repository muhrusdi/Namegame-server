import Vapor
import Fluent

final class User: Model {
    var id: Node?
    var username: String
    var matchNamePlays:Int
    var matchPicturePlays:Int
    var mattModePlays:Int
    var hintModePlays:Int
    
    init(name: String) {
        self.username = name
        matchNamePlays = 0
        matchPicturePlays = 0
        mattModePlays = 0
        hintModePlays = 0
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        username = node["username"]?.string ?? ""
        matchNamePlays = node["matchNamePlays"]?.int ?? 0
        matchPicturePlays = node["matchPicturePlays"]?.int ?? 0
        mattModePlays = node["mattModePlays"]?.int ?? 0
        hintModePlays = node["hintModePlays"]?.int ?? 0
    }

    func makeNode() throws -> Node {
        return try Node(node: [
            "id":id,
            "username": username,
            "matchNamePlays":matchNamePlays,
            "matchPicturePlays":matchPicturePlays,
            "mattModePlays":mattModePlays,
            "hintModePlays":hintModePlays
        ])
    }

    static func prepare(_ database: Database) throws {
        try database.create(User.entity) { users in
            users.id()
            users.string("username")
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
