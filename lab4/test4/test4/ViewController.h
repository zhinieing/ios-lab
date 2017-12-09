//
//  ViewController.h
//  test4
//
//  Created by 彭明 on 2017/12/3.
//  Copyright © 2017年 pengming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher+CoreDataClass.h"
@interface ViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableArray *students;
@property (strong, nonatomic) Teacher *teacher;
@property (strong, nonatomic) NSIndexPath *indexPath; 
@end

