//
//  SJKDataBase.h
//  
//
//  Created by 性用社 on 15/11/11.
//
//

#import <Foundation/Foundation.h>

@interface SJKDataBase : NSObject
//创建一个类方法获取本类对象(不是单例)
+ (SJKDataBase*)sharedSJKFMDataBase;


/**
 *  插入数据的类方法
 */
+(void)insertSQLWirhSender:(NSString *)prople andSender:(NSString *)sender andNumber:(NSString *)number andChatNSString:(NSString *)chatNSS andIsSelf:(NSString *)isSelf andDate:(NSString *)date andStyle:(NSString*)style andSendTime:(NSString *)sendTime;


/**
 *  取出查询数据的类方法
 */
+(NSMutableArray*)searchSQL:(NSString *)sender;


/**
 * 删除数据库的全部内容
 */
+(void)removeAllSQL:(NSString *)sender;


/**
 *   根据条件删除数据库（根据下标）
 */
+(void)removeSQLWithName:(NSString*)sender WithNumber:(NSInteger)num;

/**
 *  创建数据库
 */
+(void)creatSQLit:(NSString *)sender;
@end
