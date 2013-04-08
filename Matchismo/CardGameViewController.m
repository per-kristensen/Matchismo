//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Per Kristensen on 12/02/13.
//  Copyright (c) 2013 Per Kristensen. All rights reserved.
//

#import "CardGameViewController.h"
#import "Card.h"
#import "CardMatchingGame.h"
#import "CardGameHistory.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeButton;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) NSMutableArray *gameHistories;
@end

@implementation CardGameViewController

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
    [self updateHistory];
}

- (CardMatchingGame *)game {
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[[Deck alloc] init]
                                                      withGameType:self.gameTypeButton.selectedSegmentIndex];
    return _game;
}

- (IBAction)flipCard:(UIButton *)sender {
    self.gameTypeButton.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    [self updateHistory];
}

- (IBAction)redeal:(UIButton *)sender {
    self.game = nil;
    self.gameHistories = nil;
    self.gameTypeButton.enabled = YES;
    self.flipCount = 0;
    self.historySlider.minimumValue = 0;
    self.historySlider.maximumValue = 0;
    [self.historySlider setValue:0];
    [self updateUI];
    [self updateHistory];
}

- (IBAction)changeGameType:(UISegmentedControl *)sender {
    self.game = nil;
}

- (void)updateUI {
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        if (!card.isFaceUp) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.statusLabel.text = [NSString stringWithFormat:@"%@", self.game.status];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    
    if([self.game numberOfPlayableCards] < [self.gameTypeButton selectedSegmentIndex]+2) {
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"All out of cards!"
                                                          message:nil
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:@"Deal again!", nil];
        
        [myAlert show];
    }
}

- (NSMutableArray*)gameHistories {
    if (!_gameHistories) _gameHistories = [[NSMutableArray alloc] init];
    
    return _gameHistories;
}

- (void)updateHistory {
    CardGameHistory *history = [[CardGameHistory alloc] init];
    history.statusLabelText = [NSString stringWithFormat:@"%@", self.game.status];
    history.scoreLabelText = [NSString stringWithFormat:@"Score: %d", self.game.score];
    history.flipsLabelText = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        Card *newCard = [[Card alloc] init];
        newCard.faceUp = card.isFaceUp;
        newCard.unplayable = card.isUnplayable;
        newCard.rank = card.rank;
        newCard.suit = card.suit;
        
        [history addCard:newCard];
    }
    [self.gameHistories addObject:history];
    self.historySlider.minimumValue = 1;
    self.historySlider.maximumValue = [self.gameHistories count];
    [self.historySlider setValue:[self.gameHistories count]];
}

- (IBAction)showGameHistory:(UISlider *)sender {
    int value = lroundf(sender.value);
    [sender setValue:value animated:YES];
    
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
    
    if (value == [self.gameHistories count]) {
        [self updateUI];
    } else {
        CardGameHistory *history = [self.gameHistories objectAtIndex:value-1];
        
        for (UIButton *cardButton in self.cardButtons) {
            Card *card = [history cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
            [cardButton setTitle:card.contents forState:UIControlStateSelected];
            [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
            cardButton.selected = card.isFaceUp;
            cardButton.enabled = NO;
            cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
            if (!card.isFaceUp) {
                [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            } else {
                [cardButton setImage:nil forState:UIControlStateNormal];
            }
            cardButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        }
        
        self.scoreLabel.text = history.scoreLabelText;
        self.statusLabel.text = history.statusLabelText;
        self.flipsLabel.text = history.flipsLabelText;
    }
}

@end