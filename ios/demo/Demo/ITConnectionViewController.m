//
//  ITConnectionViewController.m
//  Demo
//
//  Created by Admin on 12.02.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITConnectionViewController.h"
#import "ITDemoManager.h"
#import "DejalActivityView.h"
#import "ITLoginViewController.h"
#import "ITConnectionDetailsViewController.h"
#import "ITConnection.h"
#import "ITLayoutTools.h"
#import "ITConnectionCell.h"

#define kConnectionDetailsSegue @"ConnectionDetailsSegue"
#define kNoConnectionsCellIdentifier @"NOCONNECTIONSCELL"

@interface ITConnectionViewController ()

@property (nonatomic, unsafe_unretained) UIInterfaceOrientation currentOrientation;
@property (strong, nonatomic) NSArray * connections;
@property (nonatomic, strong) NSArray * searchResults;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (nonatomic, unsafe_unretained) BOOL noConnections;
@property (nonatomic, unsafe_unretained) BOOL searchMode;
@property (nonatomic, unsafe_unretained) BOOL configForIOS7;

@end

@implementation ITConnectionViewController
{
    BOOL _needUpdate;
}

@synthesize refreshControl = _refreshControl;

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
        [self reloadConnections];
    }
    // Иначе - установить признак обновления. Обновление будет выполнено при отображении представления
    else
    {
        _needUpdate = YES;
    }
}

// Вертает список подключений. Если наложен фильтр - отфильтрованные подключения, иначе - все
- (NSArray *) actualItems
{
    if (self.searchMode)
    {
        return self.searchResults;
    }
    return self.connections;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ConnectionCell" bundle:nil] forCellReuseIdentifier:@"ConnectionCell"];
    // Добавить контрол для обновления таблицы
    [self createRefreshControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Если пользователь не выполнил вход - перебросить на страницу входа
    if (![ITDemoManager.sharedManager isLoggedIn])
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel: NSLocalizedString(@"Вход", nil)];
        [ITDemoManager.sharedManager tryLoginFromKeychain:^(BOOL success) {
            [DejalBezelActivityView removeView];
            if (!success)
            {
                ITLoginViewController * loginController = [ITLoginViewController new];
                [self presentViewController:loginController animated:YES completion:nil];
            }
            else
            {
                [self reloadConnections];
            }
        }];
    }
    
    // Если вход выполнен и необходимо обновить - обновить данные
    if ([[ITDemoManager sharedManager] isLoggedIn] && _needUpdate)
    {
        _needUpdate = NO;
        [self reloadConnections];
    }
    [self.tableView reloadData];
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
    [refreshControl addTarget:self action:@selector(reloadConnections) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)reloadConnections
{
    if ([[ITDemoManager sharedManager] isLoggedIn])
    {
        _needUpdate = NO;
        __weak ITConnectionViewController * theSelf = self;
        // Получить сотрудников из веб-сервиса
        [DejalBezelActivityView activityViewForView:self.view withLabel: NSLocalizedString(@"Загрузка подключений", nil)];
        [[ITDemoManager sharedManager] getConnections:nil withBlock:^(NSArray * connections) {
            [DejalBezelActivityView removeView];
            theSelf.connections = [[NSMutableArray alloc] initWithArray: connections];
            [theSelf updateUI];
        }];
    }
}

- (void) updateUI
{
    self.noConnections = self.connections.count == 0;
    [[self actualTableView] reloadData];
    [self.refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.noConnections)
    {
        return 1;
    }
    return [self actualItems].count;
}

// Ячейка для отображения "Нет подключений"
- (UITableViewCell *) noConnectionsCell
{
    UITableViewCell * noConnectionsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNoConnectionsCellIdentifier];
    noConnectionsCell.textLabel.text = NSLocalizedString(@"Нет подключений", nil);
    noConnectionsCell.textLabel.textColor = [UIColor darkGrayColor];
    noConnectionsCell.textLabel.textAlignment = NSTextAlignmentCenter;
    noConnectionsCell.textLabel.font = [UIFont systemFontOfSize:25];
    noConnectionsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return noConnectionsCell;
}

// Высота ячейки таблицы по индексу
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Если подключений нет - то ячейка занимает все пространство tableview
    if (self.noConnections)
    {
        return self.tableView.frame.size.height;
    }
    // Иначе рассчитать высоту ячейки
    ITConnection * item = [self actualItems][indexPath.row];
    return [ITLayoutTools calcHeightForConnection:item withShowFullInfo:YES];// fullInfo:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.noConnections)
    {
        UITableViewCell * noConnectionsCell = [tableView dequeueReusableCellWithIdentifier:kNoConnectionsCellIdentifier];
        if (noConnectionsCell == nil)
        {
            noConnectionsCell = [self noConnectionsCell];
        }
        return noConnectionsCell;
    }
    ITConnectionCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"ConnectionCell" forIndexPath:indexPath];
    cell.showFullInfo = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ITConnection * item = [[self actualItems] objectAtIndex:indexPath.row];
    cell.showFullInfo = YES;
    [cell setConnectionItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:kConnectionDetailsSegue sender:self];
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
    // Переход к детальной информации о подключении
    if ([segue.identifier isEqualToString:kConnectionDetailsSegue])
    {
        ITConnectionDetailsViewController * detailsController = (ITConnectionDetailsViewController *)segue.destinationViewController;
        [detailsController setConnectionItem:[self actualItems][[self actualTableView].indexPathForSelectedRow.row]];
        [detailsController setMasterController:self];
    }
}

// Фильтр подключений
- (void)filterContentForSearchText: (NSString*)searchText scope: (NSString*)scope
{
    if ([searchText  isEqualToString:@""])
    {
        self.searchResults = self.connections;
    }
    else
    {
        NSPredicate * resultPredicate = [NSPredicate predicateWithFormat:@"fio contains[c] %@ OR functionName contains[c] %@", searchText, searchText];
        self.searchResults = [self.connections filteredArrayUsingPredicate:resultPredicate];
    }
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

@end
