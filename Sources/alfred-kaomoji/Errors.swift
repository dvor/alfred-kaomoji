struct LookupError: Error {
    let errorDescription: String?

    init(_ message: String) {
        self.errorDescription = message
    }
}
