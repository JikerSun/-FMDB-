//
//  SJKDataBase.m
//  
//
//  Created by 性用社 on 15/11/11.
//
//

#import "SJKDataBase.h"
#import "FMDatabase.h"
//定义一个宏来存储路径
#define DBPATH [NSString stringWithFormat:@"%@/Documents/chat.db",NSHomeDirectory()]
//@interface SJKDataBase ()
//@property (nonatomic, strong) NSMutableArray *setDictUserArray;
//@end
@implementation SJKDataBase
{//全局的FMDataBase对象
    FMDatabase * _database;
    
}
//设置懒加载
//-(NSMutableArray *)setDictUserArray
//{
//    if (_setDictUserArray==nil) {
//    _setDictUserArray=[[NSMutableArray alloc]init];
//    }
//    return _setDictUserArray;
//}

+ (SJKDataBase*)sharedSJKFMDataBase
{
    SJKDataBase *sjkDataBase;
    
    //创建一个对象并返回
    
    //    考虑一个多线程 只允许一条线程去执行其他的等 不允许多条线程同时调用次函数体的内容
    @synchronized(self){
        sjkDataBase=[[self alloc]init];
        
    }
    
    return sjkDataBase;
}

-(instancetype )init
{
    if (self=[super init]) {
        
        //自定义的操作
        //实例化对象
        _database=[[FMDatabase alloc]initWithPath:DBPATH];
        
        //打开数据库(第一次的话是创建并读取)
        [_database open];
        
    }
    
    
    return self;
}

+(void)creatSQLit:(NSString *)sender
{
    [[self sharedSJKFMDataBase]creatSQLit:sender];

}
/**
 *  创建数据
 */
-(void)creatSQLit:(NSString *)sender
{

     //    最终拼接创建表单的语句完成
    NSString *creatTableSQL=[NSString stringWithFormat:@"create table if not exists '%@'(number integer primary key autoincrement,name varchar(20),chatNss text,isSelf text,sendDate text,style text,sendTime text)",sender];
   // NSString *sql=[NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoincrement,%@)",tableName,sqlContent];

    
    //执行sql语句
    BOOL bo=  [_database executeUpdate:creatTableSQL];
    
    
    if (!bo) {
        NSLog(@"创建表单失败:%@",_database.lastErrorMessage);
    }
    else{NSLog(@"见表成功");}
    
    NSLog(@"%@",DBPATH);
}


/**
 *  插入数据的类方法
 */
+(void)insertSQLWirhSender:(NSString *)prople andSender:(NSString *)sender andNumber:(NSString *)number andChatNSString:(NSString *)chatNSS andIsSelf:(NSString *)isSelf andDate:(NSString *)date andStyle:(NSString*)style andSendTime:(NSString *)sendTime
{
    [[self sharedSJKFMDataBase]insertSQLWirhSender:prople andSender:sender andNumber:number andChatNSString:chatNSS andIsSelf:isSelf andDate:date andStyle:style andSendTime:sendTime];
}

/**
 *  插入数据
 */
-(void)insertSQLWirhSender:(NSString *)prople andSender:(NSString *)sender andNumber:(NSString *)number andChatNSString:(NSString *)chatNSS andIsSelf:(NSString *)isSelf andDate:(NSString *)date andStyle:(NSString*)style andSendTime:(NSString*)sendTime
{
    NSLog(@"要插入啦");
    [self creatSQLit:prople];
    if (![_database open])
    {
        [_database close];
        
        return;
    }

    // 插入数据 (步骤同建表)
      // NSString *inserSQL=[NSString stringWithFormat:@"insert into '%@'(number,name,chatNss,isSelf,sendDate) values(%ld,'%@','%@',%d,'%@')",sender,(long)number,sender,chatNSS,isSelf,date];
     NSString *inserSQL=[NSString stringWithFormat:@"insert into '%@'(name,chatNss,isSelf,sendDate,style,sendTime) values('%@','%@','%@','%@','%@','%@')",prople,sender,chatNSS,isSelf,date,style,sendTime];
    
    
    
    //    插入数据
        BOOL insertSucess=[_database executeUpdate:inserSQL];
    
    
    //    插入数据模型的变量的插入数据方法
   // BOOL insertSucess=[_database executeUpdate:inserSQL,stu.number,stu.name,stu.age,stu.gendar];
     NSLog(@"插入语句是:%d    %@",insertSucess,_database.lastErrorMessage);
 
}

