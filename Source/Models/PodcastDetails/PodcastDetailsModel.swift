//
//

import Foundation

public func dataFromFile(_ filename: String) -> Data? {
    @objc class TestClass: NSObject { }

    let bundle = Bundle(for: TestClass.self)
    if let path = bundle.path(forResource: filename, ofType: "json") {
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    }
    return nil
}

class PodcastDetails {
    var season1: String?
    var about: String?

    init?(data: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let body = json["data"] as? [String: Any] {
                self.about = body["about"] as? String
                self.season1 = body["email"] as? String
            }
        } catch {
            print("Error deserializing JSON: \(error)")
            return nil
        }
    }
}
