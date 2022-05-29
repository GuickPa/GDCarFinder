//
//  GDMapViewController.h
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 29/05/22.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@protocol GDMapHandler;

NS_ASSUME_NONNULL_BEGIN

@interface GDMapViewController : UIViewController <MKMapViewDelegate>
- (id)initWithMapHandler:(id<GDMapHandler>)handler;
@end

NS_ASSUME_NONNULL_END
