//
//  ETFileModel.h
//  能量圈
//
//  Created by 王斌 on 2017/11/24.
//  Copyright © 2017年 王斌. All rights reserved.
//

#import "JSONModel.h"

@interface ETFileModel : JSONModel

/** 文件ID */
@property (nonatomic, strong) NSString<Optional> *FileID;
/** 文件名 */
@property (nonatomic, strong) NSString<Optional> *FileName;
/** 文件路径 */
@property (nonatomic, strong) NSString<Optional> *FilePath;
/** 新文件名 */
@property (nonatomic, strong) NSString<Optional> *NewFileName;
/** SourceID */
@property (nonatomic, strong) NSString<Optional> *SourceID;
/** SourceName */
@property (nonatomic, strong) NSString<Optional> *SourceName;
/** ThumbnailsPath */
@property (nonatomic, strong) NSString<Optional> *ThumbnailsPath;

@end
