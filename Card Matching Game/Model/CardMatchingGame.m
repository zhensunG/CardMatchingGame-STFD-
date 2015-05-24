//
//  CardMatchingGame.m
//  Card Matching Game
//
//  Created by Kiba on 5/21/15.
//  Copyright (c) 2015 Kiba Zhen Sun. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;    // of Card

@end

@implementation CardMatchingGame

-(NSMutableArray *) cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSUInteger) maxMatchingCards
{
    if (_maxMatchingCards < 2) _maxMatchingCards = 2;
    return _maxMatchingCards;
}

-(instancetype) initWithCardCount: (NSUInteger)count
                        usingDeck: (Deck *)deck
{
    self = [super init];
    
    if (self)
    {
        for (int i = 0; i < count; i++)
        {
            Card *card = [deck drawRandomCard];
            if (card)
            {
                [self.cards addObject: card];
            }
            else
            {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}


static const int MATCH_BONUS = 4;
static const int MISMATCH_PENALTY = 2;
static const int COST_TO_CHOOSE = 1;

-(Card *) cardAtIndex: (NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

-(void) chooseCardAtIndex: (NSUInteger)index
{
    Card *card = [self cardAtIndex: index];
    
    if (!card.isMatched)
    {
        if (card.isChosen)
        {
            card.chosen = NO;
        }
        else
        {
            NSMutableArray *otherCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards)
            {
                if (otherCard.isChosen && !otherCard.isMatched)
                {
                    [otherCards addObject: otherCard];
                }
            }

            if ([otherCards count] + 1 == self.maxMatchingCards)
            {
                int matchScore = [card match: otherCards];
                
                if (matchScore)
                {
                    self.score += matchScore * MATCH_BONUS;
                    card.matched = YES;
                    for (Card *otherCard in otherCards)
                    {
                        otherCard.matched = YES;
                    }
                }
                else
                {
                    self.score -= MISMATCH_PENALTY;
                    for (Card *otherCard in otherCards)
                    {
                        otherCard.chosen = NO;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end