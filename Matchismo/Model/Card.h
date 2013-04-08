//
//  Card.h
//  Matchismo
//
//  Created by Per Kristensen on 12/02/13.
//  Copyright (c) 2013 Per Kristensen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *suit; 
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isFaceUp) BOOL faceUp;
@property (nonatomic, getter=isUnplayable) BOOL unplayable;

- (int)match:(NSArray *)otherCards;
+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end