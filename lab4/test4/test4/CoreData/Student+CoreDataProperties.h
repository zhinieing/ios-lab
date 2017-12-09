//
//  Student+CoreDataProperties.h
//  test4
//
//  Created by 彭明 on 2017/12/4.
//  Copyright © 2017年 pengming. All rights reserved.
//
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *memo;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *number;
@property (nonatomic) float score;
@property (nullable, nonatomic, retain) Teacher *whoTeach;

@end

NS_ASSUME_NONNULL_END
