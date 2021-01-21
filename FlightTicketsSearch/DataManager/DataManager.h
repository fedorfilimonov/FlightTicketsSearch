//
//  AppDelegate.h
//  FlightTicketsSearch
//
//  Created by Федор Филимонов on 17.01.2021.
//

#import <Foundation/Foundation.h>
#import "Country.h"
#import "City.h"
#import "Airport.h"

#define kDataManagerLoadDataDidComplete @"kDataManagerLoadDataDidComplete"

NS_ASSUME_NONNULL_BEGIN

typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport,
} DataSourceType;

typedef struct SearchRequest {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destination;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;

@interface DataManager : NSObject

+(instancetype) sharedInstance;
-(void) loadData;

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

@end

NS_ASSUME_NONNULL_END
