import UIKit
import SwiftyJSON
import DateTools

struct Micropost {
    let userName: String,
        content: String,
        picture: NSURL?,
        userId: Int,
        userIcon: NSURL,
        timeAgoInWords: String,
        unixTimeCreatedAt: Int,
        id: Int

    init(data: JSON) {
        var picture_url = ""
        if let url = data["picture"]["url"].string {
            picture_url = url
        }

        userName = data["user"]["name"].stringValue
        content = data["content"].stringValue
        picture = picture_url.isEmpty ? nil : NSURL(string: picture_url)
        userId = data["user_id"].intValue
        userIcon = NSURL(string: data["user"]["icon_url"].stringValue)!
        timeAgoInWords = data["time_ago_in_words"].stringValue
        unixTimeCreatedAt = data["unix_time_created_at"].intValue
        id = data["id"].intValue
    }

    func havePicture() -> Bool {
        return picture != nil
    }

    func getTimeAgoInWords() -> String {
        let interval: NSTimeInterval = NSTimeInterval(unixTimeCreatedAt)
        let date: NSDate = NSDate(timeIntervalSince1970: interval)
        return date.timeAgoSinceNow()
    }
}

class MicropostDataManager: NSObject {
    var microposts: [Micropost]
    var nextPage: Int?

    override init() {
        self.microposts = []
    }

    var size : Int {
        return self.microposts.count
    }

    subscript(index: Int) -> Micropost {
        return self.microposts[index]
    }

    func set(micropost: Micropost) {
        self.microposts.append(micropost)
    }
    
    func add(micropost: Micropost) {
        self.microposts.insert(micropost, atIndex: 0)
    }

    func add(microposts: [Micropost]) {
        self.microposts = microposts + self.microposts
    }

    func deleteMicropost(index: Int) {
        self.microposts.removeAtIndex(index)
    }

    func drop() {
        self.microposts.removeAll()
    }

    func lastUpdate() -> Int {
        if let micropost = microposts.first {
            return micropost.unixTimeCreatedAt
        }
        return 0
    }

    func upperId() -> Int? {
        if microposts.count == 0 {
            return nil
        }
        return microposts.reduce(microposts[0].id, combine: { max($0, $1.id) })
    }

    func lowerId() -> Int? {
        if microposts.count == 0 {
            return nil
        }
        return microposts.reduce(microposts[0].id, combine: { min($0, $1.id) })
    }

    func hasNextPage() -> Bool {
        return nextPage != nil && nextPage! > 0
    }
}
