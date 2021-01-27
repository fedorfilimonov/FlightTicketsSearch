//
//  AppDelegate.h
//  FlightTicketsSearch
//
//  Created by Федор Филимонов on 27.01.2021.
//

#import "MapViewController.h"
#import "LocationManager.h"
#import "DataManager.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationManager *locationService;
@property (nonatomic, strong) City *origin;
@property (nonatomic, strong) MKPointAnnotation *theRedSquareAnnotation;
@end

@implementation MapViewController

//MARK: - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMapView];
    [self configureDataManager];
    [self configureNotificationCenter];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK: - Data Manager
- (void)configureDataManager {
    [[DataManager sharedInstance] loadData];
}

//MARK: - Notification Center
- (void) configureNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

- (void)dataLoadedSuccessfully {
    self.locationService = [[LocationManager alloc] init];
}

- (void)updateCurrentLocation: (NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [self.mapView setRegion:region animated:YES];
    
    if (currentLocation) {
        self.origin = [[DataManager sharedInstance] cityForLocation: currentLocation];
    }
}

- (void) configureMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.title = @"Prices";
    self.mapView.showsUserLocation = YES;
    [self.view addSubview: self.mapView];
    [self.mapView setDelegate:self];
}

- (void) configureTheRedSquareAnnotation {
    self.theRedSquareAnnotation = [[MKPointAnnotation alloc] init];
    self.theRedSquareAnnotation.coordinate = CLLocationCoordinate2DMake(55.753978581590445, 37.62080572697412);
    CLLocation *theRedSquareLocation = [[CLLocation alloc] initWithLatitude:55.753978581590445 longitude:37.62080572697412];
    [self theRedSquareAnnotationWithAddressFromLocation:theRedSquareLocation];
    [self.mapView addAnnotation:self.theRedSquareAnnotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

- (void)theRedSquareAnnotationWithAddressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            for (MKPlacemark *placemark in placemarks) {
                self.theRedSquareAnnotation.title = ((void)(@"%@"), placemark.locality);
                self.theRedSquareAnnotation.subtitle = ((void)(@"%@"), placemark.name);
            }
        }
    }];
}

- (void)addressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            for (MKPlacemark *placemark in placemarks) {
                NSLog(@"%@", placemark.locality);
                NSLog(@"%@", placemark.name);
            }
        }
    }];
}

- (void)locationFromAddress:(NSString *)address {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            for (MKPlacemark *placemark in placemarks) {
                NSLog(@"%@", placemark.location);
            }
        }
    }];
}

@end
