//
//  ITEmployeeViewController.m
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITEmployeeViewController.h"
#import "ITDemoManager.h"
#import "DejalActivityView.h"
#import "ITLoginViewController.h"
#import "ITEmployeeDetailsViewController.h"
#import "ITEmployee.h"
#import "ITLayoutTools.h"
#import "ITEmployeeCell.h"
#import "AppDelegate.h"

#define kEmployeeDetailsSegue @"EmployeeDetailsSegue"
#define kNoEmployeesCellIdentifier @"NOEMPLOYEESCELL"

@interface ITEmployeeViewController ()

@property (nonatomic, unsafe_unretained) UIInterfaceOrientation currentOrientation;
@property (strong, nonatomic) NSArray * employees;
@property (nonatomic, strong) NSArray * searchResults;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (nonatomic, unsafe_unretained) BOOL noEmployees;
@property (nonatomic, unsafe_unretained) BOOL searchMode;
@property (nonatomic, unsafe_unretained) BOOL configForIOS7;
@property (weak, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController * fetchedResultController;
@property (strong, nonatomic) NSArray * users;

@end

@implementation ITEmployeeViewController

@synthesize refreshControl = _refreshControl;
@synthesize fetchedResultController = _fetchedResultController;

BOOL _needUpdate = NO;

- (NSManagedObjectContext *)managedObjectContext
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
}

- (id)init
{
    return [super init];
}

// Установить признак необходимости обновить данные
- (void)reloadData
{
    // Если представление загружено - обновить
    if (self.view.window && self.isViewLoaded)
    {
        [self reloadEmployees];
    }
    // Иначе - установить признак обновления. Обновление будет выполнено при отображении представления
    else
    {
        _needUpdate = YES;
    }
}

// Вертает список сотрудников. Если наложен фильтр - отфильтрованные сотрудники, иначе - все
- (NSArray *) actualItems
{
    if (self.searchMode)
    {
        return self.searchResults;
    }
    return self.employees;
}

// Вертает таблицу. Если фильтр установлен - таблицу с фильтром, иначе таблицу для всех ячеек
- (UITableView *) actualTableView
{
    if (self.searchMode)
    {
        return self.searchDisplayController.searchResultsTableView;
    }
    return self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _needUpdate = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EmployeeCell" bundle:nil] forCellReuseIdentifier:@"EmployeeCell"];
    // Добавить контрол для обновления таблицы
    [self createRefreshControl];
    
    [self initFetchedResultsController];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Если пользователь не выполнил вход - перебросить на страницу входа
    if (![ITDemoManager.sharedManager isLoggedIn])
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel: NSLocalizedString(@"Вход", nil)];
        [ITDemoManager.sharedManager tryLoginFromKeychain:^(BOOL success) {
            [[ITDemoManager sharedManager] updateAccountInfo];
            [DejalBezelActivityView removeView];
            if (!success)
            {
                ITLoginViewController * loginController = [ITLoginViewController new];
                [self presentViewController:loginController animated:YES completion:nil];
            }
            else
            {
                [self reloadEmployees];
            }
        }];
    }
    
    // Если вход выполнен и необходимо обновить - обновить данные
    if ([[ITDemoManager sharedManager] isLoggedIn] && _needUpdate)
    {
        _needUpdate = NO;
        [self reloadEmployees];
    }
    [self.tableView reloadData];
    [[ITDemoManager sharedManager] updateAccountInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.configForIOS7)
    {
        self.configForIOS7 = YES;
        [self.searchDisplayController setActive:NO];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        self.navigationController.navigationBar.hidden = NO;
        [self.searchDisplayController setActive:YES];
        [self.searchDisplayController setActive:NO];
        self.searchMode = NO;
    }
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

// Создать контрол для обновления
- (void) createRefreshControl
{
    UIRefreshControl * refreshControl = [UIRefreshControl new];
    refreshControl.tintColor = [UIColor blueColor];
    refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(reloadEmployees) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)reloadEmployees
{
    if ([[ITDemoManager sharedManager] isLoggedIn])
    {
        _needUpdate = NO;
        __weak ITEmployeeViewController * theSelf = self;
        // Получить сотрудников из веб-сервиса
        [DejalBezelActivityView activityViewForView:self.view withLabel: NSLocalizedString(@"Загрузка сотрудников", nil)];
        [[ITDemoManager sharedManager] getEmployees:nil withBlock:^(NSArray * employees) {
            [DejalBezelActivityView removeView];
            theSelf.employees = [[NSMutableArray alloc] initWithArray: employees];
            [theSelf updateUI];
        }];
    }
}

