//
//  AttributeViewController.m
//  AttributeMD
//
//  Created by Michael Davidovich on 4/16/13.
//  Copyright (c) 2013 Michael Davidovich. All rights reserved.
//

#import "AttributeViewController.h"

@interface AttributeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIStepper *selectedWordStepper;
@property (weak, nonatomic) IBOutlet UILabel *selectedWordLabel;

@end

@implementation AttributeViewController

// method that will take attributes to be applied and range as input to apply them to the label
-(void)addLabelAttributes:(NSDictionary *)attributes range:(NSRange)range
{
    // if the string is found
    if (range.location != NSNotFound) {
        //make a mutable copy of the string (selected word) for modification
        NSMutableAttributedString *mat = [self.label.attributedText mutableCopy];
        // add atributes to the copy
        [mat addAttributes:attributes range:range];
        //set it back
        self.label.attributedText = mat;
    }
    
}

// method to build out what attributes to apply to selected text. takes a dictionary of an attribute
-(void)addSelectedWordAttributes:(NSDictionary *)attributes
{
    NSRange range = [[self.label.attributedText string] rangeOfString:[self selectedWord]];
    [self addLabelAttributes:attributes range:range];
}


// action builds a dictionary of the underline attribute
- (IBAction)underline
{
    [self addSelectedWordAttributes:@{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
}


// action builds a dictionary of the unUnderline attribute
- (IBAction)unundeLine
{
    [self addSelectedWordAttributes:@{ NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)}];
}


// method that changes colors
// takes the button as an input and sets the color fo the text to be the background color of the button that called it. works for all 4 color bottons on the storyboard
- (IBAction)changeColor:(UIButton *)sender
{
    [self addSelectedWordAttributes:@{ NSForegroundColorAttributeName: sender.backgroundColor}];
}


// method that changes font (bold, normal, italic
// works similar to method that changes the font color above
// however, font has size with it, so not to distort the font size of the word in the main label
// this method first asks the current label what is it's font size, stores it and then sets it back
- (IBAction)changeFont:(UIButton *)sender
{
    // create a variable that will store information about existing font
    // and initialize it to system font so it always have some data in it
    CGFloat fontSize = [UIFont systemFontSize];
    
    // build a dictionary of current size attribute by looking at the first charachter of the label
    // this is cheating since the label could have differnet fonts sizes for different words
    NSDictionary *attributes = [self.label.attributedText attributesAtIndex:0 effectiveRange:NULL];
    
    //store information about existing font in a dictionary
    UIFont *existingFont = attributes[NSFontAttributeName];
    
    // if font is found, store font size in the fontsize variable
    if (existingFont) fontSize = existingFont.pointSize;
    
    //build a new dictionary and set it back
    UIFont *font = [sender.titleLabel.font fontWithSize:fontSize];
    [self addSelectedWordAttributes:@{ NSFontAttributeName : font}];
    
    
}

// action to put outline around the selected word
- (IBAction)outLine
{
    [self addSelectedWordAttributes:@{NSStrokeWidthAttributeName : @2}];
}


- (IBAction)unoutLine
{
    [self addSelectedWordAttributes:@{NSStrokeWidthAttributeName : @-0}];
}


//get all text from main label that contains attributed text and put it into an array of strings
- (NSArray *) wordList
{
// this code grabs all text from label.attributedText and creates an array of all strings separated by charachter set whitespace and New Line
    NSArray *wordlist = [[self.label.attributedText string] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
// check wordlist array, if ok return it, if array is blank return an array that has empty string it in
    
    if ([wordlist count]) {
        return wordlist;
    } else {
        return @[@""];
    }
}


// find out which word is selected.
- (NSString *)selectedWord
{
    
//return a word out of wordlist array located at the index of the stepper value. index is an int because stepper is stepping by value of 1. 
    return [self wordList][(int)self.selectedWordStepper.value];
}


//action method of the stepper
- (IBAction)updateSelectedWord
{
//  set the steppers maximum value to the number of words in the main label to make sure that stepper does not stepp out of bounds of the array
    self.selectedWordStepper.maximumValue = [[self wordList]count]-1;
    
// update selected word label
    self.selectedWordLabel.text = [self selectedWord];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
// update selected word label to first value of the stepper when application first loads. stepper starts at value 0
    [self updateSelectedWord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
