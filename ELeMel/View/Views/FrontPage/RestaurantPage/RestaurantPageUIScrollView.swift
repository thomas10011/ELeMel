//
//  RestaurantPageUIScrollView.swift
//  ELeMel
//
//  Created by thomas on 2020/5/11.
//  Copyright © 2020 thomas. All rights reserved.
//

import UIKit

class RestaurantPageUIScrollView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var restaurantImageView: UIImageView?  // 餐馆首页的图片
    var restaurantInfoCard: RestaurantInfoCardUIView?   // 餐馆信息卡片
    var detailPage: DetailPageUIView?    // 点餐 评价等细节页面
    
    var firstOffsetFlag: Bool = true
    var ORIGIN_OFFSET: CGFloat?
    var originY: CGFloat?
    let ORIGIN_HEIGHT: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false //隐藏滑动条
        self.delegate = self
        originY = frame.origin.y
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func initView(){
        let currentVC = UIViewController.current() as! RestaurantDetailPageViewController
        // 初始化餐馆首页图片
        let restaurantImageFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: ORIGIN_HEIGHT)
        restaurantImageView = UIImageView(frame: restaurantImageFrame) //暂时随便放个图
        restaurantImageView?.image = currentVC.restaurant!.restaurantPoster
        restaurantImageView?.contentMode = .scaleAspectFill
        
        // 初始化餐馆信息卡片
        let restaurantInfoCardFrame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 150)
        restaurantInfoCard = RestaurantInfoCardUIView(frame: restaurantInfoCardFrame)
        
        // 初始化点餐评论等细节页面
        let detailPageFrame = CGRect(x: 0, y: 250, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 88)
        detailPage = DetailPageUIView(frame: detailPageFrame)
        
        
        
        self.addSubview(restaurantImageView!)
        self.addSubview(restaurantInfoCard!)
        self.addSubview(detailPage!)
    }
    
    
    
    

}

extension RestaurantPageUIScrollView: UIScrollViewDelegate {
    // 监听滑动事件
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 记录第一次的偏移
        if(firstOffsetFlag){
            ORIGIN_OFFSET = self.contentOffset.y
            firstOffsetFlag = false
        }

        let yOffset = self.contentOffset.y -  originY!  // y方向偏移 需要减掉初始的偏移来修正
        
        // 手指向下滑动的情况 缩放顶部的图片
        if(yOffset <= -88){  // 实际上这里小于-88就行， 设置成44只是为了向上滑动图片有缩小的效果
            var frame = restaurantImageView!.frame
            frame.origin.y = yOffset
            frame.size.height = ORIGIN_HEIGHT - yOffset
            restaurantImageView!.frame = frame
        }
        
        // 向上滑动 根据首页图片的位置设置导航栏透明度
        let navigatironController = UIViewController.current()?.navigationController
        if(self.contentOffset.y - ORIGIN_OFFSET! < 100){
            let alpha = (self.contentOffset.y - ORIGIN_OFFSET!) / 100
            navigatironController!.navigationBar.subviews.first!.alpha = alpha
        }
        else{
            navigatironController!.navigationBar.subviews.first!.alpha = 1
        }
        
        // 当titleview超过导航栏后，停靠在导航栏
        var frame = detailPage!.titleView!.frame
        if(self.contentOffset.y - ORIGIN_OFFSET! > 250) {
            frame.origin.y =  (self.contentOffset.y - ORIGIN_OFFSET!) - 250  // 进行位移补偿
        }
        else{
            frame.origin.y =  0   // 否则恢复原位
        }
        detailPage!.titleView!.frame = frame
        
        // 设置shopcart的位置
        
    }
    
    
    
    
}
