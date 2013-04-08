//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Per Kristensen on 13/02/13.
//  Copyright (c) 2013 Per Kristensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *status;

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
           withGameType:(int)gameType;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (int)numberOfPlayableCards;

@end