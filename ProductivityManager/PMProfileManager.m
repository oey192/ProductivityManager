//
//  PMProfileManager.m
//  ProductivityManager
//
//  Created by Orion Stanger on 3/5/13.
//  Copyright (c) 2013 Orion. All rights reserved.
//

#import "PMProfileManager.h"
#import "PMAppDelegate.h"

static PMProfileManager *_sharedProfileManager;

@implementation PMProfileManager

@synthesize profileData = _profileData;

- (void)setProfileData:(NSDictionary *)profileData
{
	_profileData = profileData;
	[_profileData writeToFile:[@"~/Development/Mac/ProductivityManager/ProductivityManager/profileData.plist" stringByResolvingSymlinksInPath] atomically:YES];
}

- (NSDictionary *)profileData
{
	if (!_profileData) _profileData = [[NSDictionary alloc] initWithContentsOfFile:[@"~/Development/Mac/ProductivityManager/ProductivityManager/profileData.plist" stringByResolvingSymlinksInPath]];
	if (!_profileData) _profileData = [[NSDictionary alloc] init];
	return _profileData;
}

+ (PMProfileManager *)sharedProfileManager
{
	if (!_sharedProfileManager) _sharedProfileManager = [[self alloc] init];
	return _sharedProfileManager;
}

#pragma mark - DataSource Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (self.profileData == nil)
		return 0;
	
	PMAppDelegate *delegate = [NSApplication sharedApplication].delegate;
	return [[self.profileData objectForKey:delegate.selectedProfile] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (self.profileData == nil)
        return nil;
    
	PMAppDelegate *delegate = [NSApplication sharedApplication].delegate;
	
	if ([tableColumn.identifier isEqualToString:@"img"])
	{
		NSLog(@"img: %@", [[NSWorkspace sharedWorkspace] iconForFile:[[self.profileData objectForKey:delegate.selectedProfile] objectAtIndex:row]]);
		return [[NSWorkspace sharedWorkspace] iconForFile:[[self.profileData objectForKey:delegate.selectedProfile] objectAtIndex:row]];
	}
	else if ([tableColumn.identifier isEqualToString:@"appName"])
	{
		return [PMUtils applicationNameForPath:[[self.profileData objectForKey:delegate.selectedProfile] objectAtIndex:row]];
	}
	else
	{
		NSLog(@"Invalid table column");
		return nil;
	}
}

@end
