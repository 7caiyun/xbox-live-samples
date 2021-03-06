// Copyright (c) Microsoft Corporation
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

#import "HubMenuView.h"
#import <HubMenu_Integration.h>
#import "AchievementsMenuView.h"

@interface HubMenuView() {}

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIButton *achievementButton;

@property (strong) AchievementsMenuView *achievementsMenuView;

@end

@implementation HubMenuView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [[NSBundle mainBundle] loadNibNamed:@"HubMenuView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    
    self.achievementButton.layer.borderWidth = 1.0f;
    self.achievementButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.achievementButton.layer.cornerRadius = 10.0f;
    
    HubMenu_Integration::getInstance()->hubMenuInstance = (void *)CFBridgingRetain(self);
}

- (void)updateMenuHidden:(BOOL)hidden {
    if (hidden && self.achievementsMenuView) {
        [self.achievementsMenuView backToMain];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = hidden;
    });
}

- (IBAction) achievementsButtonTapped {
    SampleLog(LL_TRACE, "Hub menu Achievements tapped.");
    
    if (!self.achievementsMenuView) {
        self.achievementsMenuView = [[AchievementsMenuView alloc] initWithFrame:self.bounds];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.achievementsMenuView reset];
        [self addSubview:self.achievementsMenuView];
    });
}

@end
