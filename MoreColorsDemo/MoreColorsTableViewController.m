//
//  MoreColorsTableViewController.m
//  MoreColorsDemo
//
//  Created by Matt Glover on 01/01/2013.
//  Copyright (c) 2013 Duchy Software. All rights reserved.
//

#import "MoreColorsTableViewController.h"

#define COLOR_NAME_KEY @"colorName"
#define COLOR_KEY      @"color"

@interface MoreColorsTableViewController ()
@property (nonatomic, strong) NSArray *moreColorInfos;

- (NSArray *)extractColorNames;
- (void)initMoreColors:(NSArray *)colorNames;
@end

@implementation MoreColorsTableViewController
@synthesize moreColorInfos = _moreColorInfos;

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self setTitle:@"More Colors"];
  
  NSArray *colorNames = [self extractColorNames];
  [self initMoreColors:colorNames];
}

#pragma mark - ViewDidLoad Helper Methods
- (NSArray *)extractColorNames {
  
  NSMutableArray *colors = [NSMutableArray array];
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"UIColor+MoreColors" ofType:@"txt"];
  NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
  NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
  
  for (NSString* line in lines) {
    if (line.length) {
      
      NSString *colorName = [line stringByReplacingOccurrencesOfString:@"+ (id)" withString:@""];
      colorName = [colorName stringByReplacingOccurrencesOfString:@";" withString:@""];
      [colors addObject:colorName];
    }
  }
  
  return colors;
}

- (void)initMoreColors:(NSArray *)colorNames {
  
  NSMutableArray *mutableColorsArray = [NSMutableArray array];
  
  for (NSString *colorName in colorNames) {
    
    SEL colorNameSelector = NSSelectorFromString(colorName);
    
    if ([UIColor respondsToSelector:colorNameSelector]) {
      UIColor *color = [UIColor performSelector:colorNameSelector];
      NSDictionary *colorInfo = @{COLOR_NAME_KEY : colorName, COLOR_KEY : color};
      [mutableColorsArray addObject:colorInfo];
    }
  }
  
  self.moreColorInfos = mutableColorsArray;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Autorotate for <iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.moreColorInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	}
  
  NSDictionary *colorInfo = [self.moreColorInfos objectAtIndex:indexPath.row];
  
  [cell.contentView setBackgroundColor:[colorInfo objectForKey:COLOR_KEY]];
  
  [cell.textLabel setText:[colorInfo objectForKey:COLOR_NAME_KEY]];
  [cell.textLabel setBackgroundColor:[colorInfo objectForKey:COLOR_KEY]];
  return cell;
}

#pragma mark - Table View Delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
