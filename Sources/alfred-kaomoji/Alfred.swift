import SwiftyJSON

struct AlfredService {
    func output(items: [AlfredItem]) {
        let formatted = items.map {[
            "type": "default",
            "uid": $0.uid,
            "title": $0.title,
            "arg": $0.arg,
        ]}

        let result = JSON(["items": formatted])
        print(result)
    }

    func output(error: AlfredError) {
        let result = JSON(["items" : [
            "valid": false,
            "type": "default",
            "title": error.title,
            "subtitle": error.subtitle,
        ]])
        print(result)
    }
}

struct AlfredItem {
    let uid: String
    let title: String
    let arg: String
}

struct AlfredError {
    let title: String
    let subtitle: String
}
