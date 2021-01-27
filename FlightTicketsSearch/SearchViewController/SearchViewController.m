//
//  AppDelegate.h
//  FlightTicketsSearch
//
//  Created by Федор Филимонов on 17.01.2021.
//

#import "SearchViewController.h"
#import "DataManager.h"
#import "PlaceViewController.h"
#import "MapViewController.h"

@interface SearchViewController () <PlaceViewControllerDelegate>
@property (nonatomic, strong) UITextField *departureCityTextField;
@property (nonatomic, strong) UITextField *arrivalCityTextField;
@property (nonatomic, strong) UISegmentedControl *classControl;
@property (nonatomic, strong) UIButton *loadDataButton;
@property (nonatomic, strong) UILabel *completeLoadDataLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIProgressView *progressIndicator;
@property (nonatomic, strong) UIButton *departureSearchButton;
@property (nonatomic, strong) UIButton *departureMapButton;
@property (nonatomic, strong) UIButton *arrivalSearchButton;
@property (nonatomic, strong) UIButton *arrivalMapButton;
@property (nonatomic) SearchRequest searchRequest;

@end

@implementation SearchViewController

//MARK: - ViewController Lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self configureFromCityTextField];
    [self configureToCityTextField];
    [self configureLoadDataButton];
    [self configureCompleteLoadDataLabel];
    [self addObserverInNotificationCenter];
    [self configureDepartureCitySearchButton];
    [self configureDepartureCityMapButton];
    [self configureArrivalCitySearchButton];
    [self configureArrivalCityMapButton];
}

- (void) dealloc {
    [self removeObserverFromNotificationCenter];
}

- (void) configure {
    self.view.backgroundColor = [UIColor colorWithRed:27.0/255.0 green:165.0/255.0 blue:209.0/255.0 alpha:1.0];
    self.title = @"Search";
}

-(void) configureFromCityTextField {
    self.departureCityTextField = [[UITextField alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 250, 200, 40)];
    self.departureCityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.departureCityTextField.placeholder = @"From";
    self.departureCityTextField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.view addSubview:self.departureCityTextField];
}

-(void) configureToCityTextField {
    self.arrivalCityTextField = [[UITextField alloc] initWithFrame: CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0, 310, 200, 40)];
    self.arrivalCityTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.arrivalCityTextField.placeholder = @"To";
    self.arrivalCityTextField.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self.view addSubview:self.arrivalCityTextField];
}

- (void) configureDepartureCitySearchButton {
    self.departureSearchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.departureSearchButton setImage:[UIImage systemImageNamed:@"magnifyingglass"] forState:UIControlStateNormal];
    self.departureSearchButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.departureSearchButton.tintColor = [UIColor whiteColor];
    self.departureSearchButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 400) / 2.0 + 260, 250, 40, 40);
    [self.departureSearchButton addTarget:self action:@selector(pushFindDepartureOrArrivalPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.departureSearchButton];
}

- (void) configureDepartureCityMapButton {
    self.departureMapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.departureMapButton setImage:[UIImage systemImageNamed:@"map"] forState:UIControlStateNormal];
    self.departureMapButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.departureMapButton.tintColor = [UIColor whiteColor];
    self.departureMapButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0 + 260, 250, 40, 40);
    [self.departureMapButton addTarget:self action:@selector(pushMap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.departureMapButton];
}

- (void) configureArrivalCitySearchButton {
    self.arrivalSearchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.arrivalSearchButton setImage:[UIImage systemImageNamed:@"magnifyingglass"] forState:UIControlStateNormal];
    self.arrivalSearchButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.arrivalSearchButton.tintColor = [UIColor whiteColor];
    self.arrivalSearchButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 400) / 2.0 + 260, 310, 40, 40);
    [self.arrivalSearchButton addTarget:self action:@selector(pushFindDepartureOrArrivalPlaceButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.arrivalSearchButton];
}

- (void) configureArrivalCityMapButton {
    self.arrivalMapButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.arrivalMapButton setImage:[UIImage systemImageNamed:@"map"] forState:UIControlStateNormal];
    self.arrivalMapButton.backgroundColor = [UIColor colorWithRed:120.0/255.0 green:80.0/255.0 blue:155.0/255.0 alpha:1.0];
    self.arrivalMapButton.tintColor = [UIColor whiteColor];
    self.arrivalMapButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 300) / 2.0 + 260, 310, 40, 40);
    [self.arrivalMapButton addTarget:self action:@selector(pushMap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.arrivalMapButton];
}

- (void) pushFindDepartureOrArrivalPlaceButton: (UIButton *)sender {
    PlaceViewController *placeViewController;
    if ([sender isEqual: self.departureSearchButton]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController showViewController:placeViewController sender:self];
}

- (void) pushMap: (UIButton *)sender {
    MapViewController *mapViewController = [[MapViewController alloc] init];
    [self.navigationController showViewController:mapViewController sender:self];
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

- (void)selectPlace:(nonnull id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
    [self setPlace:place withDataType:dataType andPlaceType:placeType forTextField: (placeType == PlaceTypeDeparture) ? self.departureCityTextField : self.arrivalCityTextField];
}

- (void)setPlace:(id)place withDataType:(DataSourceType)dataType andPlaceType:(PlaceType)placeType forTextField:(UITextField *)textField {
    NSString *title;
    NSString *iata;
    
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        iata = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        iata = airport.cityCode;
    }
    
    if (placeType == PlaceTypeDeparture) {
        _searchRequest.origin = iata;
        self.departureCityTextField.text = title;
    } else {
        _searchRequest.destination = iata;
        self.arrivalCityTextField.text = title;
    }
}

@end
