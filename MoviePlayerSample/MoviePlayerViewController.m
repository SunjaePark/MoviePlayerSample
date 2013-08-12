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
    
    [self prepareMoviePlayer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Movie Player Controller

- (void)prepareMoviePlayer
{
    self.moviePlayerController = [MPMoviePlayerController new];
    if (![self.moviePlayerContainerView.subviews containsObject:self.moviePlayerController.view]) {
        self.moviePlayerController.view.frame = self.moviePlayerContainerView.bounds;
        [self.moviePlayerContainerView addSubview:self.moviePlayerController.view];
    }
}

// Local
- (NSURL *)movieUrl
{
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    if (moviePath)
        return [NSURL fileURLWithPath:moviePath];
    
    return nil;
}

// Streaming
- (NSURL *)streamingUrl
{
    if (self.movieUrlField.text.length > 0)
		return [NSURL URLWithString:self.movieUrlField.text];
    
    return nil;
}

-(void)playMovieStream:(NSURL *)movieFileURL
{
    MPMovieSourceType movieSourceType = MPMovieSourceTypeUnknown;
    
    if ([movieFileURL.pathExtension compare:@"m3u8" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        movieSourceType = MPMovieSourceTypeStreaming;
    else if ([movieFileURL.pathExtension compare:@"m4v" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        movieSourceType = MPMovieSourceTypeFile;
    
    [self createAndPlayMovieForURL:movieFileURL sourceType:movieSourceType];
}

-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    [self configurePlayerWithURL:movieURL sourceType:sourceType];
    
    /* Apply the user movie preference settings to the movie player object. */
    [self applyUserSettingsToMoviePlayer];
    
    /* Play the movie! */
    [self.moviePlayerController play];
}

- (void)configurePlayerWithURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    /* Specify the URL that points to the movie file. */
    self.moviePlayerController.contentURL = movieURL;
    
    /* If you specify the movie type before playing the movie it can result
     in faster load times. */
    self.moviePlayerController.movieSourceType = sourceType;
}

-(void)applyUserSettingsToMoviePlayer
{
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayerController.controlStyle = MPMovieControlModeVolumeOnly;
    self.moviePlayerController.repeatMode = MPMovieRepeatModeNone;
    
    self.moviePlayerController.backgroundView.backgroundColor = [UIColor lightGrayColor];
    
    /* Indicate the movie player allows AirPlay movie playback. */
    self.moviePlayerController.allowsAirPlay = YES;
    
    [self.moviePlayerController prepareToPlay];
}

- (IBAction)playButtonTouched:(UIButton *)sender {
    NSURL *theMovieURL = [self streamingUrl];   //  [self movieUrl];
    if (theMovieURL)
    {
        if ([theMovieURL scheme])	// sanity check on the URL
            [self playMovieStream:theMovieURL];
    }
}

@end
