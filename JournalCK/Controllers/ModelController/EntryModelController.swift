import Foundation
import CloudKit

class EntryModelController {
    // MARK: _@Shared-instance
    static let shared = EntryModelController()

    // MARK: _@Source of truth
    var entryList: [Entry] = []

    /*-----------------------------------------------------------
    (CKContainer):--? A container object manages all explicit and
     implicit attempts to access the contents of the container.
     (publicCloudDatabase):--? The database containing the data
      shared by all users.
    -----------------------------------------------------------*/
    let privateDB = CKContainer.default().privateCloudDatabase

    // MARK: _CRUD
    /**©------------------------------------------------------------------------------©*/
    // CREATE
    /*-----------------------------------------------------------
    Write a createEntryWith(title: ...) function that takes in a
     title, and body, and
      @escaping(_ result: Result<Entry?, EntryError>) -> Void
    -----------------------------------------------------------*/
    func createEntryWith(title: String, body: String, completion: @escaping (Result<Entry?, JournalError>) -> Void) {
        // 1] Create a new Entry
        let newEntry = Entry(title: title, body: body)
        // 2] call our save method and pass in the newEntry and completion as a parameter
        saveEntryWith(newEntry: newEntry, completion: completion)
    }

    // Save func
    func saveEntryWith(newEntry: Entry, completion: @escaping (Result<Entry?, JournalError>) -> Void) {
        // 1] Create a new CKRecord that takes in a entry
        let entryRecord = CKRecord(entry: newEntry)

        // 2] Save to Database
        privateDB.save(entryRecord) { (record, error) in
            // 3] Handling error
            if let error = error {
                return completion(.failure(.ckError(error)))
            }

            // 4] Unwrap our record to check for nil
            guard let record = record,
                  let saveEntry = Entry(ckRecord: record)
                    else { return completion(.failure(.couldNotUnwrap)) }

            // 5] Add the saved entry to our source of truth
            self.entryList.insert(saveEntry, at: 0)
            // 6] If the record is found printf & complete with success
            printf("Save Entry was successful...")

            completion(.success(saveEntry))
        }
    }

    /// READ() if we have data to read
        func fetchEntriesWith(completion: @escaping (Result<[Entry]?, JournalError>) -> Void) {
            // 1] Build a predicate
            let fetchAllEntryPredicates = NSPredicate(value: true)// Fetch all types
            // 2] Build out our query:--? query all queries of type hype
            let queryEntry = CKQuery(recordType: EntryStrs.recordEntryKey, predicate: fetchAllEntryPredicates)

            // 5] Search the specified zone asynchronously for records that match the query parameters.
            privateDB.perform(queryEntry, inZoneWith: nil) { (records, error) in
                // 6] Handling error
                if let error = error {
                    return completion(.failure(.ckError(error)))
                }

                // 7] Unwrap our record to check for nil
                guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
                // 8] If the record is found printf & complete with success
                printf("Fetched all entries successfully...")

                // 9] `.compactMap` It is throwing away all the nils for you
                let entries = records.compactMap {  Entry(ckRecord: $0)  }
                // 10] Setting our source of truth to the value of the returned entries object
                self.entryList = entries
                // 10] complete with success
                completion(.success(entries))
            }
        }
    // UPDATE
    // DELETE
    /**©------------------------------------------------------------------------------©*/
}
