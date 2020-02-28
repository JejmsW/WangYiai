//
//  HttpTool.m
//  05-二次封装AFN
//
//  Created by 大欢 on 16/8/4.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking.h>

static NSString * kBaseUrl = @"http://web.juhe.cn:8080";
@interface AFHttpClient : AFHTTPSessionManager
@property (strong,nonatomic) NSURLSessionDownloadTask *downloadTask;

+ (instancetype)sharedClient;

@end

@implementation AFHttpClient

+ (instancetype)sharedClient {
    
    static AFHttpClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] sessionConfiguration:configuration];
        //接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        //设置超时时间
        client.requestSerializer.timeoutInterval = 15;
        //安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
    });
    
    return client;
}

@end

@implementation HttpTool

+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
    //获取完整的url路径
//    NSString * url = [kBaseUrl stringByAppendingPathComponent:path];
    [[AFHttpClient sharedClient] GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];

}

+ (void)postWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
//    //字典转JSON
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *jsonString;
//    if (!jsonData) {
//        NSLog(@"%@",error);
//    }else{
//        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//    }
//    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
//    NSRange range = {0,jsonString.length};
//    //去掉字符串中的空格
//    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
//    NSRange range2 = {0,mutStr.length};
//    //去掉字符串中的换行符
//    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
//    NSLog(@"%@",mutStr);
    //获取完整的url路径
    NSString * url = [kBaseUrl stringByAppendingString:path];
    [[AFHttpClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
    
}

+ (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:path];
//
//    //下载
    NSURL *URL = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[AFHttpClient sharedClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@",downloadProgress);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"%f",downloadProgress.fractionCompleted);
            progress(downloadProgress.fractionCompleted);
//        });
        
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //获取沙盒cache路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            failure(error);
        } else {
            success(filePath.path);
        }
        
    }];
    
    [downloadTask resume];



}

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:path];
    
    NSData * data = UIImagePNGRepresentation(image);
    
    [[AFHttpClient sharedClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:imagekey fileName:@"01.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}
+(id)myHttpTool{
    NSURL *URL = [NSURL URLWithString:@"http://www.ssyshop.com/chemadian/updata/update.apk"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    NSURLSessionDownloadTask *downloadTask= [manger downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%f",downloadProgress.fractionCompleted);
        
        //        NSString *progresStr = [NSString stringWithFormat:@"%@",downloadProgress];
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSLog(@"%@",documentsDirectoryURL);
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            NSLog(@"失败");
        } else {
            NSLog(@"成功");
        }
    }];
    [downloadTask resume];
//    return downloadProgress.fractionCompleted;
    return downloadTask;
}

@end
