//
//  Teacher+CoreDataProperties.m
//  test4
//
//  Created by 彭明 on 2017/12/4.
//  Copyright © 2017年 pengming. All rights reserved.
//
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Teacher"];
}

@dynamic age;
@dynamic name;
@dynamic number;
@dynamic students;

@end
