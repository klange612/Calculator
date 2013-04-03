//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Kelley Lange on 3/27/13.
//  Copyright (c) 2013 Kurt Lange. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic)   BOOL    userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong)   CalculatorBrain *brain;
@property (nonatomic)   BOOL      decimalPoint;
@property (nonatomic)   BOOL    debug;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize miniDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize decimalPoint;
@synthesize debug;

-(CalculatorBrain *)brain
{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)flipSignButton
{
    if ([self.display.text hasPrefix:@"-"])
    {
        self.display.text = [self.display.text substringFromIndex:1];
        self.miniDisplay.text = [self.miniDisplay.text substringFromIndex:1];
    }
    else {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
        self.miniDisplay.text = [@"-" stringByAppendingString:self.miniDisplay.text];
    }
}

- (IBAction)decimalPointButton
{
    if (!decimalPoint) {
        self.display.text = [self.display.text stringByAppendingFormat:@"."];
        self.miniDisplay.text = [self.miniDisplay.text stringByAppendingFormat:@"."];
        decimalPoint = YES;
    }
}

- (IBAction)clearButton
{
    self.display.text = @"0";
    self.miniDisplay.text = @"0";
    userIsInTheMiddleOfEnteringANumber = NO;
    [_brain clear];
    decimalPoint = NO;
}

- (IBAction)backspaceButton
{
    if (userIsInTheMiddleOfEnteringANumber  && [self.display.text length]) {
    NSLog(@"self.display.text length: %i", [self.display.text length]);
        self.display.text = [self.display.text substringToIndex:([self.display.text length]-1)];
        self.miniDisplay.text = [self.miniDisplay.text substringToIndex:[self.miniDisplay.text length]-1];
    }
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    // NSLog(@"Digit pressed: %@", digit);
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.miniDisplay.text = [self.miniDisplay.text stringByAppendingString:digit];
    }
    else {
        self.display.text = digit;
        self.miniDisplay.text = digit;
        userIsInTheMiddleOfEnteringANumber = YES;
    }
}	

- (IBAction)operationPressed:(id)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    NSLog(@"oper1 pressed: %@", operation);
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    decimalPoint = NO;
}

@end
