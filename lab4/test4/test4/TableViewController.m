//
//  TableViewController.m
//  test4
//
//  Created by 彭明 on 2017/12/3.
//  Copyright © 2017年 pengming. All rights reserved.
//

#import "TableViewController.h"
#import "AppDelegate.h"
#import "Student+CoreDataClass.h"
#import "Teacher+CoreDataClass.h"
#import "ViewController.h"
@interface TableViewController ()
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableArray *students;
@property (strong, nonatomic) Student *student;
@property (strong, nonatomic) Teacher *teacher;
@end

@implementation TableViewController

- (NSManagedObjectContext *)context
{
    if (!_context) {
        AppDelegate *coreDataManager = [[AppDelegate alloc] init];
        _context = coreDataManager.persistentContainer.viewContext;
    }
    return _context;
}


- (NSArray *)queryData:(NSString *) entityname sortWith:(NSString *) sortDesc ascending:(BOOL) asc predicatString:(NSString *) ps
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.fetchLimit = 100;
    request.fetchBatchSize = 20;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortDesc ascending:asc]];
    if (ps) {
        request.predicate = [NSPredicate predicateWithFormat:@"name contains %@", ps];
    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityname inManagedObjectContext:self.context];
    request.entity = entity;
    NSError *error;
    NSArray *arrs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"无法获取数据，%@", error);
    }
    return arrs;
}


- (void)loadData
{
    NSArray *arrstudents = [self queryData:@"Student" sortWith:@"number" ascending:YES predicatString:nil];
    _students = [NSMutableArray array];
    for (Student *stu in arrstudents) {
        [_students addObject:stu];
    }
}


- (NSMutableArray *)students
{
    if (!_students) {
        [self loadData];
    }
    return _students;
}


- (Teacher *)teacher
{
    if (!_teacher) {
        NSArray *arrteacher = [self queryData:@"Teacher" sortWith:@"name" ascending:YES predicatString:@"Bai Tian"];
        if (arrteacher.count > 0) {
            _teacher = arrteacher[0];
        } else
        {
            NSError *error;
            Teacher *th = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.context];
            th.name = @"Bai Tian";
            th.age = 99;
            th.number = @"ST00002";
            [self.context save:&error];
            _teacher = th;
        }
    }
    return _teacher;
}


- (IBAction)refreshData:(UIRefreshControl *)sender {
    [self.refreshControl beginRefreshing];
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(quene, ^{
        [self.students removeAllObjects];
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    [self.refreshControl endRefreshing];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addinfo"]){
        if ([segue.destinationViewController isKindOfClass:[ViewController class]]){
            ViewController *vc = (ViewController *)segue.destinationViewController;
            vc.students = self.students;
            vc.context = self.context;
            vc.indexPath = nil;
            vc.teacher = self.teacher;
        }
    }
    
    if ([segue.identifier isEqualToString:@"showdetail"]){
        if ([segue.destinationViewController isKindOfClass:[ViewController class]]){
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            ViewController *vc = (ViewController *)segue.destinationViewController;
            vc.students = self.students;
            vc.context = self.context;
            vc.indexPath = indexPath;
            vc.teacher = self.teacher;
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.students count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    self.student = self.students[indexPath.row];
    cell.textLabel.text = self.student.name;
    cell.detailTextLabel.text = self.student.number;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.context deleteObject:self.students[indexPath.row]];
        [self.students removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSError *err;
        [self.context save:&err];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"modifyview"];
    vc.students = self.students;
    vc.indexPath = indexPath;
    vc.context = self.context;
    vc.teacher = self.teacher;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)searchInName:(NSString *)searchString
{
    [self.students removeAllObjects];
    NSArray *arrstudents = [self queryData:@"Student" sortWith:@"number" ascending:YES predicatString:searchString];
    for (Student *stu in arrstudents) {
        [self.students addObject:stu];
    }
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        return ;
    }
    [self searchInName:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchInName:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self searchInName:nil];
    [searchBar resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];

}


@end
