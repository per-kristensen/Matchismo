//
//  Card.m
//  Matchismo
//
//  Created by Per Kristensen on 12/02/13.
//  Copyright (c) 2013 Per Kristensen. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize suit = _suit;

+ (NSArray *)validSuits {
    return @[@"♥", @"♦", @"♠", @"♣"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [self rankStrings].count-1;
}

- (int)match:(NSArray *)otherCards {
    int score = 0;
    
    if([otherCards count] == 1) {
        Card *otherCard = [otherCards lastObject];
        if([self.suit isEqualToString:otherCard.suit]) {
            score = 3;
        } else if(self.rank == otherCard.rank) {
            score = 4;
        }
    } else if([otherCards count] == 2) {
        Card *card2 = [otherCards objectAtIndex:0];
        Card *card3 = [otherCards lastObject];
        
        if(self.rank == card2.rank || self.rank == card3.rank || card2.rank == card3.rank) {
            if(self.rank == card2.rank && self.rank == card3.rank) {
                score = 6;
            } else {
                score = 2;
            }
        } else if([self.suit isEqualToString:card2.suit] || [self.suit isEqualToString:card3.suit] || [card2.suit isEqualToString:card3.suit]) {
            if([self.suit isEqualToString:card2.suit] && [self.suit isEqualToString:card3.suit]) {
                score = 5;
            } else {
                score = 1;
            }
        }
    }
    
    return score;
}

- (NSString *)contents {
    NSArray *rankStrings = [Card rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit {
    if([[Card validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
    if(rank <= [Card maxRank]) {
        _rank = rank;
    }
}

- (NSString *)description {
    return self.contents;
}

@end


