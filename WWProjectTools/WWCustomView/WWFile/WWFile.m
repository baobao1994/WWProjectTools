//
//  WWFile.m
//  WWProjectTools
//
//  Created by 郭伟文 on 2018/3/21.
//  Copyright © 2018年 baobao. All rights reserved.
//

#import "WWFile.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+Addition.h"

//Home目录
#define HomePath NSHomeDirectory()
//Document目录
#define DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//Cache目录
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
//Libaray目录
#define LibarayPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation WWFile

+ (void)saveFileToHome:(id)fileObject block:(saveCacheBlock)block {
    [WWFile saveFilePath:HomePath fileObject:fileObject block:block];
}

+ (void)saveFileToDocument:(id)fileObject block:(saveCacheBlock)block {
    [WWFile saveFilePath:DocumentPath fileObject:fileObject block:block];
}

+ (void)saveFileToCache:(id)fileObject block:(saveCacheBlock)block {
    [WWFile saveFilePath:CachePath fileObject:fileObject block:block];
}

+ (void)saveFileToLibaray:(id)fileObject block:(saveCacheBlock)block {
    [WWFile saveFilePath:LibarayPath fileObject:fileObject block:block];
}

+ (void)saveFilePath:(NSString *)path fileObject:(id)fileObject block:(saveCacheBlock)block {
    NSString *fileName = @"";
    id saveFile;
    if ([fileObject isKindOfClass:[QMUIAsset class]]) {
        QMUIAsset *file = (QMUIAsset *)fileObject;
        fileName = [file.phAsset valueForKey:@"filename"];
        saveFile = file.originImage;
    }
    // 沙盒文件路径
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSLog(@"File save to: %@",filePath);
    BOOL isSaveSuccess = false;
    NSString *tip;
    // 创建一个空的文件到沙盒中
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:filePath]) {
        // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
        [manager createFileAtPath:path contents:nil attributes:nil];
        if ([saveFile isKindOfClass:[UIImage class]]) {
            NSData *data = [UIImage zipNSDataWithImage:saveFile];
            isSaveSuccess = [data writeToFile:filePath atomically:YES];
        }
        if (isSaveSuccess) {
            tip = @"保存成功";
        } else {
            tip = @"保存失败";
        }
    } else {
        tip = @"已存在";
    }
    //返回主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        block(isSaveSuccess,tip,filePath);
    });
}

+ (void)deleteFileToHomePath:(NSString *)filePath block:(cleanCacheBlock)block {
    [WWFile clenFilePath:HomePath needClenFilePath:filePath block:block];
}

+ (void)deleteFileToDocumentPath:(NSString *)filePath block:(cleanCacheBlock)block {
    [WWFile clenFilePath:DocumentPath needClenFilePath:filePath block:block];
}

+ (void)deleteFileToCachePath:(NSString *)filePath block:(cleanCacheBlock)block {
    [WWFile clenFilePath:CachePath needClenFilePath:filePath block:block];
}

+ (void)deleteFileToLibarayPath:(NSString *)filePath block:(cleanCacheBlock)block {
    [WWFile clenFilePath:LibarayPath needClenFilePath:filePath block:block];
}

+ (void)clenFileToHome:(cleanCacheBlock)block {
    [WWFile clenFilePath:HomePath needClenFilePath:nil block:block];
}

+ (void)clenFileToDocument:(cleanCacheBlock)block {
    [WWFile clenFilePath:DocumentPath needClenFilePath:nil block:block];
}

+ (void)clenFileToCache:(cleanCacheBlock)block {
    [WWFile clenFilePath:CachePath needClenFilePath:nil block:block];
}

+ (void)clenFileToLibaray:(cleanCacheBlock)block {
    [WWFile clenFilePath:LibarayPath needClenFilePath:nil block:block];
}

+ (void)clenAllFile:(cleanCacheBlock)block {
    [WWFile clenFileToHome:block];
    [WWFile clenFileToDocument:block];
    [WWFile clenFileToCache:block];
    [WWFile clenFileToLibaray:block];
}

+ (void)clenFilePath:(NSString *)path needClenFilePath:(NSString *)needClenFilePath block:(cleanCacheBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isSuccess = (needClenFilePath.length)? NO:YES;
        NSString *tip = (needClenFilePath.length)? @"删除失败":@"删除成功";
        NSArray *subpaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
        for (NSString *subPath in subpaths) {
            NSString *filePath = [path stringByAppendingPathComponent:subPath];
            NSLog(@"clen subPath = %@",subPath);
            NSLog(@"clen filePath = %@",filePath);
            if (needClenFilePath.length && [filePath isEqualToString:needClenFilePath]) {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                isSuccess = YES;
                break;
            } else {
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
        }
        //返回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            block(isSuccess,tip);
        });
    });
}

/**
 * 获取已下载的文件大小
 */

+ (unsigned long long)getFileLengthToHomeFileName:(NSString *)fileName {
    return [WWFile getFileLength:HomePath fileName:fileName];
}

+ (unsigned long long)getFileLengthToDocumentFileName:(NSString *)fileName {
    return [WWFile getFileLength:DocumentPath fileName:fileName];
}

+ (unsigned long long)getFileLengthToCacheFileName:(NSString *)fileName {
    return [WWFile getFileLength:CachePath fileName:fileName];
}

+ (unsigned long long)getFileLengthToLibarayFileName:(NSString *)fileName {
    return [WWFile getFileLength:LibarayPath fileName:fileName];
}

+ (unsigned long long)getFileLength:(NSString *)path fileName:(NSString *)fileName {
    // 沙盒文件路径
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:filePath error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

@end