- (void) updateUI
{
    [self afterDataLoaded];
    self.noEmployees = self.employees.count == 0;
    [[self actualTableView] reloadData];
    [self.refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.noEmployees)
    {
        return 1;
    }
    return [self actualItems].count;
}

// Ячейка для отображения "Нет сотрудников"
- (UITableViewCell *) noEmployeesCell
{
    UITableViewCell * noEmployeesCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNoEmployeesCellIdentifier];
    noEmployeesCell.textLabel.text = NSLocalizedString(@"Нет сотрудников", nil);
    noEmployeesCell.textLabel.textColor = [UIColor darkGrayColor];
    noEmployeesCell.textLabel.textAlignment = NSTextAlignmentCenter;
    noEmployeesCell.textLabel.font = [UIFont systemFontOfSize:25];
    noEmployeesCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return noEmployeesCell;
}

// Высота ячейки таблицы по индексу
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Если задач нет - то ячейка занимает все пространство tableview
    if (self.noEmployees)
    {
        return self.tableView.frame.size.height;
    }
    // Иначе рассчитать высоту ячейки
    ITEmployee * item = [self actualItems][indexPath.row];
    return [ITLayoutTools calcHeightForEmployee:item];// fullInfo:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.noEmployees)
    {
        UITableViewCell * noEmployeesCell = [tableView dequeueReusableCellWithIdentifier:kNoEmployeesCellIdentifier];
        if (noEmployeesCell == nil)
        {
            noEmployeesCell = [self noEmployeesCell];
        }
        return noEmployeesCell;
    }
    ITEmployeeCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"EmployeeCell" forIndexPath:indexPath];
    cell.showFullInfo = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ITEmployee * item = [[self actualItems] objectAtIndex:indexPath.row];
    [cell setEmployeeItem:item];
    [cell setUserInfo:[self userById:item.login]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kEmployeeDetailsSegue sender:self];
}

// Показать меню слева
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

// Не показывать меню справа
- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Переход к детальной информации о сотруднике
    if ([segue.identifier isEqualToString:kEmployeeDetailsSegue])
    {
        ITEmployee *employee = [self actualItems][[self actualTableView].indexPathForSelectedRow.row];
        employee.photo = [self userById:employee.login].imageContents;
        ITEmployeeDetailsViewController * detailsController = (ITEmployeeDetailsViewController *)segue.destinationViewController;
        [detailsController setEmployeeItem:employee];
    }
}

// Фильтр сотрудников
- (void)filterContentForSearchText: (NSString*)searchText scope: (NSString*)scope
{
    NSPredicate * resultPredicate = [NSPredicate predicateWithFormat:@"fio contains[c] %@ OR department contains[c] %@", searchText, searchText];
    self.searchResults = [self.employees filteredArrayUsingPredicate:resultPredicate];
}

// Изменили строку фильтра
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length == 0)
    {
        self.searchMode = NO;
        [self.tableView reloadData];
    }
    else
    {
        [self filterContentForSearchText:searchString
                                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
        self.searchMode = YES;
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchMode = NO;
    self.searchDisplayController.active = NO;
    [self.tableView reloadData];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    self.searchMode = YES;
}

- (void)orientationChanged: (NSNotification *)notification
{
    if (self.currentOrientation != [UIApplication sharedApplication].statusBarOrientation)
    {
        self.currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
        [self.tableView reloadData];
    }
}

- (void)loginControllerDidLoginSuccessfully
{
    [self reloadData];
}

// Выполнить инициализацию контроллера для выборки данных из Core Data
- (void)initFetchedResultsController
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"userId" ascending:YES]]];
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [self.fetchedResultController performFetch:nil];
    self.fetchedResultController.delegate = self;
}

- (void)afterDataLoaded
{
    [self loadUsers];
    [[ITDemoManager sharedManager] usersInfosForUsers:[self userIds] withBlock: ^{
        [self loadUsers];
        [self.tableView reloadData];
    }];
}

- (void)loadUsers
{
    NSArray * users = [self userIds];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(self.userId IN %@)", users];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    [fetchRequest setPredicate:predicate];
    self.users = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (UserInfo *)userById: (NSString *)userId
{
    NSArray * filtered = [self.users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.userId == %@", userId]];
    if (filtered.count)
    {
        return filtered[0];
    }
    return nil;
}

- (NSArray *)userIds
{
    NSMutableArray * userIds = [NSMutableArray new];
    for (ITEmployee * employee in self.employees)
    {
        [userIds addObject:employee.login];
    }
    return [[NSSet setWithArray:userIds] allObjects];
}

@end
