//
//  ViewController.m
//  test4
//
//  Created by 彭明 on 2017/12/3.
//  Copyright © 2017年 pengming. All rights reserved.
//

#import "ViewController.h"
#import "Student+CoreDataClass.h"
#import "TableViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtAge;
@property (weak, nonatomic) IBOutlet UITextField *txtScore;
@property (weak, nonatomic) IBOutlet UITextView *txtMemo;
@property (weak, nonatomic) IBOutlet UITextField *txtTeacher;

@end

@implementation ViewController

- (IBAction)inputNumber:(UITextField *)sender {
    BOOL txt = NO;
    NSString *value = [[sender text] stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    if (sender.tag == 1) {
        if ([value length] != 0) {
            txt = YES;
        }
    }
    if (sender.tag == 2) {
        if ([value length] != 0) {
            if (![value isEqualToString:@"."]) {
                txt = YES;
            }
        }
                
        float score = [[sender text] floatValue];
        if (score <= 0 || score >= 100) {
            txt = YES;
        }
    }
    
    if (txt) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"警告提示" message:@"重新输入内容" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sender setText:@""];
        }];
        
        [ac addAction:action];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
}



- (IBAction)DataSave:(UIButton *)sender {
    
    Student *student;
    if (self.indexPath == nil) {
        student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
        [self.students addObject:student];
    } else
        student = self.students[self.indexPath.row];
    
    student.name = self.txtName.text;
    student.number = self.txtNumber.text;
    student.age = [self.txtAge.text integerValue];
    student.score = [self.txtScore.text floatValue];
    student.memo = self.txtMemo.text;
    student.whoTeach = self.teacher;
    NSError *errorstudent;
    if (![self.context save:&errorstudent]) {
        NSLog(@"保存时出错：%@", errorstudent);
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)DataClear:(UIButton *)sender {
    self.txtName.text = nil;
    self.txtNumber.text = nil;
    self.txtAge.text = nil;
    self.txtScore.text = nil;
    self.txtMemo.text = nil;
    self.txtTeacher.text = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.indexPath != nil){
        Student *student = self.students[self.indexPath.row];
        self.txtName.text = student.name;
        self.txtNumber.text = student.number;
        self.txtAge.text = [NSString stringWithFormat:@"%ld", (long)student.age];
        self.txtScore.text = [NSString stringWithFormat:@"%f", student.score];
        self.txtMemo.text = student.memo;
        self.txtTeacher.text = student.whoTeach.name;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

@end
