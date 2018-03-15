import SwiftyJSON
import Foundation

struct LookupError: LocalizedError {
    let errorDescription: String?

    init(_ message: String) {
        self.errorDescription = message
    }
}

let query = CommandLine.arguments.dropFirst().joined(separator: " ")

var urlComponents = URLComponents(string: "https://customer.getdango.com/dango/api/query/kaomoji")!
urlComponents.query = "q=" + query
let url = urlComponents.url!

do {
    guard let data = try? Data(contentsOf: url) else {
        throw LookupError("Cannot download kaomoji data")
    }
    guard let json = try? JSON(data: data) else {
        throw LookupError("Cannot parse downloaded data")
    }
    let items = json["items"].arrayValue
        .map {[
            "uid": url.absoluteString,
            "type": "default",
            "title": $0["text"],
            "autocomplete": $0["text"],
            "quicklookurl": url.absoluteString,
            "arg": $0["text"],
        ]}

    let result = JSON(["items" : items])
    print(result)
}
catch {
    let report: [String: Any] = [
        "valid": false,
        "type": "default",
        "title": "Kaomoji service is unavailable",
        "subtitle": "\(error.localizedDescription)",
    ]
    let resultData = try JSONSerialization.data(withJSONObject: ["items": [report]], options: .prettyPrinted)
    print(String(data: resultData, encoding: .utf8)!)
}
