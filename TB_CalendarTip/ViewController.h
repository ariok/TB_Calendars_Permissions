//
//  ViewController.h
//  TB_CalendarTip
//
//  Created by Yari D'areglia on 11/2/12.
//  Copyright (c) 2012 Yari D'areglia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface ViewController : UIViewController
- (IBAction)AddEvent:(id)sender;
- (BOOL)createEvent:(EKEventStore*)eventStore;
@end
