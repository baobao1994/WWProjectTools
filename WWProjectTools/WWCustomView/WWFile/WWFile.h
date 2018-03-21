//
//  WWFile.h
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/21.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cleanCacheBlock)(BOOL isSuccess, NSString *tip);
typedef void(^saveCacheBlock)(BOOL isSuccess, NSString *tip, NSString *filePath);

@interface WWFile : NSObject

+ (void)saveFileToHome:(id)fileObject block:(saveCacheBlock)block;
+ (void)saveFileToDocument:(id)fileObject block:(saveCacheBlock)block;
+ (void)saveFileToCache:(id)fileObject block:(saveCacheBlock)block;
+ (void)saveFileToLibaray:(id)fileObject block:(saveCacheBlock)block;

+ (void)deleteFileToHomePath:(NSString *)filePath block:(cleanCacheBlock)block;
+ (void)deleteFileToDocumentPath:(NSString *)filePath block:(cleanCacheBlock)block;
+ (void)deleteFileToCachePath:(NSString *)filePath block:(cleanCacheBlock)block;
+ (void)deleteFileToLibarayPath:(NSString *)filePath block:(cleanCacheBlock)block;

+ (void)clenFileToHome:(cleanCacheBlock)block;
+ (void)clenFileToDocument:(cleanCacheBlock)block;
+ (void)clenFileToCache:(cleanCacheBlock)block;
+ (void)clenFileToLibaray:(cleanCacheBlock)block;

+ (void)clenAllFile:(cleanCacheBlock)block;

/**
 * 获取已下载的文件大小
 */
+ (unsigned long long)getFileLengthToHomeFileName:(NSString *)fileName;
+ (unsigned long long)getFileLengthToDocumentFileName:(NSString *)fileName;
+ (unsigned long long)getFileLengthToCacheFileName:(NSString *)fileName;
+ (unsigned long long)getFileLengthToLibarayFileName:(NSString *)fileName;

+ (unsigned long long)getFileLength:(NSString *)path fileName:(NSString *)fileName;

@end

