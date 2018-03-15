enum LookupError: Error {
    case cannotLoadData
    case cannotParseData

    func description() -> String {
        switch self {
        case .cannotLoadData:
            return "Cannot download data from server"
        case .cannotParseData:
            return "Cannot parse downloaded data"
        }
    }
}
