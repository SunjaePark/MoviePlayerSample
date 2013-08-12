//
//  MoviePlayerViewController.m
//  MoviePlayerSample
//
//  Created by Heaven on 13. 8. 12..
//  Copyright (c) 2013년 Heaven. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayerViewController ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;

@property (weak, nonatomic) IBOutlet UITextField *movieUrlField;
@property (weak, nonatomic) IBOutlet UIView *moviePlayerContainerView;

@end

@implementation MoviePlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.movieUrlField.text = @"http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8";
    
    self.moviePlayerController = [MPMoviePlayerController new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Movie Player Controller
-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    [self createAndConfigurePlayerWithURL:movieURL sourceType:sourceType];
    
    /* Play the movie! */
    [self.moviePlayerController play];
}

-(void)createAndConfigurePlayerWithURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    /* Specify the URL that points to the movie file. */
    self.moviePlayerController.contentURL = movieURL;
    
    /* If you specify the movie type before playing the movie it can result
     in faster load times. */
    self.moviePlayerController.movieSourceType = sourceType;
    
    /* Apply the user movie preference settings to the movie player object. */
    [self applyUserSettingsToMoviePlayer];
}

-(void)applyUserSettingsToMoviePlayer
{
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayerController.controlStyle = MPMovieControlModeVolumeOnly;
    self.moviePlayerController.repeatMode = MPMovieRepeatModeNone;
    
    self.moviePlayerController.backgroundView.backgroundColor = [UIColor lightGrayColor];
    
    if (![self.moviePlayerContainerView.subviews containsObject:self.moviePlayerController.view]) {
        self.moviePlayerController.view.frame = self.moviePlayerContainerView.bounds;
        [self.moviePlayerContainerView addSubview:self.moviePlayerController.view];
    }
    
    /* Indicate the movie player allows AirPlay movie playback. */
    self.moviePlayerController.allowsAirPlay = YES;
    
    [self.moviePlayerController prepareToPlay];
}

-(void)playMovieStream:(NSURL *)movieFileURL
{
    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
    
    if ([movieFileURL.pathExtension compare:@"m3u8" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        movieSourceType = MPMovieSourceTypeStreaming;
    
    [self createAndPlayMovieForURL:movieFileURL sourceType:movieSourceType];
}

- (NSURL *)movieUrl
{
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    if (moviePath)
        return [NSURL fileURLWithPath:moviePath];
    
    return nil;
}

- (IBAction)playButtonTouched:(UIButton *)sender {
	if (self.movieUrlField.text.length > 0)
	{
		NSURL *theMovieURL = [NSURL URLWithString:self.movieUrlField.text];
		if (theMovieURL)
		{
			if ([theMovieURL scheme])	// sanity check on the URL
                [self playMovieStream:theMovieURL];
		}
	}    
}

@end
