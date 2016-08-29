import Vapor
import VaporMustache
import HTTP
import VaporMySQL
import Foundation


/**
    Droplets are service containers that make accessing
    all of Vapor's features easy. Just call
    `drop.serve()` to serve your application
    or `drop.client()` to create a client for
    request data from other servers.
*/
let droplet = Droplet(preparations:[User.self, Person.self], providers: [VaporMustache.Provider.self, VaporMySQL.Provider.self])


/**
    This first route will return the welcome.html
    view to any request to the root directory of the website.

    Views referenced with `app.view` are by default assumed
    to live in <workDir>/Resources/Views/ 

    You can override the working directory by passing
    --workDir to the application upon execution.
*/
droplet.get("/") { request in
    return try droplet.view("welcome.html")
}

droplet.group("api/v1") {api in
    
    api.get("people", handler: { (request:Request) -> ResponseRepresentable in
        let response = try droplet.client.get("http://api.namegame.willowtreemobile.com/")
        guard let bytes = response.body.bytes,
            let json = try? JSON(bytes: bytes),
            let array = json.array
            else { throw Abort.custom(status: Status.failedDependency, message: "Could not covert willowtree api for persons to data") }
        
        for object in array {
            guard let name = object.object!["name"].string,
                let url = object.object!["url"].string
                else { throw Abort.custom(status: Status.noContent, message: "Could not parse willowtree api for person")}
            print("name: \(name), url: \(url)")
        }
        return response
    })
    
    api.get("game_modes", handler: { (request:Request) -> ResponseRepresentable in
        return try JSON([
            "Match Name",
            "Match Picture",
            "Matt Mode",
            "Hint Mode"
        ])
    })
    
    api.post("user", handler: { (request:Request) -> ResponseRepresentable in
        guard let username = request.data["username"].string else {
            throw Abort.custom(status: Status.unauthorized, message: "Username empty")
        }
        
        if let found = try User.query().filter("username", username).first() {
            throw Abort.custom(status: Status.unauthorized, message: "Username taken")
        }
        
        var user = User(name: username)
        try user.save()
        return user
    })
}


droplet.middleware.append(SampleMiddleware())


droplet.serve()
