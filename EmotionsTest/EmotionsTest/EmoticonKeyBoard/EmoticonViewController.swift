//
//  EmoticonViewController.swift
//  EmotionsTest

import UIKit

//一个cell的标志
private let TSZCollectionIdentify = "TSZCollectionIdentify"

class EmoticonViewController: UIViewController {
    //定义一个 表情的闭包 ， 选择的 回调
    var selectedEmoticonCallBack :(emoticon: TSZEmoticons) -> ()
    
    //MARK: 构造函数
    init(selectedEmoticon: (emoticon: TSZEmoticons) ->()) {
        //记录闭包
        selectedEmoticonCallBack = selectedEmoticon
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //引入模型 ,懒加载
    private lazy var emoticonsPackage  =  TSZEmoticonsPackage.packages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(emoticonsPackage.count)

        //设置UI
        setupUI()
    }
    
    ///表情键盘的点击事件
    func clickEmotion(item: UIBarButtonItem){
        //滚动到对应的方法
        let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
   // TODO:
    private func setupUI(){
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
            items.append(UIBarButtonItem(title: bar, style: UIBarButtonItemStyle.Plain, target: self, action: "clickEmotion:"))
            
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
        collectionView.delegate = self
        
        //设置背景色
        collectionView.backgroundColor =  UIColor(white: 0.9, alpha: 1)
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
extension EmoticonViewController: UICollectionViewDataSource , UICollectionViewDelegate{
    
    //选择 表情
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //选中 表情
        let emoctions = emoticonsPackage[indexPath.section].emoticons![indexPath.item]
        //完成回调
        selectedEmoticonCallBack(emoticon: emoctions)
       
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return emoticonsPackage.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emoticonsPackage[section].emoticons?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //定义cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(TSZCollectionIdentify, forIndexPath: indexPath) as! EmoticonCell
        cell.emoticon = emoticonsPackage[indexPath.section].emoticons![indexPath.item]
        return cell
    }
}

// MARK: 自定义Colletion
private class EmoticonCell : UICollectionViewCell{

    //表示表情
    var emoticon:TSZEmoticons? {
        didSet {
            //contentsOfFile 路径不存在，会返回nil
            
            emotionButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath), forState: UIControlState.Normal)
            //设置emoji
            emotionButton.setTitle(emoticon!.emoji, forState: UIControlState.Normal)
            
            //MARK: 判断是不是删除按钮
            if emoticon!.removeEmotion{
                emotionButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                //设置高量
                emotionButton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    //重写init方法
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //设置相对bounds的布局
        emotionButton.frame = CGRectInset(bounds, 4, 4)
        
        //设置按钮字体
        emotionButton.titleLabel?.font = UIFont.systemFontOfSize(32)
        
        //可以实现用户的交互
        emotionButton.userInteractionEnabled = false
        addSubview(emotionButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 懒加载的button
    private lazy var emotionButton =  UIButton()
}
