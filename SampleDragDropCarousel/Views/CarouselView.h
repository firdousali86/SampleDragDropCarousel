//
//  CarouselView.h
//
//  Created by Firdous on 18/03/2014.
//

#import "iCarousel.h"

@interface CarouselView : UIViewController<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carouselTop;
@property (nonatomic, strong) IBOutlet iCarousel *carouselBottom;

@end
