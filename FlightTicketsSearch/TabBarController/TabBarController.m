//
//  AppDelegate.h
//  FlightTicketsSearch
//
//  Created by Федор Филимонов on 31.01.2021.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "SearchViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype) init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTabBarController];
}

- (void)configureTabBarController {
    self.tabBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
}

- (NSArray<UIViewController*> *) createViewControllers {
    NSMutableArray<UIViewController*> *viewControllers = [NSMutableArray new];
    
    MainViewController *mainMenuViewController = [[MainViewController alloc] init];
    mainMenuViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Main" image:[UIImage systemImageNamed:@"bag"] selectedImage:[UIImage systemImageNamed:@"bag.fill"]];
    
    UINavigationController *firstNavigationController = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
    firstNavigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    [viewControllers addObject:firstNavigationController];
    
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    searchViewController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Search" image:[UIImage systemImageNamed:@"text.magnifyingglass"] selectedImage:[UIImage systemImageNamed:@"text.magnifyingglass"]];

    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    secondNavigationController.navigationBar.tintColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    [viewControllers addObject:secondNavigationController];
    
    return viewControllers;
}

@end
