//
//  OrderFormPageUIScrollView.swift
//  ELeMel
//
//  Created by thomas on 2020/5/18.
//  Copyright © 2020 thomas. All rights reserved.
//

import UIKit

class OrderFormPageUIScrollView: UIScrollView, UIScrollViewDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var topColorView: UIView?
    var orderListView: UIView?
    var baseView: UIView?
    var orderDetailCard: OrderDetailCardUIView?
    
    var deleteButton: UILabel?
    var buttonView: UIView?

    var order: OrderModel?
    
    let currentVC = UIViewController.current() as! OrderFormPageViewController
    let SCREEN_WIDTH = UIScreen.main.bounds.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.height
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray5
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        
        self.order = currentVC.order
        
        initTopColorView()
        initBaseView()
        initOrderListView()
        initDetailCard()
        initDeleteButton()
    }
    
    // 初始化背景
    func initBaseView() {
        baseView = UIView(frame: CGRect(x: 8, y: 0, width: SCREEN_WIDTH - 16, height: 1000))
        baseView!.backgroundColor = .systemGray6
        
        self.addSubview(baseView!)
        
    }
    
    // 初始化顶部的渐变颜色块
    func initTopColorView() {
        topColorView = UIView(frame: CGRect(x: 0, y: 0 - UIViewController.currentNaviBarHeight(), width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.5))
        
        // 定义渐变的颜色 从橙色到黄色
        let topColor = UIColor(red: 0xfc/255, green: 0x68/255, blue: 0x20/255, alpha: 1)    // 顶部颜色为橙色
        let bottomColor = UIColor(red: 0xfe/255, green: 0xd3/255, blue: 0x2f/255, alpha: 1)     // 中部颜色为黄色
        
        let grandientColors = [topColor.cgColor, bottomColor.cgColor, UIColor.white.cgColor, UIColor.systemGray6.cgColor]
        
        // 定义grandientColors中每种颜色所在位置
        let grandientLocations: [NSNumber] = [0.0, 0.5, 0.8, 1]
        
        // 创建CAGrandientLayer对象并设置参数
        let grandientLayer = CAGradientLayer()
        grandientLayer.colors = grandientColors
        grandientLayer.locations = grandientLocations
        
        // 设置为topColorView的layer
        grandientLayer.frame = topColorView!.frame
        topColorView!.layer.insertSublayer(grandientLayer, at: 0)

        self.addSubview(topColorView!)
    }
    
    // 初始化订单列表
    func initOrderListView() {
        debugPrint(order)
        let res = RestaurantModel(id: order!.restaurantID!)
        
        let headView = UIView(frame: CGRect(x:0, y: 0, width:baseView!.bounds.width, height: 50))
        let headLabel = UILabel(frame: CGRect(x:20, y: 0, width:baseView!.bounds.width - 20, height: 50))
        headView.backgroundColor = .white
        headLabel.text = res.name!
        headLabel.textAlignment = .left
        headView.addSubview(headLabel)
        
        var dishesView =  [OrderDishListUIView]()
         // 根据购物车添加菜品
        var totalPrice:Float = 0
        var i = 0
        for dic in ToolClass.convert(from: order!.dishesInfo!) {
            // 找到id对应的dish
            for dish in res.dishes! {
                if let count = dic[dish.ID!] {
                    let newView = OrderDishListUIView(frame: CGRect(x: 0, y: 50 + i * 50, width: Int(baseView!.bounds.width), height: 50))
                    newView.imageLabel.image = dish.productionPhoto
                    newView.numLabel.text = String(count)
                    newView.nameLabel.text = dish.name
                    newView.priceLabel.text = "\(dish.price!)"
                    
                    totalPrice = totalPrice + dish.price! * Float(count)
                    dishesView.append(newView)
                    i = i + 1
                    
                }
                
            }
            
        }
        
        let footView = UIView(frame: CGRect(x: 0, y: dishesView.last!.frame.origin.y + 50, width: baseView!.bounds.width, height: 50))
        let footViewLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (baseView?.bounds.width)! - 30, height: 50))
        footView.backgroundColor = .white
        footViewLabel.textAlignment = .right
        footViewLabel.text = "总计： ¥" + "\(totalPrice)"
        footView.addSubview(footViewLabel)
        
        orderListView = UIView(frame: CGRect(x: 0, y: 0, width: baseView!.bounds.width, height: footView.frame.maxY + 8))
        
        orderListView?.addSubview(headView)
        for i in 0 ..< dishesView.count {
            orderListView?.addSubview(dishesView[i])
        }
        orderListView?.addSubview(footView)
        
        baseView?.addSubview(orderListView!)
        
        
    }
    
    
    func initDetailCard() {
        self.orderDetailCard = OrderDetailCardUIView(frame: CGRect(x: 0, y: orderListView!.frame.maxY, width: baseView!.bounds.width, height: 210))
        orderDetailCard?.orderIDLabel.text = "\(order?.ID ?? 10086)"
        orderDetailCard?.createdTimeLabel.text = order?.createdTime
        orderDetailCard?.addressLabel.text = AppDelegate.user.address
        orderDetailCard?.nameLabel.text = AppDelegate.user.realName
        orderDetailCard?.paymentMethodLabel.text = order?.paymentMethod
        baseView?.addSubview(orderDetailCard!)
    }
    
    // 初始化删除按钮
    func initDeleteButton() {
        buttonView = UIView(frame: CGRect(x: 0, y: orderDetailCard!.frame.maxY + 8, width: baseView!.bounds.width, height: 44))
        buttonView!.backgroundColor = .white
        deleteButton = UILabel(frame: CGRect(x: 0, y: 0, width: baseView!.bounds.width, height: 44))
        deleteButton!.text = "删除订单"
        deleteButton!.textAlignment = .center
        deleteButton!.textColor = .systemRed
        
        // 给按钮添加点击事件
        buttonView!.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteButtonPressed))
        tapGesture.numberOfTouchesRequired = 1
        buttonView!.addGestureRecognizer(tapGesture)
        
        
        
        buttonView!.addSubview(deleteButton!)
        baseView?.addSubview(buttonView!)
    }
    
    
    // 删除订单
    @objc func deleteButtonPressed() {
        // 弹窗进行确认
        let alert = UIAlertController(title: "系统提示", message: "确定要删除订单吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: deleteCanceled(action:))
        let confirmAction = UIAlertAction(title: "确定", style: .default, handler: deleteConfirmed(action: ))
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        UIViewController.current()?.present(alert, animated: true, completion: nil)
        
        
    }
    
    // 取消删除
    @objc func deleteCanceled(action: UIAlertAction) {
        
    }
    
    // 确认删除
    @objc func deleteConfirmed(action: UIAlertAction) {
        // 删除订单
        DAO.deleteOrder(forid: order!.ID!)
        
        for i in 0 ..< AppDelegate.user.orders!.count {
            if AppDelegate.user.orders![i].ID == self.order!.ID {
                AppDelegate.user.orders!.remove(at: i)
                break
            }
        }
        
        
        // 弹窗告知并返回上一级
        let alert = UIAlertController(title: "系统提示", message: "订单删除成功！\n将返回上级页面！", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "好的", style: .default, handler: backToTab(action:))
        
        alert.addAction(confirmAction)
        UIViewController.current()?.present(alert, animated: true, completion: nil)
        
    }
    
    // 返回tab页面
    @objc func backToTab(action: UIAlertAction) {
        // 设置刷新标志
        OrderListViewController.needRefresh = true
        UIViewController.current()?.navigationController?.popViewController(animated: true)
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}


extension OrderFormPageUIScrollView {
    // 监听滑动事件
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = self.contentOffset.y + 88  // y方向的偏移
//        debugPrint(self.contentOffset.y)
        if offset < 0 {
            var frame = topColorView!.frame
            frame.origin.y = offset - 88
            frame.size.height = SCREEN_HEIGHT * 0.3 - offset
            topColorView!.frame = frame
        }

        let naviVC = UIViewController.current()?.navigationController
        if offset < 44 {
            let alpha = offset / 44
            naviVC?.navigationBar.subviews.first?.alpha = max(0, alpha)
        }
        else {
            naviVC?.navigationBar.subviews.first?.alpha = 1
        }
            

        
        
        
    }
    
    
}
