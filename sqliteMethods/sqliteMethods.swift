//
//  sqliteMethods.swift
//  sqliteMethods
//
//  Created by Developers on 17/11/18.
//  Copyright © 2018 osoftz. All rights reserved.
//

import Foundation
import SQLite
import SQLite3

var db : Connection!


public func database() -> Connection{
    do{
        try db = Connection.init()
         return db
    }
    catch{
        return database()
    }
}

public enum dataType:Int{
    case int = 0
    case date = 1
    case string = 2
}

public enum isPrimary:String{
    case primary = "true"
    case notPrimary = "false"
}

public enum isUnique:String{
    case unique = "true"
    case notUnique = "false"
}


open class Column{
    public var CName = String()
    public var dT = Int()
    public var Primary = String()
    public var Unique = String()
    public var Value = String()
    public var whereCN = String()
    public var whereValue = String()
    public var whereDataType = Int()
    
    required public init?(ColumnName: String, dataType: dataType, isPrimary:isPrimary = .notPrimary , isUnique:isUnique = .notUnique , value:String = "", wrCN:String = "", wrVal:String = "", wrDT:dataType = .string ) {
        CName = ColumnName
        dT = dataType.rawValue
        Primary = isPrimary.rawValue
        Unique = isUnique.rawValue
        Value = value
        whereCN = wrCN
        whereValue = wrVal
        whereDataType = wrDT.rawValue
    }
}

public var ArrayOfColumns = [Column]()

public typealias columnCreate = [String]

public var unique:Bool{
    return true
}

public var notUnique:Bool{
    return false
}

public var primary:Bool{
    return true
}

public var notPrimary:Bool{
    return false
}

public var date: Int{
    return 1
}

public var string: Int{
    return 2
}

public var int: Int{
    return 0
}


public func createDB(DBName : String, completionHandler: @escaping (Connection?, Error?) -> ()){
    do{
        let documentDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL =  documentDir.appendingPathComponent(DBName).appendingPathExtension("sqlite3")
        let db = try Connection(fileURL.path)
        print("File URL Path \(fileURL)")
        completionHandler(db, nil)
            
    }catch{
        print(error)
        completionHandler(nil, error)
        }
}
    
public func createTable(tableName: String, DB:Connection, columnNames:[Column]) -> (success: Bool,error: Error?) {
        let createTable =  Table(tableName).create { (table) in
            if columnNames.count != 0{
                for i in 0 ... columnNames.count - 1{
                        switch columnNames[i].dT
                        {
                            case 0 :
                            if columnNames[i].Unique == "true"{
                                table.column(Expression<Int?>(columnNames[i].CName), unique: true)
                            }
                            else if columnNames[i].Primary == "true" {
                                table.column(Expression<Int>(columnNames[i].CName), primaryKey : true)
                            }
                            else{
                                table.column(Expression<Int?>(columnNames[i].CName))
                            }
                            case 1 :
                                if columnNames[i].Unique == "true"{
                                    table.column(Expression<Date?>(columnNames[i].CName), unique: true)
                                }
                                else if columnNames[i].Primary == "true" {
                                    table.column(Expression<Date>(columnNames[i].CName), primaryKey : true)
                                }
                                else{
                                    table.column(Expression<Date?>(columnNames[i].CName))
                            }
                            default:
                                if columnNames[i].Unique == "true"{
                                    table.column(Expression<String?>(columnNames[i].CName), unique: true)
                                }
                                else if columnNames[i].Primary == "true" {
                                    table.column(Expression<String>(columnNames[i].CName), primaryKey: true)
                                }
                                else{
                                    table.column(Expression<String?>(columnNames[i].CName))
                            }
                        }
                   
                    
                }
            }
            
        }
        
        do{
            try DB.run(createTable)
            return (true,nil)
        }
        catch{
            print(error)
            return (false,error)
        }
    
}

public func addCoulumnTable(DB:Connection, tableName:String, column:Column) -> (Success:Bool, error:Error?){
    var ff = String()
    switch column.dT
    {
    case 0 :
            ff = Table(tableName).addColumn(Expression<Int?>(column.CName))
    case 1 :
             ff = Table(tableName).addColumn(Expression<Date?>(column.CName))
    default:
            ff =  Table(tableName).addColumn(Expression<String?>(column.CName))
    }
    do{
        try DB.run(ff)
        return (true,nil)
    }catch{
        print(error)
        return (false,error)
    }
}



public func insertInTable(tableName:String, DB:Connection, columnNames:[Column])  -> (success: Bool,error: Error?){
    let tab = Table(tableName)
    var InsertValue = [Setter]()
    var result : (Bool, Error?)!
    if columnNames.count != 0{
        for i in 0 ... columnNames.count - 1{
            switch columnNames[i].dT {
            case 0 :
                InsertValue.append(Expression<Int>(columnNames[i].CName) <- Int(columnNames[i].Value)!)
            case 1 :
                InsertValue.append(Expression<Date>(columnNames[i].CName) <- dateFormatter(stringDate: columnNames[i].Value, format: "MM/dd/yyyy"))
            case 2 :
                InsertValue.append(Expression<String>(columnNames[i].CName) <- columnNames[i].Value)
            default: break
            }
        }
            do{
                var insValue : Insert!
                insValue = tab.insert(InsertValue)
                try DB.run(insValue)
                result = (true, nil)
            }
                catch{
                    print(error)
                    result = (false, error)
                }
        }
        return result
    }
    
