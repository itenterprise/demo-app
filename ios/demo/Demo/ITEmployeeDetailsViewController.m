//
//  ITEmployeeDetailsViewController.m
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITEmployeeDetailsViewController.h"
#import "ITLayoutTools.h"
#import "ITSectionHeaderCell.h"
#import "ITConnectionCell.h"
#import "ITConnectionDetailsViewController.h"
#import "ITEmployeeDetailsCell.h"
#import "DejalActivityView.h"
#import "ITDemoManager.h"

static const NSInteger kMaxSectionCount = 2;

@interface ITEmployeeDetailsViewController ()

@property (strong, nonatomic) NSMutableArray * headers;
@property (strong, nonatomic) NSArray * connections;
@property (nonatomic, unsafe_unretained) BOOL noConnections;

@end

@implementation ITEmployeeDetailsViewController
{
    BOOL _needUpdate;
}

@synthesize headers = _headers;

- (NSMutableArray *) headers
{
    if (_headers == nil)
    {
        _headers = [NSMutableArray new];
        for (int i = 0; i < kMaxSectionCount; i++)
        {
            [_headers addObject:[NSNull null]];
        }
    }
    return _headers;
}

// Установить признак необходимости обновить данные
- (void)reloadData
{
    // Если представление загружено - обновить
    if (self.view.window && self.isViewLoaded)
    {
        [self loadConnections];
    }
    // Иначе - установить признак обновления. Обновление будет выполнено при отображении представления
    else
    {
        _needUpdate = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"EmployeeDetailsCell" bundle:nil] forCellReuseIdentifier:@"EmployeeDetailsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ConnectionCell" bundle:nil] forCellReuseIdentifier:@"ConnectionCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Если необходимо обновить - обновить список подключений
    if (_needUpdate)
    {
        _needUpdate = NO;
        [self loadConnections];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEmployeeItem:(ITEmployee *)employeeItem
{
    _employeeItem = employeeItem;
    [self loadConnections];
}

- (void)loadConnections
{
    if ([self.employeeItem.login isEqualToString:@""])
    {
        [self updateUI];
        return;
    }
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Загрузка подключения", nil)];
    __weak ITEmployeeDetailsViewController * theSelf = self;
    [[ITDemoManager sharedManager] getConnections:self.employeeItem.login withBlock:^(NSArray * connections)
    {
        [DejalBezelActivityView removeView];
        theSelf.connections = connections;
        [theSelf updateUI];
    }];
}

- (void) updateUI
{
    self.noConnections = self.connections == nil || self.connections.count == 0;
    [self.tableView reloadData];
}

- (UITableViewCell *)createDetailsCell
{
    ITEmployeeDetailsCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"EmployeeDetailsCell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryType = UITableViewCellSelectionStyleNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    cell.delegate = self;
//    cell.userAddInfo = [self userById:self.caseItem.userAdd];
    [cell setEmployeeItem:self.employeeItem];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.connections.count;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 211;
        case 1:
            return [ITLayoutTools calcHeightForConnection:self.connections[indexPath.row] withShowFullInfo:NO];
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.noConnections ? 1 : 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [UIView new];
        case 1:
        {
            ITSectionHeaderCell * activeFunctionsHeader = [self createSectionHeaderForSection:section];
            activeFunctionsHeader.headerText = NSLocalizedString(@"Активные функции", nil);
            return activeFunctionsHeader;
        }
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0 && !self.noConnections)
    {
        return 44;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
            return [self createDetailsCell];
        case 1:
        {
            ITConnectionCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"ConnectionCell"];
            cell.showFullInfo = NO;
            [cell setConnectionItem:self.connections[indexPath.row]];
            return cell;
        }
        default:
            return nil;
    }
}

- (ITSectionHeaderCell *) createSectionHeaderForSection: (NSInteger)sectionIndex
{
    id view = self.headers[sectionIndex];
    if (view == [NSNull null])
    {
        NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"SectionHeaderCell" owner:self options:nil];
        self.headers[sectionIndex] = views[0];
    }
    return self.headers[sectionIndex];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            [self performSegueWithIdentifier:@"ConnectionDetailsSegue" sender:self];
            break;
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ConnectionDetailsSegue"])
    {
        ITConnectionDetailsViewController *connectionDetails = (ITConnectionDetailsViewController *)segue.destinationViewController;
        //connectionDetails.delegate = self;
        [connectionDetails setConnectionItem:[self connections][[self tableView].indexPathForSelectedRow.row]];
        [connectionDetails setMasterController:self];
    }
}

@end