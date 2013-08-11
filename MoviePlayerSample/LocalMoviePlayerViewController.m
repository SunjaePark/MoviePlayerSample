//
//  ViewController.m
//  MoviePlayerSample
//
//  Created by Heaven on 13. 8. 11..
//  Copyright (c) 2013년 Heaven. All rights reserved.
//

#import "LocalMoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LocalMoviePlayerViewController ()

@property (strong, nonatomic) NSURL *movieUrl;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayerController;

@property (weak, nonatomic) IBOutlet UIView *playerContainerView;

@end

@implementation LocalMoviePlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.movieUrl];
    
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
    [self.moviePlayerController prepareToPlay];
    
    self.moviePlayerController.view.frame = self.playerContainerView.frame;
    [self.playerContainerView addSubview:self.moviePlayerController.view];
    
    [self.moviePlayerController play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSURL *)movieUrl
{
    if (!_movieUrl) {
        NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
		if (moviePath)
			_movieUrl = [NSURL fileURLWithPath:moviePath];
    }
    
    return _movieUrl;
}

@end
