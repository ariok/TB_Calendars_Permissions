//
//  ViewController.m
//  TB_CalendarTip
//
//  Created by Yari D'areglia on 11/2/12.
//  Copyright (c) 2012 Yari D'areglia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddEvent:(id)sender {
    
    //Create the Event Store
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    
    //Check if iOS6 or later is installed on user's device *******************
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        
        //Request the access to the Calendar
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted,NSError* error){
           
            //Access not granted-------------
            if(!granted){
                NSString *message = @"Hey! I Can't access your Calendar... check your privacy settings to let me in!";
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                   message:message
                                                                  delegate:self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil,nil];
                //Show an alert message!
                //UIKit needs every change to be done in the main queue
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertView show];
                }
            );
                
            //Access granted------------------
            }else{

                //Create the event and set the Label message
                NSString *labelText;
                
                //Event created 
                if([self createEvent:eventStore]){
                    labelText = @"Event added!";
                    
                //Error occured
                }else{
                    labelText = @"Something goes wrong";
                }
                
                //Add the Label to the controller view
                dispatch_async(dispatch_get_main_queue(), ^{
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/1.5, 320, 30)];
                    [label setText:labelText];
                    [label setTextAlignment:NSTextAlignmentCenter];
                    
                    [self.view addSubview:label];
                });
            }
        }];
    }
    
    //Device prior to iOS 6.0  *********************************************
    else{
        [self createEvent:eventStore];
    }
}

//Event creation 
-(BOOL)createEvent:(EKEventStore*)eventStore{
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.title = @"A new super event!";
    event.startDate = [NSDate date];
    event.endDate = [event.startDate dateByAddingTimeInterval:3600];
    event.calendar = [eventStore defaultCalendarForNewEvents];
    
    NSError *error;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
    
    if (error) {
        NSLog(@"Event Store Error: %@",[error localizedDescription]);
        return NO;
    }else{
        return YES;
    }
}

@end
