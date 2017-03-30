# ContactTest_Sqlite3
### 获取系统通讯录联系人并使用sqlite3进行保存和删除操作

导入sqlite3支持库`libsqlite3.tbd`，然后将 `#import <sqlite3.h>` 放置桥接文件中。

项目里有专门对sqlite3做简单的封装(目前没有涉及到事物、线程)，详情看[demo](https://github.com/ayangcode/ContactTest_Sqlite3)


>竖屏下按比例适配宽高(貌似没什么关系！！)
![const.png](http://upload-images.jianshu.io/upload_images/1762016-c22d5e11ccd47aa0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


简单封装sqlite3相关操作
```
//
//  YSqlite3Manager.swift
//  ContactTest
//
//  Created by smile on 2017/3/24.
//  Copyright © 2017年 ayang. All rights reserved.
//

import UIKit

class YSqlite3Manager: NSObject {
// MARK:- | ****** sqlite3单例 ****** |
/**
* 创建类的静态实例变量即为单例对象 let 是线程安全的
*/
static let instance = YSqlite3Manager()
/**
* 对外的单例接口
*/
class func sharedInstance() -> YSqlite3Manager {
return instance
}

// MARK:- | ****** 数据库 ****** |
/**
* 定义一个数据库变量
*/
private var db : OpaquePointer? = nil
/**
* 打开数据库
*/
func openDB() -> Bool {
// 获取目标路径
let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
// 拼接文件路径
let filePath = (docPath as NSString).appendingPathComponent("contactdb.sqlite")
print(filePath)
// 转换为c 字符串
let dbPath = filePath.cString(using: String.Encoding.utf8)
if sqlite3_open(dbPath, &db) != SQLITE_OK {
print("打开数据库失败")
return false
}else {
// 打开数据库的同时创建表
return createTable()
}
}



// MARK:- | ****** 创建表格 ****** |
func createTable() -> Bool {
//建表的SQL语句

let creatContactTable = "CREATE TABLE IF NOT EXISTS 't_Contact' ( 'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'name' TEXT,'number' TEXT, 'numbers' TEXT);"
//        return execSQL(SQL: creatUserTable)
return createTableExecSQL(SQL_ARR: [creatContactTable])
}

//执行建表SQL语句(多个)
private func createTableExecSQL(SQL_ARR : [String]) -> Bool {
for item in SQL_ARR {
if execSQL(SQL: item) == false {
return false
}
}
return true
}


/**
* 通过传入sql语句执行相关数据库操作(除查询外)
*/

func execSQL(SQL : String) -> Bool {
// 将sql语句转成c语言字符串
let cSQL = SQL.cString(using: String.Encoding.utf8)
// 错误信息
let errorMsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
if sqlite3_exec(db, cSQL, nil, nil, errorMsg) == SQLITE_OK {
return true
}else{
print("错误信息: \(errorMsg)")
return false
}
}
/**
* 对数据库表进行操作时返回所操作目标的自增长ID
*/
func execSQLReturnID(SQL: String) -> Int {
if !execSQL(SQL: SQL) {
return -1
}
// 返回自动增长 id
let id:Int64 = Int64(sqlite3_last_insert_rowid(db))
let intId:Int = Int(id)
return intId
}

// MARK:- | ****** 根据sql语句进行查询 ****** |

func queryDBData(querySQL : String) -> [[String : AnyObject]]? {
//定义游标对象
var stmt : OpaquePointer? = nil
//将需要查询的SQL语句转化为C语言
if querySQL.lengthOfBytes(using: String.Encoding.utf8) > 0 {
let cQuerySQL = (querySQL.cString(using: String.Encoding.utf8))!
//进行查询前准备操作
// 1> 参数一:数据库对象
// 2> 参数二:查询语句
// 3> 参数三:查询语句的长度:-1
// 4> 参数四:句柄(游标对象)
if sqlite3_prepare_v2(db, cQuerySQL, -1, &stmt, nil) == SQLITE_OK {
//准备好之后进行解析
var queryDataArrM = [[String : AnyObject]]()
while sqlite3_step(stmt) == SQLITE_ROW {
//1.获取 解析到的列(字段个数)
let columnCount = sqlite3_column_count(stmt)
//2.遍历某行数据
var dict = [String : AnyObject]()
for i in 0..<columnCount {
// 取出i位置列的字段名,作为字典的键key
let cKey = sqlite3_column_name(stmt, i)
let key : String = String(validatingUTF8: cKey!)!

//取出i位置存储的值,作为字典的值value （判断数据类型）
if sqlite3_column_type(stmt, i) == SQLITE_BLOB {
let cValue = sqlite3_column_text(stmt, i)
let value =  String(cString:cValue!)
dict[key] = value as AnyObject
}else if (sqlite3_column_type(stmt, i) == SQLITE_TEXT) {
let cValue = sqlite3_column_text(stmt, i)
let value =  String(cString:cValue!)
dict[key] = value as AnyObject
}else if (sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {
let cValue = sqlite3_column_int(stmt, i)
let value =  Int(cValue)
dict[key] = value as AnyObject
}

}
queryDataArrM.append(dict)
}
return queryDataArrM
}
}
return nil
}

// MARK:- | ****** 关闭数据库 ****** |
func closeDB() -> Void {
sqlite3_close(db)
db = nil
}
}

```
