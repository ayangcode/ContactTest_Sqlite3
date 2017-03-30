//
//  ContactTableViewTitleHeaderView.swift
//  ContactTest
//
//  Created by smile on 2017/3/28.
//  Copyright © 2017年 ayang. All rights reserved.
//

import UIKit


class ContactTableViewTitleHeaderView: UITableViewHeaderFooterView {
    /**
     * 间距
     */
    static let margin:CGFloat = 10
    /**
     * 头像
     */
    fileprivate lazy var ivIcon: UIImageView = {
        let ivIcon = UIImageView()
        ivIcon.frame = CGRect(x: auto_width(value: margin), y: auto_height(value: 5) , width: auto_width(value: 40), height: auto_height(value: 40))
        ivIcon.layer.cornerRadius = ivIcon.frame.size.height / 2
        ivIcon.layer.masksToBounds = true
        ivIcon.backgroundColor = UIColor.darkGray
        return ivIcon
    }()
    /**
     * 常用电话号码
     */
    fileprivate lazy var lbTelNumber: UILabel = {
        
        let lbTelNumber:UILabel = UILabel(frame: CGRect(x: YScreenW - auto_width(value: 130), y: (self.ivIcon.frame).midY - auto_width(value: 10), width: auto_width(value: 100), height: auto_height(value: 20)));
        lbTelNumber.textAlignment = .right
        lbTelNumber.adjustsFontSizeToFitWidth = true
        lbTelNumber.font = UIFont(name: MY_Font, size: MY_Font_SubTitle_Size) // 字体及大小
        return lbTelNumber
    }()
    /**
     * 名字
     */
    fileprivate lazy var lbName: UILabel = {
        let lbName:UILabel = UILabel(frame: CGRect(x: (self.ivIcon.frame).maxX + auto_width(value: 10), y: (self.ivIcon.frame).midY - auto_width(value: 10), width: (self.lbTelNumber.frame).minX - auto_width(value: 5) - ((self.ivIcon.frame).maxX + auto_width(value: 10)), height: auto_height(value: 20)));
        lbName.textAlignment = .left
        lbName.adjustsFontSizeToFitWidth = true
        lbName.font = UIFont(name: MY_Font, size: MY_Font_Title_Size) // 字体及大小
        return lbName
    }()
    /**
     * 联系人model
     */
    var model: ContactModel! {
        willSet {
            
        }
        didSet {
            self.lbTelNumber.text = "\(self.model.mobileNumber)"
            self.lbName.text = "\(self.model.name)"
        }
    }
    /**
     * 展开图标
     */
    lazy var ivArrow_expand: UIButton = {
        let iv = UIButton(type: UIButtonType.custom)
        iv.frame = CGRect(x: self.lbTelNumber.right + auto_width(value: 5), y: self.ivIcon.centerY - auto_height(value: 5), width: auto_width(value: 15), height: auto_height(value: 10))
        iv.setImage(#imageLiteral(resourceName: "arrow_expand"), for: .normal)
        iv.isSelected = false
        // 判断是否显示展开图标
        self.isMore = {(isMore) in
            if isMore == true {
                iv.isHidden = false
                
            }else {
                iv.isHidden = true
            }
        }
        return iv
    }()
    /**
     * 是否还有更多
     */
    var isMore : (Bool) -> Void = {(isMore) in }
    var tapedSection : Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- | ****** method ****** |
    func addSubviews() -> Void {
        // 添加视图
        contentView.addSubview(ivIcon)
        contentView.addSubview(lbTelNumber)
        contentView.addSubview(lbName)
        contentView.addSubview(ivArrow_expand)
        // 底线
        let line = UIView(frame: CGRect(x: 0, y: auto_height(value: 50), width: YScreenW, height: auto_height(value: 1)))
        line.backgroundColor = UIColor.gray
        contentView.addSubview(line)
        
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
