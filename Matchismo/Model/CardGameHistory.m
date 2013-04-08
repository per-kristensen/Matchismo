//
//  CardGameHistory.m
//  Matchismo
//
//  Created by Per Kristensen on 18/02/13.
//  Copyright (c) 2013 Per Kristensen. All rights reserved.
//

#import "CardGameHistory.h"

@implementation CardGameHistory

- (NSMutableArray*)cards {
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)addCard:(Card *)card {
    [self.cards addObject:card];
}


@end
