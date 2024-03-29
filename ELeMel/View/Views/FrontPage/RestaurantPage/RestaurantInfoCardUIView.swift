//
//  RestaurantInfoCardUIView.swift
//  ELeMel
//
//  Created by thomas on 2020/5/11.
//  Copyright © 2020 thomas. All rights reserved.
//

import UIKit

class RestaurantInfoCardUIView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let xib = UINib(nibName: "RestaurantInfoCardUIView", bundle: nil)
        let view = xib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        let currentVC = UIViewController.current() as! RestaurantDetailPageViewController
        icon.image = currentVC.restaurant!.restaurantIcon
        noticeLabel.text = "公告：" + currentVC.restaurant!.notice!
        nameLabel.text = currentVC.restaurant!.name
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
