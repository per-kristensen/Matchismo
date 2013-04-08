//
//  CardGameHistory.h
//  Matchismo
//
//  Created by Per Kristensen on 18/02/13.
//  Copyright (c) 2013 Per Kristensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface CardGameHistory : NSObject

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSString *scoreLabelText;
@property (strong, nonatomic) NSString *statusLabelText;
@property (strong, nonatomic) NSString *flipsLabelText;

- (void)addCard:(Card *)card;
- (Card *)cardAtIndex:(NSUInteger)index;

@end
