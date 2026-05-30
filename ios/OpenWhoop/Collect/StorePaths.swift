import Foundation
enum StorePaths {
    /// `<AppSupport>/LifeStrap/whoop.sqlite`, creating the directory if needed.
    static func defaultDatabasePath() throws -> String {
        let fm = FileManager.default
        let base = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask,
                              appropriateFor: nil, create: true)
            .appendingPathComponent("LifeStrap", isDirectory: true)
        try fm.createDirectory(at: base, withIntermediateDirectories: true)
        return base.appendingPathComponent("whoop.sqlite").path
    }
}
