//
//  ViewController2.h
//  BlockDemo
//
//  Created by lyle on 15/7/15.
//  Copyright (c) 2015年 lyle. All rights reserved.
//

/**1.直接定义block
 *  void        (^whatTheFuck)     (NSInteger a,NSInteger b)    ;
 *    |             ｜                                       |
 *  返回值                         block名字                     参数列表
 *
 *
 */

/**2.typedef 一个类型（block）
 *  typedef    void         (^useName)     (UITextField * txf);
 *     |        |                ｜                              ｜
 *  定义开始            返回值                        类型名                      参数列表
 *
 */


//程序说明－－ 将VC2 中的输入文本之传递到vc1中的标签上

/**
 1.viewcontroller是在appdelegate中实例话的一个类，appdelegate拥有一个viewcontroller的对象
 
 2.viewController2是另外一个不同于viewcontroller的控制器类
 
 3.viewcontroller拥有一个属性叫做vc2，这个属性是一个viewController2类型
 
 4.简单提下实例化过程是：一个类被实例化为一个你想要操作的对象
                        比如，此项目的appdelegate中的viewcontroller对象，窗口的 rootviewcontroller就是一个viewcontroller对象
                        又或者，viewcontroller中的vc2属性，就是一个viewcontroller2的实例对象
                    我想说的是，这些对象都有着自己的各种属性，你alloc init 它之后，它的那些属性都是nil，直到你进行赋值操作（此操作会进入对象的内部，调用属性的set方法）
                    所以vc2拥有多个类型为block类型的属性，如果你不在viewcontroller中去复制操作的话，在vc2的类中直接操作这些属性时，程序就会跑出异常，因为这些属性还没有值
 
 5.所以此例子中的block用法也是一样的：
 
        a).viewController类中拥有一个viewcontroller2类型的属性，名字叫vc2,是一个控制器
        b).viewController中实例化了一个viewcontroller2类型，并且让自身的vc2属性指向这个刚被创建的对象，即赋值操作
        c).viewController实现了按钮来push到另一个控制器vc2
        d).vc2开始生命周期方法，开始创建了一个textfield来输入文字，并且"调用一些自己的属性"，这一句要打上引号,因为block本质上是函数，所以这里是调用自己的属性，可是这个属性是用来执行某个函数的。
 
        e).viewController中给vc2的各个block属性赋值，就是为了让vc2内部调用block时能有事情可做，不至于崩溃。
        f).所以block的真正执行过程是在vc2中调用属性的时候，执行在vc1中定义的函数体。
 
 
6.结论，针对此例
    block作为属性，使用过程有三个关键步骤，暂时不讨论内存管理的问题
    第一步，为将要是实例化的对象B定义一个block类型的属性
    第二步，B要被某个A对象所拥有，在B对象总为A对象的block定义函数体的具体执行，包括获取到自己想要的值或者对象
    第三步,    在B对象中某些时刻调用自己的属性block，并给block传递一些参数，这时A中为B所定义的函数题就会利用B中传递的参数来执行。
 

 
 */

#import <UIKit/UIKit.h>





typedef void(^whatTheHell)(NSInteger a,NSInteger b);
typedef void(^useName)(UITextField * txf);

@interface ViewController2 : UIViewController
/**
 *  直接定义block
 */
@property (nonatomic,copy) void (^whatTheFuck)(NSInteger a,NSInteger b);

@property (nonatomic,copy)whatTheHell hell;


@property (nonatomic,strong)UITextField * texf;

@property (nonatomic,strong)useName useName;
@end