public func updateTable(DB:Connection, tableName:String, column:Column) -> (success: Bool,error: Error?){
    let tab = Table(tableName)
    var filter_table : Table!
    var updateTab : Update!
    var result : (Bool, Error?)!
    
    switch column.whereDataType {
    case 0 :
        filter_table = tab.filter(Expression<Int>(column.whereCN) == Int(column.whereValue)!)
        
    case 1 :
        filter_table = tab.filter(Expression<Date>(column.whereCN) == dateFormatter(stringDate: column.whereValue, format: "MM/dd/yyyy"))
        
    case 2 :
        filter_table = tab.filter(Expression<String>(column.whereCN) == column.whereValue)
        
    default: break
    }
    
    switch column.dT {
    case 0:
        updateTab = filter_table.update(Expression<Int>(column.CName) <- Int(column.Value)!)
    case 1:
        updateTab = filter_table.update(Expression<Date>(column.CName) <- dateFormatter(stringDate: column.Value, format: "MM/dd/yyyy"))
    case 2:
        updateTab = filter_table.update(Expression<String>(column.CName) <- column.Value)
    default:
        break
    }
    
        do{
            try DB.run(updateTab)
            result = (true, nil)
        }catch{
            print(error)
            result = (false, error)
        }
    
    return result
}


public func allCoumnNames(DB:Connection, tableName:String) -> (ArrayString:[String], error:Error?){
    let query = "PRAGMA table_info (\(tableName))"
    var stringArray = [String]()
    
    do{
       let xx = try DB.run(query)
        for z in xx{
            stringArray.append(z[1] as! String)
        }
        return (stringArray,nil)
    }
    catch{
       return ([String](),error)
    }
}

public func selectTable(DB:Connection, tableName:String,column:Column)->(value:[String]?,error:Error?){
    let tab = Table(tableName)
    do{
        var filter_table : Table!
        
        var values = [String]()
        
        switch column.whereDataType {
        case 0 :
            filter_table = tab.filter(Expression<Int>(column.whereCN) == Int(column.whereValue)!)
        case 1 :
            filter_table = tab.filter(Expression<Date>(column.whereCN) == dateFormatter(stringDate: column.whereValue, format: "MM/dd/yyyy"))
        case 2 :
            filter_table = tab.filter(Expression<String>(column.whereCN) == column.whereValue)
        default: break
        }
        
        let xx = try DB.prepare(filter_table)
        for row in xx{
            switch column.dT{
            case 0:
                values.append(String(describing: row[Expression<Int>(column.CName)]))
            case 1:
                values.append(String(describing: row[Expression<Date>(column.CName)]))
            case 2:
                values.append(String(describing: row[Expression<String>(column.CName)]))
            default:
                break
            }
        }
        return (values,nil)
    }
    catch{
        print(error)
        return (nil,error)
    }
}

public func deleteRow(DB:Connection, tableName:String,column:Column, andColumn: Column? = nil) -> (success: Bool,error: Error?){
   let tab = Table(tableName)
    var filter_table : Table!
    do{
        switch column.dT {
        case 0 :
            if andColumn != nil {
                filter_table = tab.filter(Expression<Int>(column.CName) == Int(column.Value)! && Expression<Int>(andColumn!.CName) == Int(andColumn!.Value)!)
            } else {
                filter_table = tab.filter(Expression<Int>(column.CName) == Int(column.Value)!)
            }
        case 1 :
            if andColumn != nil {
                filter_table = tab.filter(Expression<Date>(column.CName) == dateFormatter(stringDate: column.Value, format: "MM/dd/yyyy") && Expression<Date>(andColumn!.CName) == dateFormatter(stringDate: andColumn!.Value, format: "MM/dd/yyyy"))
            } else {
                filter_table = tab.filter(Expression<Date>(column.CName) == dateFormatter(stringDate: column.Value, format: "MM/dd/yyyy"))
            }
        case 2 :
            if andColumn != nil {
                filter_table = tab.filter(Expression<String>(column.CName) == column.Value && Expression<String>(andColumn!.CName) == andColumn!.Value)
            } else {
                filter_table = tab.filter(Expression<String>(column.CName) == column.Value)
            }
        default: break
        }
        let xx = filter_table.delete()

        try DB.run(xx)
        return (true,nil)

    }catch{
        print(error)
        return (false,error)
    }
}

public func dropTable(DB:Connection, tableName:String) -> (success: Bool, error: Error?){
    let tab = Table(tableName).drop()
    do{
        try DB.run(tab)
        return (true,nil)
    }catch{
        return (false,error)
    }
}

public func tableThere(DB:Connection, tableName:String) {
    
    do{
       try DB.execute("select name from \(DB) where type='table'")
    }
    catch{
        print(error)
    }
}

public func deleteTable(DB:Connection, tableName:String)-> (success: Bool, error: Error?){
    let tab = Table(tableName).delete()
    do{
        try DB.run(tab)
        return (true,nil)
    }catch{
        return (false,error)
    }
}


func dateFormatter(stringDate:String, format : String)-> Date
{
    let formatter = DateFormatter()
    formatter.dateFormat = format //"HH:mm:ss"
    let formattedDate = formatter.date(from: stringDate)
    return formattedDate!
}


