//
//  EmoticonViewController.swift
//  EmotionsTest

import UIKit

//一个cell的标志
private let TSZCollectionIdentify = "TSZCollectionIdentify"

class EmoticonViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置UI
        setupUI()
    }

    ///表情键盘的点击事件
    func clickEmotion(item: UIBarButtonItem){
        print("我是表情  我自信....+\(item.tag)")
    }
   // TODO:
    private func setupUI(){
        
        view.backgroundColor = UIColor.whiteColor()
        //添加 控件
        view.addSubview(collectionView)
        view.addSubview(toolsBar)
        
        //自动布局
        toolsBar.translatesAutoresizingMaskIntoConstraints = false
       collectionView.translatesAutoresizingMaskIntoConstraints = false
        //先定义一个数组
        let dict = ["toolsBar":toolsBar , "collectionView" : collectionView]
        
        //数组的布局
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolsBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
         view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        //布局高度
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[collectionView]-[toolsBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
        print(toolsBar)
        
        //准备控件
        prepareToolsBar()
        prepareCollection()
        
    }
    // MARK -准备ToolsBar
    private func prepareToolsBar(){
        
        var items = [UIBarButtonItem()];
        //为了区分 加tag值
        var index = 0
        for bar in ["最近","默认","Emoji","浪小花"] {
            items.append(UIBarButtonItem(title: bar, style: UIBarButtonItemStyle.Plain, target: self, action: "clickEmotion:" ))
            
            items.last?.tag = index++
            //加个弹簧分开
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        //去掉最后一个弹簧
        items.removeLast()
        toolsBar.items = items
    }
    
    //MARK 准备uicollectionCell
    private func prepareCollection(){
        //注册 cell
        collectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: TSZCollectionIdentify)
        
        //设置数据源方法
        collectionView.dataSource = self
    }
    
    
    //MARK - 懒加载
    private lazy var toolsBar: UIToolbar = {
        let tb = UIToolbar()
        
        tb.tintColor = UIColor.darkGrayColor()
        tb.backgroundColor = UIColor.redColor()
        return tb
        }()
    
    //MARK: 实现UICollectionView
    
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: TSZEmoticonLayout())
    //定义一个 内部类去实现布局
    private class TSZEmoticonLayout: UICollectionViewFlowLayout{
        //MARK: 记得准备cell需要的方法
        override func prepareLayout() {
            //设置布局 ，根据分析我们知道，每行显示  7 个
            
            let width = collectionView!.bounds.size.width / 7.0
            //计算高度 w  = 30  216 - 44  = 172   - 90
            let y = (collectionView!.bounds.height - 3 * width) * 0.5
            
            
            itemSize = CGSize(width: width, height: width)
            
            //间距
            minimumInteritemSpacing = 0
            //行距
            minimumLineSpacing = 0
            
            //插入外边距
            sectionInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
            
            //滚动顺序
            scrollDirection = UICollectionViewScrollDirection.Horizontal
            //分页
            collectionView?.pagingEnabled = true
            //隐藏水平的 滑动条
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}


//  使用扩展 、MARK: 数据源方法
extension EmoticonViewController: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 21 * 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //定义cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TSZCollectionIdentify, forIndexPath: indexPath) as! EmoticonCell
//        print(indexPath.item)
    
        cell.backgroundColor = (indexPath.item % 2 == 0) ?UIColor.redColor() : UIColor.greenColor()
        return cell
    }
}

// MARK: 自定义Colletion
private class EmoticonCell : UICollectionViewCell{
    //重写init方法
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emotionButton.backgroundColor = UIColor.blueColor()
        //设置相对bounds的布局
        emotionButton.frame = CGRectInset(bounds, 4, 4)
        
        addSubview(emotionButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 懒加载的button
    private lazy var emotionButton =  UIButton()
}