/**
 *  取出查询数据的类方法
 */
+(NSMutableArray*)searchSQL:(NSString *)sender
{
  return[[self sharedSJKFMDataBase]searchSQL:sender];
}

/**
 *  取出查询
 */
-(NSMutableArray *)searchSQL:(NSString *)sender
{
    [self creatSQLit:sender];
    NSMutableArray *setDictUserArray=[[NSMutableArray alloc]init];
    
    //    2.7 查询
    NSString *selectSQL=[NSString stringWithFormat:@"select * from '%@'",sender];
    
    //    executeQuery  用此方法运行查询语句 返回值是FMResultSet类型
    FMResultSet *selectSet=[_database executeQuery:selectSQL];
    
    
    NSLog(@"%@",selectSet);
       //    指向下一个元素  方法next返回值是bool   yes是有值  no是无值

   
    while ([selectSet next])
    {
     //   :(NSString *)sender andNumber:(NSInteger)number andChatNSString:(NSString *)chatNSS andIsSelf:(BOOL)isSelf andDate:(NSDate *)date
//        name,chatNss,isSelf,sendDate
                //设置唯一标识
         //NSNumber *num=[NSNumber numberWithInt:[selectSet intForColumn:@"number"]];
        //发送人的名字
        NSString *sender=[selectSet stringForColumn:@"name"];
        //发送的文本内容
        NSString *cha=[selectSet stringForColumn:@"chatNss"];
        //发送人是不是自己
        NSString* isSelf=[selectSet stringForColumn:@"isSelf"];
        //设置发送消息的日期
        NSString *sendDate=[selectSet stringForColumn:@"sendDate"];
        //设置类型
        NSString *style=[selectSet stringForColumn:@"style"];
        //设置发送信息的时间
        NSString *sendTime=[selectSet stringForColumn:@"sendTime"];
        NSLog(@"分解取出来是%@，%@，%@，%@",sender,cha,isSelf,sendDate);
       
        
#pragma mark 设置字典用数组嫁接
#pragma mark 吧SQLit数据库库里面的isSelf 用来表示发送的文件的类型（是@“3”）的时候就表示发送的图片（解析图片）
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:@"0",@"number",sender,@"name",cha,@"content",isSelf,@"isSelf",sendDate,@"sendDate",style,@"style",sendTime,@"sendTime",nil];
        
               [setDictUserArray addObject:dict];
    }
    NSLog(@"取出来的消息是数组是%@",setDictUserArray);

    return setDictUserArray;
}

/**
 *  全部删除数据库的类方法
 */
+(void)removeAllSQL:(NSString *)sender
{
    [[self sharedSJKFMDataBase]removeAllSQL:sender];

}
/**
 *  全部删除
 */
-(void)removeAllSQL:(NSString *)sender
{
    [self creatSQLit:sender];
//     NSString *deleteSQL=[NSString stringWithFormat:@"delete from '%@'",sender];

    //运用dtop table的方法删除整个标下方的标志是又从1开始计数了
    NSString *deleteSQL=[NSString stringWithFormat:@"DROP TABLE '%@'",sender];
    //    执行删除语句
    
    BOOL deleteSuccess=[_database executeUpdate:deleteSQL];
    
    NSLog(@"删除数据:%d   %@",deleteSuccess,_database.lastErrorMessage);
    
}



/**
 *   根据条件删除数据库（根据下标）
 */
+(void)removeSQLWithName:(NSString*)sender WithNumber:(NSInteger)num
{

    [[SJKDataBase sharedSJKFMDataBase]removeSQLWithName:sender WithNumber:num];

}

/**
 *  根据条件删除数据库（根据下标）
 */
-(void)removeSQLWithName:(NSString*)sender WithNumber:(NSInteger)num
{[self creatSQLit:sender];
    
    NSString *deleteSQL=[NSString stringWithFormat:@"delete from '%@' where number=%ld",sender,(long)num];
//       NSString *deleteSQL=[NSString stringWithFormat:@"DROP TABLE '%@' where number=%ld",sender,(long)num];
    
    //    执行删除语句
    
    BOOL deleteSuccess=[_database executeUpdate:deleteSQL];
    
    NSLog(@"条件删除数据:%d   %@",deleteSuccess,_database.lastErrorMessage);
 }




//释放
-(void)dealloc
{
    
    //关闭数据库
    [_database close];
    _database=nil;
    
}

@end
