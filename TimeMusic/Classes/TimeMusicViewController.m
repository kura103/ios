//
//  TimeMusicViewController.m
//  TimeMusic
//
//  Created by 倉富 優 on 11/02/19.
//  Copyright 2011 geo. All rights reserved.
//

#import "TimeMusicViewController.h"

@implementation TimeMusicViewController

@synthesize pickerView;
@synthesize bannerView;

@synthesize mediaItemCollectionTable;
@synthesize delegate;					
@synthesize musicLabel, artistLabel, albumLabel;
@synthesize mediaPickerButton, startButton, stopButton;	
@synthesize bRunning;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//時間用ピッカーの設定
	pickerView.delegate = pickerView;
	pickerView.dataSource = pickerView;
	curMediaItemCollection = nil;
	curDate = nil;
	bRunning = FALSE;
	waitTime = 0;
	pickerView.timeInterval = waitTime;
	[pickerView selectRowWithCurrentTime];
	
	startButton.hidden = YES;
	stopButton.hidden = YES;
	
	player = [MPMusicPlayerController applicationMusicPlayer];
	player.repeatMode = MPMusicRepeatModeAll;
	player.shuffleMode = MPMusicShuffleModeOff;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	curMediaItemCollection = nil;
	musicLabel.text = @"";
	artistLabel.text = @"";
	albumLabel.text = @"";
	startButton.hidden = YES;
	stopButton.hidden = YES;	
	curDate = nil;
	bRunning = FALSE;
	waitTime = 0;
	pickerView.timeInterval = waitTime;
	[pickerView selectRowWithCurrentTime];
}

- (void)dealloc 
{
    [super dealloc];
}


- (void) Timer
{
	if ( TRUE == bRunning ){
		NSDate* now = [NSDate date];
		NSTimeInterval diffTime = waitTime - [now timeIntervalSinceDate:curDate];

		if ( 0 >= diffTime ) {
			[self Play];
			pickerView.userInteractionEnabled = YES;
			bRunning = FALSE;
			diffTime = 0;
		}
		pickerView.timeInterval = diffTime;
		[pickerView selectRowWithCurrentTime];
	}
}

- (void) Start
{
	if ( FALSE == bRunning ){
		bool play = player.playbackState != MPMusicPlaybackStatePlaying;
		if (!play ) {
			[player pause];
		}
		
		waitTime = pickerView.timeInterval;
		pickerView.userInteractionEnabled = NO;
		curDate = [NSDate date];
		[curDate retain];
		bRunning = TRUE;
	}
}

- (void) Stop
{	
	
	bool play = player.playbackState != MPMusicPlaybackStatePlaying;
    if (!play ) {
		[player pause];
	}

	if ( TRUE == bRunning ){
		NSDate* now = [NSDate date];
		NSTimeInterval diffTime = waitTime - [now timeIntervalSinceDate:curDate];
		pickerView.timeInterval = diffTime;
		[pickerView selectRowWithCurrentTime];
		pickerView.userInteractionEnabled = YES;
		bRunning = FALSE;
	}
}

- (void) Play{
	if ( curMediaItemCollection && 0 < [curMediaItemCollection count]) {
		[player play];
	}
} 

- (void) onTimer: (NSTimer *) timer{
	[self Timer];
}

- (IBAction) startDown:(id) sender{
	[self Start];
}

- (IBAction) stopDown:(id) sender{
	[self Stop];
}

// Configures and displays the media item picker.
- (IBAction) showMediaPicker: (id) sender {
	
	MPMediaPickerController *picker =
	[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
	
	picker.delegate						= self;
	picker.allowsPickingMultipleItems	= NO;
	picker.prompt						= @"Select Music";
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];
	
	[self presentModalViewController: picker animated: YES];
	[picker release];
}


//音を選択したら実行される。
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker
  didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[self dismissModalViewControllerAnimated:YES];
	
	bool play = player.playbackState == MPMusicPlaybackStatePlaying;
	bool pause = player.playbackState == MPMusicPlaybackStatePaused;
    if ( play || pause) {
		[player stop];
	}
	
	[player setQueueWithItemCollection:mediaItemCollection];
	
	curMediaItemCollection = mediaItemCollection;
    for( MPMediaItem* item in mediaItemCollection.items ) {
		musicLabel.text = [item valueForProperty:MPMediaItemPropertyTitle];
		artistLabel.text = [item valueForProperty:MPMediaItemPropertyArtist];
		albumLabel.text = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
	}
	
	startButton.hidden = NO;
	stopButton.hidden = NO;	
}

//キャンセルしたら実行される
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
	[self dismissModalViewControllerAnimated:YES];
}

@end
