//
//  AppDelegate.h
//  FlightTicketsSearch
//
//  Created by Федор Филимонов on 17.01.2021.
//

#import "FirstViewController.h"
#import "SearchViewController.h"
#import "DataManager.h"

@interface FirstViewController ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *nextControllerButton;

@end

@implementation FirstViewController

//MARK: - ViewController Lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self configureLogo];
    [self configureNextControllerButton];
    [[DataManager sharedInstance] loadData];
}

- (void) configure {
    self.view.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:209.0/255.0 alpha:1.0];
    self.title = @"Flight Tickets Search";
}

- (void) configureLogo {
    self.logoImageView = [[UIImageView alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 150) / 2.0, 250, 150, 150)];
    self.logoImageView.image = [UIImage imageNamed:@"logo"];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.logoImageView];
}

- (void) configureNextControllerButton {
    self.nextControllerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.nextControllerButton setTitle:@"Search" forState:UIControlStateNormal];
    self.nextControllerButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:140.0/255.0 blue:180.0/255.0 alpha:1.0];
    self.nextControllerButton.tintColor = [UIColor whiteColor];
    self.nextControllerButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 500, 200, 50);
    self.nextControllerButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    [self.nextControllerButton addTarget:self action:@selector(pushNextControllerButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextControllerButton];
}

- (void) pushNextControllerButton: (UIButton *)sender {
    [self openSecondViewController];
}

- (void) openSecondViewController {
    SearchViewController *secondViewController = [[SearchViewController alloc] init];
    [self.navigationController showViewController:secondViewController sender:self];
}

@end
