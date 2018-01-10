//
//  ViewController.m
//  Promise-OC
//
//  Created by fanqile on 2018/1/5.
//  Copyright © 2018年 fanqile. All rights reserved.
//

#import "ViewController.h"
#import <PromiseKit/PromiseKit.h>

@interface ViewController ()

@property (nonatomic, strong) NSError *textError;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self textSimp];
//    [self textWhen];
//    [self textJoin];
}

- (void)textSimp{
    AnyPromise *newPromise = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        NSError *errorValue = nil;
        NSDictionary *valueDic = @{
                                   @"key":@"textSimp"
                                   };
        adapter(valueDic,errorValue);
    }];
    
    AnyPromise *newPromise1 = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        NSError *errorValue = nil;
        NSDictionary *valueDic = @{
                                   @"key":@"textSimp1"
                                   };
        adapter(valueDic,errorValue);
    }];
    
    newPromise.then(^(NSDictionary *data){
        
        NSLog(@"data - 1");
        //        return [NSError errorWithDomain:PMKErrorDomain code:PMKUnexpectedError userInfo:@{NSLocalizedDescriptionKey: @"reason"}];
        return newPromise1;
        /**
         case let err as Error:
         resolve(Resolution(err))
         case let promise as AnyPromise:
         promise.state.pipe(resolve)
         default:
         //这里会对下一个then进行数据传递
         resolve(.fulfilled(obj))
         }
         根据源码分析可以return error(相当于下一次失败),AnyPromise(可以理解为nextPromise) ,其他(可以传入当前数据的data,会在下面的then返回),三种模式
         */
    }).then(^(id data){
        
        NSLog(@"data - 2");
    }).catch(^(id error){
        
        NSLog(@"error - %@",error);
    });
}

- (void)textJoin{
    AnyPromise *newPromise1 = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        NSError *errorValue = nil;
        NSDictionary *valueDic = @{
                                   @"key":@"textJoin1"
                                   };
        adapter(valueDic,errorValue);
    }];
    AnyPromise *newPromise2 = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        NSDictionary *valueDic = @{
                                   @"key":@"textJoin2"
                                   };
        NSError *error = [NSError errorWithDomain:PMKErrorDomain code:PMKUnexpectedError userInfo:@{NSLocalizedDescriptionKey: @"reason"}];
        adapter(valueDic,error);
    }];
    NSArray *promiseArr = @[
                            newPromise1,
                            newPromise2,
                            ];
    AnyPromise *allPromise = PMKJoin(promiseArr);
    allPromise.then(^(id data){
        
        NSLog(@"data - 3 data = %@",data);
    }).then(^(id data){
        
        NSLog(@"data - 4 data = %@",data);
    }).always(^(){
        NSLog(@"always");
    });
     // 在promiseArr数组中的所有promise都成功之后才会then,只有两个都遍历之后,如果其中有失败的才会reject. 源码在join.m文件夹
}

- (void)textWhen{
    AnyPromise *newPromise1 = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        id errorValue;
        NSDictionary *valueDic = @{
                                   @"key":@"textWhen1"
                                   };
        adapter(valueDic,errorValue);
    }];
    AnyPromise *newPromise2 = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        id errorValue;
        NSDictionary *valueDic = @{
                                   @"key":@"textWhen2"
                                   };
        adapter(valueDic,errorValue);
    }];
    NSArray *promiseArr = @[
                            newPromise1,
                            newPromise2,
                            ];
    AnyPromise *allPromise = PMKWhen(promiseArr);
    allPromise.then(^(id data){
        
        NSLog(@"data - 3 data = %@",data);
    }).then(^(id data){
        
        NSLog(@"data - 4 data = %@",data);
    }).always(^(){
        NSLog(@"always");
    });
     // 在 promiseArr数组中的所有promise都成功之后才会then,如果其他有一个失败就会立刻进行reject,源码在when.m
}

- (NSError *)textError{
    return [NSError errorWithDomain:PMKErrorDomain code:PMKUnexpectedError userInfo:@{NSLocalizedDescriptionKey: @"reason"}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
