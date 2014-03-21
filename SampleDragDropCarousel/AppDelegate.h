//
//  AppDelegate.h
//  SampleDragDropCarousel
//
//  Created by Firdous on 20/03/2014.
//  Copyright (c) 2014 Firdous. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarouselView;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    CarouselView *_carouselController;
}

@property (strong, nonatomic) UIWindow *window;

@end
