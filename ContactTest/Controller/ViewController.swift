//
//  ViewController.swift
//  ContactTest
//
//  Created by smile on 2017/3/24.
//  Copyright © 2017年 ayang. All rights reserved.
//

import UIKit
import ContactsUI

class ViewController: UIViewController {
    static let sWidth = UIScreen.main.bounds.size.width   // 宽
    static let sHeight = UIScreen.main.bounds.size.height // 高
    
    /**
     * tableView懒加载
     */
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.init(x: 0, y: 20, width: sWidth, height: sHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0) // 防止显示不完(遮挡)
        tableView.backgroundColor = UIColor.lightText
        tableView.estimatedRowHeight = 50
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(dropTableViewBeginRefreshing), for: .valueChanged)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = self.btnAddContact
    
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(ContactTableViewTitleHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: "titleHeader")
        
        return tableView
    }()
    
    lazy var btnAddContact: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: YScreenW, height: 40))
        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        btn.setTitle("添加联系人", for: .normal)
        btn.setTitleColor(UIColor.darkText, for: .normal)
        btn.titleLabel?.font = UIFont(name: MY_Font, size: MY_Font_Title_Size)
        btn.addTarget(self, action: #selector(ViewController.btnAddContactTaped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    /**
     * 数组保存获取的联系人
     */
    var contactArr:Array<Any>!
    
    // MARK:- | ****** 生命周期 ****** |
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 载入数据
        loadList()
        
        view.addSubview(tableView)
        
    }
    
    // MARK:- | ****** 数据 ****** |
    /**
     * 加载列表
     */
    func loadList() -> Void {
        contactArr = allContactFromSqliteDB()!
        if contactArr.count > 0 {
            contactArr.removeAll()
        }
        let queue = DispatchQueue(label: "requestSqliteData")
        queue.async {
            self.contactArr = self.allContactFromSqliteDB()! // 子线程获取数据
            OperationQueue.main.addOperation { // 主线程刷新UI
                self.tableView.reloadData()
            }
        }
    }
    /**
     * 下拉刷新
     */
    func dropTableViewBeginRefreshing() -> Void{
        
        let delay = 1.0 // 设置短暂延时
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.loadList()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    /**
     * 获取所有联系人
     */
    func allContactFromSqliteDB() -> [ContactModel]? {
        let querySQL = "SELECT * FROM t_Contact;"
        //取出数据库中用户表所有数据
        let allDictArr = YSqlite3Manager.sharedInstance().queryDBData(querySQL: querySQL)
        
        //将字典数组转化为模型数组
        if let tempDictM = allDictArr {
            // 判断数组如果有值,则遍历,并且转成模型对象,放入另外一个数组中
            var contactModelArrM = [ContactModel]()
            for dict in tempDictM {
                /**
                 * 字典转为模型 并存进数组
                 */
                let name = dict["name"]
                let number = dict["number"]
                let numbersStr : String = dict["numbers"] as! String
                let ID = dict["ID"] as! Int
                let numbers = numbersStr.components(separatedBy: ",") // 将字符串转为Array
                var model = ContactModel(name: name as! String, mobileNumber: number as! String, numbers: numbers);
                model.ID = ID
                contactModelArrM.append(model)
                
                
            }
           
            return contactModelArrM
        }
        return nil
    }

    // MARK:- | ****** 内存管理 ****** |
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("释放了")
    }

}

// MARK:- | ****** tableView - delegate / datasource ****** |
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    // MARK:- | ****** datasource ****** |
    func numberOfSections(in tableView: UITableView) -> Int {
        return contactArr.count;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return auto_height(value: 50)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return auto_height(value: 0.01)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = ContactTableViewTitleHeaderView(reuseIdentifier: "titleHeader")
        for view in headerView.contentView.subviews {
            view.removeFromSuperview()
        }
        headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "titleHeader") as! ContactTableViewTitleHeaderView
        headerView.tag = section
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longTapToDeleteContact(tap:)))
        longTap.minimumPressDuration = 0.5
        headerView.addGestureRecognizer(longTap)
        
        let model:ContactModel = contactArr[section] as! ContactModel
        if model.numbers.count > 1 {
            headerView.isMore(true)
            headerView.tapedSection = section
        }else {
            headerView.isMore(false)
        }
        headerView.model = model
        return headerView;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        for view in cell.contentView.subviews {
            print("移除")
            view.removeFromSuperview()
        }
        cell.selectionStyle = .none
        return cell
    }
    // MARK:- | ****** delegate ****** |
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    

}

// MARK:- | ****** 通讯录 ****** |
extension ViewController : CNContactPickerDelegate {

    fileprivate func showContactUI() -> Void {
        let contactVC = CNContactPickerViewController()
        contactVC.delegate = self
        self.present(contactVC, animated: true, completion: nil)
    }
    
    /**
     * 选中某个联系人
     */
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let name = "\(contact.givenName) \(contact.familyName)" // 姓+名
        let numbers = contact.phoneNumbers // 号码数组
        var tempArr = Array<Any>() // 临时存放号码的数组
        for number:CNLabeledValue<CNPhoneNumber> in numbers {
            tempArr.append(number.value.stringValue)
        }
        
        // 获取的数据存放至model
        var model = ContactModel(name: name, mobileNumber: tempArr[0] as! String, numbers: tempArr as! Array<String>)
        let id:Int = model.insertContactModelToSqliteDB() // 获取id并赋值给model (防止刚添加联系人时，删除联系人找不到id)
        if id > 0 {
            model.ID = id
            contactArr.append(model)
            self.tableView.insertSections(IndexSet.init(integer: self.contactArr.count - 1), with: .bottom)
        }else {
            print("插入数据失败")
        }
        
    }
    
    /**
     * 取消并返回
     */
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- | ****** 其他点击事件 ****** |
extension ViewController {
    /**
     * 点击添加联系人
     */
    func btnAddContactTaped(sender:UIButton) -> Void {
        showContactUI() // 弹出通讯录
    }
    /**
     * 长按删除联系人
     */
    func longTapToDeleteContact(tap:UILongPressGestureRecognizer) -> Void {
    
        let alert = UIAlertController(title: nil, message: "是否删除该联系人?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "确定", style: .destructive) { (action) in
            let model : ContactModel = self.contactArr[(tap.view?.tag)!] as! ContactModel
            print(model.ID)
            self.contactArr.remove(at: (tap.view?.tag)!)
            if model.deleteContactModelFromSqliteDB(model.ID) {
                print("删除成功")
            }else {
                print("删除失败")
            }
            self.tableView.reloadData()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}






