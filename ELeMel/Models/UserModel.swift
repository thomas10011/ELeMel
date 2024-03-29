//
//  UserModel.swift
//  ELeMel
//
//  Created by thomas on 2020/5/15.
//  Copyright © 2020 thomas. All rights reserved.
//

import Foundation

class UserModel {
    var userID: Int?                         // 用户ID
    var userName: String?                    // 用户名
    var userPassword: String?                // 用户密码
    var realName: String?                    // 真实姓名
    var phoneNumber: String?                 // 用户电话号码
    var email: String?                       // 邮箱
    var address: String?                     // 地址
    var orders: [OrderModel]?           // 用户名下的订单
    
    var newInstance: Bool
    
    init() {
        newInstance = true
    }
    init(id: Int) {
        newInstance = false
        loadFromDB(id: id)
    }
    
    // 从数据库加载的函数私有化
    private func loadFromDB(id: Int) {
        let tableEntry = DAO.select(tableName: UserTableField.TableName.rawValue, columns: nil, condition: "\(UserTableField.ID.rawValue) = \(id)")?.first
        self.userID = tableEntry?[UserTableField.ID.rawValue] as? Int
        self.userName = tableEntry?[UserTableField.Name.rawValue] as? String
        self.userPassword = tableEntry?[UserTableField.Password.rawValue] as? String
        self.realName = tableEntry?[UserTableField.RealName.rawValue] as? String
        self.phoneNumber = tableEntry?[UserTableField.PhoneNumber.rawValue] as? String
        self.email = tableEntry?[UserTableField.Email.rawValue] as? String
        self.address = tableEntry?[UserTableField.Address.rawValue] as? String
        
        // 加载用户的订单
        self.orders = [OrderModel]()
        let entries = DAO.select(tableName: OrderFormTableField.TableName.rawValue, columns: [OrderFormTableField.ID.rawValue], condition: "\(OrderFormTableField.UserID.rawValue) = \(self.userID!)")      // 获取所有订单的id
        if entries == nil{
            return
        }
        for entry in entries! {
            orders?.append(OrderModel(id: entry[OrderFormTableField.ID.rawValue] as! Int))
        }
        
    }
    
    // 保存到数据库中
    func saveToDB() {
        
        var User = [
            UserTableField.Address.rawValue: self.address!,
            UserTableField.Name.rawValue: self.userName,
            UserTableField.RealName.rawValue: self.realName,
            UserTableField.Password.rawValue: self.userPassword,
            UserTableField.PhoneNumber.rawValue: self.phoneNumber,
            UserTableField.Email.rawValue: self.email
        ] as [String: AnyObject]
        
        if newInstance {
            newInstance = false // 保存以后就不是新的信息了
            _ = DAO.insert(tableName: UserTableField.TableName.rawValue, properties: User)
            // 更新ID
            let entry = DAO.select(tableName: UserTableField.TableName.rawValue, columns: [UserTableField.ID.rawValue], condition: "\(UserTableField.Name.rawValue) = \(ToolClass.addSingleQuotes(str: self.userName!)) AND \(UserTableField.Password.rawValue) = \(ToolClass.addSingleQuotes(str: self.userPassword!))")?.first
            self.userID = entry?[UserTableField.ID.rawValue] as? Int
            
        }
        else {
            User.updateValue(self.userID as AnyObject, forKey: UserTableField.ID.rawValue)
            _ = DAO.update(tableName: UserTableField.TableName.rawValue, properties: User, condition: "\(UserTableField.ID.rawValue) = \(self.userID!)")

        }
        
        
    }
}
