//
//  Student+CoreDataProperties.m
//  test4
//
//  Created by 彭明 on 2017/12/4.
//  Copyright © 2017年 pengming. All rights reserved.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Student"];
}

@dynamic age;
@dynamic memo;
@dynamic name;
@dynamic number;
@dynamic score;
@dynamic whoTeach;

@end
