import Vapor
import VaporMustache
import HTTP
import VaporMySQL


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
        let respone = try droplet.client.get("http://api.namegame.willowtreemobile.com/")
        return respone
    })
    
    api.get("people", Int.self, handler: { (request:Request, url:Int) -> ResponseRepresentable in
        return try JSON(["😄"])
    })
}


droplet.middleware.append(SampleMiddleware())


droplet.serve()
