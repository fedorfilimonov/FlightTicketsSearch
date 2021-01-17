//
//  AppDelegate.h
//  FlightTicketsSearch
//
//  Created by Федор Филимонов on 17.01.2021.
//

#import "SecondViewController.h"
#import "DataManager.h"

@interface SecondViewController ()
@property (nonatomic, strong) UITextField *departureCityTextField;
@property (nonatomic, strong) UITextField *arrivalCityTextField;
@property (nonatomic, strong) UISegmentedControl *classControl;
@property (nonatomic, strong) UIButton *loadDataButton;
@property (nonatomic, strong) UILabel *completeLoadDataLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIProgressView *progressIndicator;
@end

@implementation SecondViewController

//MARK: - ViewController Lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self configureFromCityTextField];
    [self configureToCityTextField];
    [self configureLoadDataButton];
    [self configureCompleteLoadDataLabel];
    [self addObserverInNotificationCenter];
}

- (void) dealloc
{
    [self removeObserverFromNotificationCenter];
}

- (void) configure {
    self.view.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:209.0/255.0 alpha:1.0];
    self.title = @"Search";
}

-(void) configureFromCityTextField {
    self.departureCityTextField = [[UITextField alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 250, 300, 40)];
    self.departureCityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.departureCityTextField.placeholder = @"From";
    self.departureCityTextField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.view addSubview:self.departureCityTextField];
}

-(void) configureToCityTextField {
    self.arrivalCityTextField = [[UITextField alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 310, 300, 40)];
    self.arrivalCityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.arrivalCityTextField.placeholder = @"To";
    self.arrivalCityTextField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.view addSubview:self.arrivalCityTextField];
}

- (void) configureLoadDataButton {
    self.loadDataButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loadDataButton setTitle:@"Search" forState:UIControlStateNormal];
    self.loadDataButton.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:140.0/255.0 blue:180.0/255.0 alpha:1.0];
    self.loadDataButton.tintColor = [UIColor whiteColor];
    self.loadDataButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 500, 200, 50);
    self.loadDataButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    [self.loadDataButton addTarget:self action:@selector(pushLoadDataButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loadDataButton];
}

- (void) configureCompleteLoadDataLabel {
    self.completeLoadDataLabel = [[UILabel alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 550, 200, 50)];
    self.completeLoadDataLabel.textColor = [UIColor whiteColor];
    self.completeLoadDataLabel.text = @"We found tickets!";
    self.completeLoadDataLabel.textAlignment = NSTextAlignmentCenter;
    self.completeLoadDataLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    [self.completeLoadDataLabel setHidden:YES];
    [self.view addSubview:self.completeLoadDataLabel];
}

- (void) pushLoadDataButton: (UIButton *)sender {
    [self.activityIndicator startAnimating];
    [self.progressIndicator setHidden:NO];
    self.progressIndicator.progress = 0.5;
    [[DataManager sharedInstance] loadData];
}

- (void) showCompleteLoadDataLabel {
    [self.completeLoadDataLabel setHidden:NO];
}

- (void) loadDataComplete {
    [self.activityIndicator stopAnimating];
    [self.progressIndicator setHidden:YES];
    [self showCompleteLoadDataLabel];
}

- (void) addObserverInNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
}

- (void) removeObserverFromNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

@end
