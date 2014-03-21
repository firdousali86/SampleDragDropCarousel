//
//  CarouselView.m
//
//  Created by Firdous on 18/03/2014.
//

#import "CarouselView.h"
#import "Constant.h"

#define CORNER_RADIUS 2

@interface CarouselView ()

@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *itemsTop;
@property (nonatomic, strong) NSMutableArray *itemsBottom;

@end

@implementation CarouselView

@synthesize carouselTop, carouselBottom;
@synthesize wrap;
@synthesize itemsTop, itemsBottom;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setUp];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    carouselBottom.type = iCarouselTypeWheel;
    carouselBottom.vertical = NO;
    [carouselBottom setTag:CAROUSEL_BOTTOM];
    carouselBottom.ignorePerpendicularSwipes = NO;
    
    [carouselTop setTag:CAROUSEL_TOP];
    carouselTop.ignorePerpendicularSwipes = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUp
{
    //set up data
    wrap = NO;
    
    self.itemsTop = [NSMutableArray array];
    for (int i = 0; i < 10; i++)
    {
        [itemsTop addObject:@(i)];
    }
    
    self.itemsBottom = [NSMutableArray array];
    for (int i = 20; i < 30; i++)
    {
        [itemsBottom addObject:@(i)];
    }
}

- (void)moveItemToTop:(NSInteger)itemIndex{
    
    NSInteger index = MAX(0, carouselTop.currentItemIndex);
    
    if (!carouselBottom.isCardInsertedLeft && [self.itemsTop count] > 0) {
        index += 1;
    }
    
    //item addressed
    NSInteger itemAddressed = [[self.itemsBottom objectAtIndex:itemIndex] integerValue];
    
    // remove from bottom
    if (carouselBottom.numberOfItems > 0)
    {
        //NSInteger index = carouselBottom.currentItemIndex;
        [itemsBottom removeObjectAtIndex:itemIndex];
        [carouselBottom removeItemAtIndex:itemIndex animated:YES];
    }
    //add to top
    [itemsTop insertObject:@(itemAddressed) atIndex:index];
    [carouselTop insertItemAtIndex:index animated:YES];
}

- (void)moveItemToBottom:(NSInteger)itemIndex{
    
    NSInteger index = MAX(0, carouselBottom.currentItemIndex);
    
    if (!carouselTop.isCardInsertedLeft && [self.itemsBottom count] > 0) {
        index += 1;
    }
    
    //item addressed
    NSInteger itemAddressed = [[self.itemsTop objectAtIndex:itemIndex] integerValue];
    
    //remove from top
    if (carouselTop.numberOfItems > 0)
    {
        //NSInteger index = carouselTop.currentItemIndex;
        [itemsTop removeObjectAtIndex:itemIndex];
        [carouselTop removeItemAtIndex:itemIndex animated:YES];
    }
    
    //add to bottom
    [itemsBottom insertObject:@(itemAddressed) atIndex:index];
    [carouselBottom insertItemAtIndex:index animated:YES];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if (carousel == carouselTop) {
        return [itemsTop count];
    }
    else
        return [itemsBottom count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (carousel == carouselTop) {
        return [self getCardViewForItemAtIndex:index reusingView:view itemsArray:self.itemsTop];
    }
    else{
        return [self getCardViewForItemAtIndex:index reusingView:view itemsArray:self.itemsBottom];
    }
}

- (UIView *)getCardViewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view itemsArray:(NSMutableArray*)items{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130.0f, 230.0f)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        
        [view.layer setCornerRadius:CORNER_RADIUS];
        [view.layer setShadowColor:[UIColor blackColor].CGColor];
        [view.layer setShadowOpacity:0.8];
        [view.layer setShadowOffset:CGSizeMake(-2, -2)];
        
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    label.text = [items[index] stringValue];
    
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 0;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (carousel == carouselTop) {
        return [self getPlaceHolderViewAtIndex:index reusingView:view];
    }
    else{
        return [self getPlaceHolderViewAtIndex:index reusingView:view];
    }
}

- (UIView *)getPlaceHolderViewAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130.0f, 230.0f)];
        [view setBackgroundColor:[UIColor whiteColor]];
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50.0f];
        label.tag = 1;
        [view addSubview:label];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:1];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    
    //label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    if (_carousel == self.carouselTop) {
        //implement 'flip3D' style carousel
        transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
        return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carouselTop.itemWidth);
    }
    else{
        //implement 'flip3D' style carousel
        transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
        return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carouselBottom.itemWidth);
    }
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return wrap;
        }
        case iCarouselOptionArc:
        {
            return 2 * M_PI * 0.119929;
        }
        case iCarouselOptionRadius:
        {
            return value * 1.557364;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            if (_carousel == carouselTop) {
                return 1.052855;
            }
            else
            {
                return value * 0.624498;
            }

        }
        case iCarouselOptionFadeMax:
        {
            if (carouselBottom.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

/*- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if (carousel == carouselTop) {
        NSNumber *item = (self.itemsTop)[index];
        NSLog(@"Tapped view number: %@", item);
        [self moveItemToBottom:index];
    }
    else{
        NSNumber *item = (self.itemsBottom)[index];
        NSLog(@"Tapped view number: %@", item);
        [self moveItemToTop:index];
    }
}*/

- (void)carousel:(iCarousel *)carousel itemMoveWithIndex:(NSInteger)index{
    if (carousel.tag == CAROUSEL_TOP) {
        [self moveItemToBottom:index];
    }
    else{
        [self moveItemToTop:index];
    }
}

@end
