//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"
#include "math.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic) BOOL debug;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize debug;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

-(void)clear
{
    self.programStack = nil;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;

    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        NSLog(@"operation: %@", operation);
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
                     [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
                     [self popOperandOffProgramStack:stack];
        } else if ([@"∏" isEqualToString:operation]) {
            result = ([self popOperandOffProgramStack:stack] *
            3.14);
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sinf([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"cos"]) {
            result = cosf([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrtf([self popOperandOffProgramStack:stack]);
        }
        else if ([operation isEqualToString:@"log"]) {
            result = log10([self popOperandOffProgramStack:stack]);
        }
    }

    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

@end
