# sqliteClasses

[![Build Status][TravisBadge]][TravisLink] [![CocoaPods Version][CocoaPodsVersionBadge]][CocoaPodsVersionLink] [![Swift4 compatible][Swift4Badge]][Swift4Link] [![Platform][PlatformBadge]][PlatformLink] [![Carthage compatible][CartagheBadge]][CarthageLink] [![Gitter](https://badges.gitter.im/Siva_sqliteClasses/community.svg)](https://gitter.im/Siva_sqliteClasses/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

A type-safe, [Swift][]-language layer over [SQLite3][].

[sqliteClasses][] provides compile-time confidence in SQL statement
syntax _and_ intent.

## Features

 - A pure-Swift interface
 - A type-safe, optional-aware SQL expression builder
 - A flexible, chainable, lazy-executing query layer
 - Automatically-typed data access
 - A lightweight, uncomplicated query and parameter binding interface
 - Developer-friendly error handling and debugging
 - [Full-text search][] support
 - [Well-documented][See Documentation]
 - Extensively tested
 - [SQLCipher][] support via CocoaPods
 - Active support at
   [StackOverflow](http://stackoverflow.com/questions/tagged/sqlite.swift),
   and [Gitter Chat Room](https://gitter.im/osoftz_iOS/sqliteClasses)
   (_experimental_)

[SQLCipher]: https://www.zetetic.net/sqlcipher/
[Full-text search]: Documentation/Index.md#full-text-search
[See Documentation]: Documentation/Index.md#sqliteswift-documentation


## Usage

```swift
/* *********************Creating and Assigning DB************************* */
         createDB(DBName: "First_DB"){
            data, error in
            if data == nil && error == nil{
                print("Table not created")
            }
            else if data == nil{
                print(error!)
            }
            else{
                self.data_base = data!
                print("Database created")
            }
        }
        /* *********************Creating and Assigning DB************************* */
        
        
        /* *********************Creating and print Table************************* */
        

        let column = [Column.init(ColumnName: "ID", dataType: .int , isPrimary: .primary , isUnique: .notUnique)!,
                      Column.init(ColumnName: "Name", dataType: .string , isPrimary: .notPrimary , isUnique: .notUnique)!,
                      Column.init(ColumnName: "Mail", dataType: .string , isPrimary: .notPrimary , isUnique: .unique)!,
                      Column.init(ColumnName: "Mobile", dataType: .string , isPrimary: .notPrimary , isUnique: .unique)!]
        
        let aa = createTable(tableName: "fourth_table", DB: self.data_base, columnNames: column)
        if (aa.success) {
            print("table created")
        }
        else{
            print("Error while creating table\(aa.error!)")
        }


        let columnInsert = [Column.init(ColumnName: "Name", dataType: .string , isPrimary: .notPrimary , isUnique: .notUnique, value: "Sureshkumar")!,
                            Column.init(ColumnName: "Mail", dataType: .string , isPrimary: .notPrimary , isUnique: .unique, value: "sureshkumar.r@osoftz.com")!,
                            Column.init(ColumnName: "Mobile", dataType: .string , isPrimary: .notPrimary , isUnique: .unique, value: "245678512")!]

        let bb = insertInTable(tableName: "fourth_table", DB: self.data_base, columnNames: columnInsert)




        if(bb.success){
            let ID = selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "ID", dataType: .int)!)
            let Name = selectTable(DB: self.data_base, tableName: "fourth_table",column: Column.init(ColumnName: "Name", dataType: .int)!)
            let Mobile = selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "Mail", dataType: .int)!)
            let Email =  selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "Mobile", dataType: .int)!)
            if Name.error == nil{
                print("ID in fourth table\(ID.value!)\nNames array \(Name.value!)\nMobile \(Mobile.value!)\nEmail \(Email.value!)")
            }
        }
        else{
            print("Error while inserting \(bb.error!)")
        }
        /* *********************Creating and print Table************************* */

        /* *********************Upadte and print Table************************* */
        
        let cc = updateTable(DB: self.data_base, tableName: "fourth_table",column: Column.init(ColumnName: "Mobile", dataType: .string, value: "9876543210", wrCN: "ID", wrVal: "1", wrDT: .int)!)

        if(cc.success){
            let ID = selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "ID", dataType: .int)!)
            let Name = selectTable(DB: self.data_base, tableName: "fourth_table",column: Column.init(ColumnName: "Name", dataType: .string)!)
            let Mobile = selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "Mail", dataType: .string)!)
            let Email =  selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "Mobile", dataType: .string)!)
            if Name.error == nil{
                print("ID in fourth table\(ID.value!)\nNames array \(Name.value!)\nMobile \(Mobile.value!)\nEmail \(Email.value!)")
            }
        }
        else{
            print("Error while update \(cc.error!)")
        }
        /* *********************Creating and print Table************************* */
        
        let dd = deleteRow(DB: self.data_base, tableName: "fourth_table",column: Column.init(ColumnName: "ID" , dataType: .int, value: "1")!)
        if (dd.success){
            let ID = selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "ID", dataType: .int)!)
            let Name = selectTable(DB: self.data_base, tableName: "fourth_table",column: Column.init(ColumnName: "Name", dataType: .string)!)
            let Mobile = selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "Mail", dataType: .string)!)
            let Email =  selectTable(DB: self.data_base, tableName: "fourth_table", column: Column.init(ColumnName: "Mobile", dataType: .string)!)
            if Name.error == nil{
                print("ID in fourth table\(ID.value!)\nNames array \(Name.value!)\nMobile \(Mobile.value!)\nEmail \(Email.value!)")
            }
        }
        else{
            print("Error while Delete \(dd.error!)")
        }
```

[Read the documentation][See Documentation] or explore more,
interactively, from the Xcode project’s playground.

![SQLite.playground Screen Shot](Documentation/Resources/playground@2x.png)

For a more comprehensive example, see
[this article][Create a Data Access Layer with sqliteClasses and Swift 2]
and the [companion repository][SQLiteDataAccessLayer2].


[Create a Data Access Layer with sqliteClasses and Swift 2]: http://masteringswift.blogspot.com/2015/09/create-data-access-layer-with.html
[SQLiteDataAccessLayer2]: https://github.com/hoffmanjon/SQLiteDataAccessLayer2/tree/master

## Installation

> _Note:_ sqliteClasses requires Swift 4.1 (and [Xcode][] 9.3).

### Carthage

[Carthage][] is a simple, decentralized dependency manager for Cocoa. To
install sqliteClasses with Carthage:

 1. Make sure Carthage is [installed][Carthage Installation].

 2. Update your Cartfile to include the following:

    ```ruby
    github "osoftz/sqliteClasses"
    ```

 3. Run `carthage update` and
    [add the appropriate framework][Carthage Usage].


[Carthage]: https://github.com/Carthage/Carthage
[Carthage Installation]: https://github.com/Carthage/Carthage#installing-carthage
[Carthage Usage]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application


### CocoaPods

[CocoaPods][] is a dependency manager for Cocoa projects. To install
sqliteClasses with CocoaPods:

 1. Make sure CocoaPods is [installed][CocoaPods Installation]. (sqliteClasses
    requires version 1.0.0 or greater.)

    ```sh
    # Using the default Ruby install will require you to use sudo when
    # installing and updating gems.
    [sudo] gem install cocoapods
    ```

 2. Update your Podfile to include the following:

    ```ruby
    use_frameworks!

    target 'YourAppTargetName' do
        pod 'sqliteClasses'
    end
    ```

 3. Run `pod install --repo-update`.

[CocoaPods]: https://cocoapods.org
[CocoaPods Installation]: https://guides.cocoapods.org/using/getting-started.html#getting-started

### Swift Package Manager

The [Swift Package Manager][] is a tool for managing the distribution of
Swift code.

1. Add the following to your `Package.swift` file:

  ```swift
  dependencies: [
      .package(url: "https://github.com/sivanagarajan18/sqliteClasses.git", from: "1.0.1")
  ]
  ```

2. Build your project:

  ```sh
  $ swift build
  ```

[Swift Package Manager]: https://swift.org/package-manager

### Manual

To install sqliteClasses as an Xcode sub-project:

 1. Drag the **SQLite.xcodeproj** file into your own project.
    ([Submodule][], clone, or [download][] the project first.)

    ![Installation Screen Shot](Documentation/Resources/installation@2x.png)

 2. In your target’s **General** tab, click the **+** button under **Linked
    Frameworks and Libraries**.

 3. Select the appropriate **sqliteClasses** for your platform.

 4. **Add**.

Some additional steps are required to install the application on an actual
device:

 5. In the **General** tab, click the **+** button under **Embedded
    Binaries**.

 6. Select the appropriate **sqliteClasses.framework** for your platform.

 7. **Add**.


[Xcode]: https://developer.apple.com/xcode/downloads/
[Submodule]: http://git-scm.com/book/en/Git-Tools-Submodules
[download]: https://github.com/osoftz/sqliteClasses/archive/master.zip


## Communication

[See the planning document] for a roadmap and existing feature requests.

[Read the contributing guidelines][]. The _TL;DR_ (but please; _R_):

 - Need **help** or have a **general question**? [Ask on Stack
   Overflow][] (tag `sqlite.swift`).
 - Found a **bug** or have a **feature request**? [Open an issue][].
 - Want to **contribute**? [Submit a pull request][].

[See the planning document]: /Documentation/Planning.md
[Read the contributing guidelines]: ./CONTRIBUTING.md#contributing
[Ask on Stack Overflow]: http://stackoverflow.com/questions/tagged/sqlite.swift
[Open an issue]: https://github.com/sivanagarajan18/sqliteClasses/issues/new
[Submit a pull request]: https://github.com/sivanagarajan18/sqliteClasses/fork


## Author

 - [Osoftz(mailto:sivanagarajan18@gmail.com)


## License

sqliteClasses is available under the MIT license. See [the LICENSE
file](./LICENSE.txt) for more information.

## Related

These projects enhance or use sqliteClasses:

 - [SQLiteMigrationManager.swift][] (inspired by
   [FMDBMigrationManager][])


## Alternatives

Looking for something else? Try another Swift wrapper (or [FMDB][]):

 - [Camembert](https://github.com/remirobert/Camembert)
 - [GRDB](https://github.com/groue/GRDB.swift)
 - [SQLiteDB](https://github.com/FahimF/SQLiteDB)
 - [Squeal](https://github.com/nerdyc/Squeal)
 - [SwiftData](https://github.com/ryanfowler/SwiftData)
 - [SwiftSQLite](https://github.com/chrismsimpson/SwiftSQLite)

[Swift]: https://swift.org/
[SQLite3]: http://www.sqlite.org
[sqliteClasses]: https://github.com/sivanagarajan18/sqliteClasses

[TravisBadge]: https://img.shields.io/travis/sivanagarajan18/sqliteClasses.svg?branch=master
[TravisLink]: https://travis-ci.org/

[CocoaPodsVersionBadge]: https://cocoapod-badges.herokuapp.com/v/sqliteClasses/badge.png
[CocoaPodsVersionLink]: http://cocoadocs.org/docsets/sqliteClasses

[PlatformBadge]: https://cocoapod-badges.herokuapp.com/p/sqliteClasses/badge.png
[PlatformLink]: http://cocoadocs.org/docsets/sqliteClasses

[CartagheBadge]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[CarthageLink]: https://github.com/Carthage/Carthage

[GitterBadge]: https://gitter.im/Siva_sqliteClasses
[GitterLink]: https://gitter.im/osoftz_iOS

[Swift4Badge]: https://img.shields.io/badge/swift-4.1-orange.svg?style=flat
[Swift4Link]: https://developer.apple.com/swift/

[SQLiteMigrationManager.swift]: https://github.com/garriguv/SQLiteMigrationManager.swift
[FMDB]: https://github.com/ccgus/fmdb
[FMDBMigrationManager]: https://github.com/layerhq/FMDBMigrationManager
