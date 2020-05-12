import Foundation
import CloudKit

// MARK: _@struct EntryStrs
/**©-------------------------------------------©*/
struct EntryStrs {
    static let RecordEntryKey = "Entry"; static let TitleKey = "title"
    static let BodyKey = "body"; static let TimeStampKey = "timeStamp"
}
/**©-------------------------------------------©*/

// MARK: _@class Entry
/**©------------------------------------------------------------------------------©*/
/// Create an Entry model class that will hold a
/// `title`, `body`, timestamp and `ckRecordID` properties for each entry.
class Entry {
    // MARK: @Properties
    var title: String
    var body: String
    var timeStamp: Date
    // ID:--? An object that uniquely identifies a record in a database.
    let ckRecordID: CKRecord.ID

    init(title: String, body: String, timeStamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
    }
}
/**©------------------------------------------------------------------------------©*/

// MARK: _@extension Entry
/**©------------------------------------------------------------------------------©*/
extension Entry {
    
     // Failable init
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryStrs.TitleKey] as? String,
              let body = ckRecord[EntryStrs.BodyKey] as? String,
              let timeStamp = ckRecord[EntryStrs.TimeStampKey] as? Date
                else { return nil }

        self.init(title: title, body: body, timeStamp: timeStamp)
    }
}
/**©------------------------------------------------------------------------------©*/

// MARK: _@extension CKRecord
/**©------------------------------------------------------------------------------©*/
extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryStrs.RecordEntryKey, recordID: entry.ckRecordID)
        self.setValuesForKeys([
            EntryStrs.TitleKey : entry.title,
            EntryStrs.BodyKey : entry.body,
            EntryStrs.TimeStampKey : entry.timeStamp
        ])
    }
}
/**©------------------------------------------------------------------------------©*/
