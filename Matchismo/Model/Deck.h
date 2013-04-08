//
//  Deck.h
//  Matchismo
//
//  Created by Per Kristensen on 12/02/13.
//  Copyright (c) 2013 Per Kristensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard;

@end
