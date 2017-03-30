//
//  ContactModel.swift
//  ContactTest
//
//  Created by smile on 2017/3/24.
//  Copyright © 2017年 ayang. All rights reserved.
//

import Foundation



struct ContactModel {
    /**
     * 姓名
     */
    var name:String = ""
    /**
     * 手机号
     */
    var mobileNumber:String = ""
    /**
     * 号码数组
     */
    var numbers:Array<String> = [""]
    var ID:Int!
    
    
    init(name:String , mobileNumber:String , numbers:Array<String>) {
        self.name = name
        self.mobileNumber = mobileNumber
        self.numbers = numbers
    }
    
    //将自身插入数据库接口
    func insertContactModelToSqliteDB() -> Bool {
        //插入SQL语句
        // 将数组转为字符串 方便存储
        
        let numbersStr = numbers.joined(separator: ",")
        let insertSQL = "INSERT INTO 't_Contact' (name,number,numbers) VALUES ('\(name)','\(mobileNumber)','\(numbersStr)');"
        if YSqlite3Manager.sharedInstance().execSQL(SQL: insertSQL) {
            return true
        }else{
            return false
        }
    }
    func deleteContactModelFromSqliteDB(_ id:Int) -> Bool {
        let deleteSQL = " DELETE FROM t_Contact WHERE ID = '\(id)';"
        if YSqlite3Manager.sharedInstance().execSQL(SQL: deleteSQL) {
            return true
        } else {
            return false
        }
    }
    
}
