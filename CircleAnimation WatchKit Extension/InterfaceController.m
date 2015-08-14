//
//  InterfaceController.m
//  CircleAnimation WatchKit Extension
//
//  Created by Susannah Meyer on 8/13/15.
//  Copyright © 2015 Susannah Meyer. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchKit/WatchKit.h>
#import <UIKit/UIKit.h>


const CGPoint circleCenter = {100,100};
const float radius = 90.0;
const float lineWidth = 14.0;

@interface InterfaceController()

@property (nonatomic, retain) IBOutlet WKInterfaceImage *image;
@property (nonatomic, retain) IBOutlet WKInterfaceGroup *imageGroup;
@property (nonatomic, retain) WKInterfaceDevice *currentDevice;
@property (nonatomic, retain) NSMutableArray * images;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    
    [super awakeWithContext:context];
    self.images = [NSMutableArray array];
    [self animateCircleWithGreenPercentage:30 redPercentage:60 grayPercentage:0];
    
    self.currentDevice = [WKInterfaceDevice currentDevice];
}



- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)animateCircleWithGreenPercentage:(double)greenPercentage
                           redPercentage:(double)redPercentage
                          grayPercentage:(double)grayPercentage {
    
    for (int i=0; i<greenPercentage; i++) {
       [self.images addObject:[self drawCircleWithGreenPercentage:i redPercentage:0 grayPercentage:100-i]];
       // [self drawCircleWithGreenPercentage:i redPercentage:0 grayPercentage:100-i];
    }
    for (int i=0; i<=redPercentage; i++) {
         [self.images addObject:[self drawCircleWithGreenPercentage:greenPercentage redPercentage:i grayPercentage:100-(greenPercentage+i)]];
        //[self drawCircleWithGreenPercentage:greenPercentage redPercentage:i grayPercentage:100-(greenPercentage+i)];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //[self.image setImage:[self.images objectAtIndex:0]];
        // [[WKInterfaceDevice currentDevice] addCachedImage:[self.images objectAtIndex:0] name:@"image1"];
        
        
        for (int i=0; i<[self.images count]-1; i++) {
            
            
            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            
            [UIImagePNGRepresentation([self.images objectAtIndex:i]) writeToFile:[NSString stringWithFormat:@"%@/asd%d@2x.png",[self applicationDocumentsDirectory],i] atomically:YES];

        }
        
        [self.image setImageNamed:[NSString stringWithFormat:@"asd%d@2x.png",2]];
        [self.image startAnimatingWithImagesInRange:NSMakeRange(0,self.images.count-1) duration:1 repeatCount:0];
        
    });
}


- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (UIImage *) drawCircleWithGreenPercentage:(double)greenPercentage
                             redPercentage:(double)redPercentage
                            grayPercentage:(double)grayPercentage{
    
#define DEGREE(angle) ((angle) / 180.0 * M_PI)
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
    
    CGSize size = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(currentContext, YES);
    
    double greenStart = 270.0;
    double greenEnd = greenStart + (360/(100/greenPercentage));
    
    [[UIColor colorWithRed:35.0/255.0 green:197.0/255.0 blue:127.0/255.0 alpha:1.0] setStroke];
    UIBezierPath *greenPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:DEGREE(greenStart) endAngle:DEGREE(greenEnd) clockwise:YES];
    [greenPath setLineWidth:lineWidth];
    [greenPath stroke];
    
    double redStart = greenEnd;
    double redEnd = redStart + (360/(100/redPercentage));
    
    [[UIColor colorWithRed:251.0/255.0 green:40.0/255.0 blue:48.0/255.0 alpha:1.0] setStroke];
    UIBezierPath *redPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:DEGREE(redStart) endAngle:DEGREE(redEnd) clockwise:YES];
    [redPath setLineWidth:lineWidth];
    [redPath stroke];
    
    double grayStart = redEnd;
    double grayEnd = grayStart + (360 - fabs(greenStart - redEnd));
    
    [[UIColor colorWithRed:60.0/255.0 green:60.0/255.0 blue:60.0/255.0 alpha:1.0] setStroke];
    UIBezierPath *grayPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:radius startAngle:DEGREE(grayStart) endAngle:DEGREE(grayEnd) clockwise:YES];
    [grayPath setLineWidth:lineWidth];
    [grayPath stroke];
    
    UIImage *image =  [UIImage imageWithCGImage:CGBitmapContextCreateImage(currentContext)];
    UIGraphicsEndImageContext();
    return image;
    //[_image setImage:image];

    
}
@end