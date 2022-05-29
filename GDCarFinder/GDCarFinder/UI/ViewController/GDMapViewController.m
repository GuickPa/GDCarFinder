//
//  GDMapViewController.m
//  GDCarFinder
//
//  Created by Guglielmo Deletis on 29/05/22.
//

#import "GDMapViewController.h"
#import "GDCarFinder-Swift.h"

@interface GDMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) id<GDMapHandler> mapHandler;

@end

@implementation GDMapViewController
- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

- (id)initWithMapHandler:(id<GDMapHandler>)handler {
    self = [super initWithNibName:@"GDMapViewController" bundle:nil];
    self.mapHandler = handler;
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    [self doesNotRecognizeSelector:_cmd];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mapHandler viewDidLoadWithView:self.mapView];
}

#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self.mapHandler mapViewWithRegionDidChange:mapView];
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    [self.mapHandler mapViewWithDidFinishLoadingMap:mapView];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {
    [self.mapHandler mapViewWithDidFinishLoadingMap:mapView];
}

@end
