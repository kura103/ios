//
//  TimeMusicViewController.h
//  TimeMusic
//
//  Created by 倉富 優 on 11/02/19.
//  Copyright 2011 geo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import <iAd/iAd.h>

#import "Util/TimePickerView.h"

@protocol MusicTableViewControllerDelegate; // forward declaration
@protocol ADBannerViewDelegate; // forward declaration

@interface TimeMusicViewController : UIViewController< MPMediaPickerControllerDelegate, ADBannerViewDelegate> {	
	MPMediaItemCollection* curMediaItemCollection;
	MPMusicPlayerController* player;
	NSDate	*curDate;
	NSTimeInterval waitTime;
	BOOL bRunning;
	
	id <MusicTableViewControllerDelegate>	delegate;
	IBOutlet UITableView	*mediaItemCollectionTable;
	IBOutlet UILabel		*musicLabel;
	IBOutlet UILabel		*artistLabel;
	IBOutlet UILabel		*albumLabel;
	IBOutlet UIButton		*mediaPickerButton;
	IBOutlet UIButton		*startButton;
	IBOutlet UIButton		*stopButton;
	IBOutlet TimePickerView *pickerView;
}

@property (nonatomic, assign) id <MusicTableViewControllerDelegate>	delegate;
@property (nonatomic, retain) ADBannerView		*bannerView;
@property (nonatomic, retain) UITableView		*mediaItemCollectionTable;
@property (nonatomic, retain) UILabel			*musicLabel;
@property (nonatomic, retain) UILabel			*artistLabel;
@property (nonatomic, retain) UILabel			*albumLabel;
@property (nonatomic, retain) UIButton			*mediaPickerButton;
@property (nonatomic, retain) UIButton			*startButton;
@property (nonatomic, retain) UIButton			*stopButton;
@property (nonatomic, retain) TimePickerView	*pickerView;

@property(nonatomic,readonly) BOOL bRunning;
- (void) Timer;
- (void) Start;
- (void) Stop;
- (void) Play;

- (void) onTimer: (NSTimer*) timer;
- (IBAction) showMediaPicker: (id) sender;

- (IBAction) startDown:(id) sender;
- (IBAction) stopDown:(id) sender;
@end



@protocol MusicTableViewControllerDelegate

// implemented in MainViewController.m
- (void) musicTableViewControllerDidFinish: (TimeMusicViewController *) controller;
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;

@end

