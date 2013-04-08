//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Per Kristensen on 13/02/13.
//  Copyright (c) 2013 Per Kristensen. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) NSString *status;
@property (readwrite, nonatomic) NSMutableArray *cards; // of Card
@property (nonatomic) int gameType;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSString *)status {
    if(!_status) _status = @"New game - pick a card";
    return _status;
}

- (int)numberOfPlayableCards {
    int playableCards = 0;
    for (Card *card in self.cards) {
        if(!card.isUnplayable) {
            playableCards++;
        }
    }
    return playableCards;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if(card && !card.isUnplayable) {
        if(!card.isFaceUp) {
            self.status = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            for(Card *otherCard in self.cards) {
                if(otherCard.isFaceUp && !otherCard.isUnplayable) {
                    if(self.gameType == 0) {
                        int matchScore = [card match:@[otherCard]];
                        if(matchScore) {
                            card.unplayable = YES;
                            otherCard.unplayable = YES;
                            int bonus = matchScore * MATCH_BONUS;
                            self.score += bonus;
                            self.status = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", card.contents, otherCard.contents, bonus];
                        } else {
                            self.status = [NSString stringWithFormat:@"%@ and %@ don't match! 2 point penalty!", card.contents, otherCard.contents];
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                        }
                        break;
                    } else if (self.gameType == 1) {
                        [otherCards addObject:otherCard];
                        if ([otherCards count] == 2) {
                            int matchScore = [card match:otherCards];
                            if (matchScore) {
                                card.unplayable = YES;
                                for(Card *tmpCard in otherCards) {
                                    tmpCard.unplayable = YES;
                                }
                                int bonus = matchScore * MATCH_BONUS;
                                self.score += bonus;
                                self.status = [NSString stringWithFormat:@"Matched %@ & %@ for %d points", [otherCards componentsJoinedByString:@", "], card.contents, bonus];
                            } else {
                                self.status = [NSString stringWithFormat:@"%@ and %@ don't match! 2 point penalty!", [otherCards componentsJoinedByString:@", "], card.contents];
                                for(Card *tmpCard in otherCards) {
                                    tmpCard.faceUp = NO;
                                }
                                self.score -= MISMATCH_PENALTY;
                            }
                            break;
                        }
                    }
                }
            }
            self.score -= FLIP_COST;
        } else {
            self.status = @"Pick a card";
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
           withGameType:(int)gameType {
    
    self = [super init];
    
    if(self) {
        for(int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            
            if(card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
        self.gameType = gameType;
    }
    
    return self;
}

@end
