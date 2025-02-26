/* TimeZone.m
 *  
 * Copyright (C) 2005-2013 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 * Date: December 2005
 *
 * This file is part of the GNUstep TimeZone Preference Pane
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 31 Milk Street #960789 Boston, MA 02196 USA.
 */

#import <AppKit/AppKit.h>
#import "TimeZone.h"
#import "MapView.h"

@implementation TimeZone

- (void)dealloc
{
	[super dealloc];
}

- (void)mainViewDidLoad
{
  if (mapView == nil)
    {
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSString *zone = [defaults objectForKey: @"Local Time Zone"];
      NSBundle *bundle = [self bundle];
      NSString *path = [bundle pathForResource: @"map" ofType: @"tiff"];
      NSImage *map = [[NSImage alloc] initWithContentsOfFile: path];

      path = [bundle pathForResource: @"zones" ofType: @"db"];

      mapView = [[MapView alloc] initWithFrame: [[imageBox contentView] frame]
				  withMapImage: map
				 timeZonesPath: path
			     forPreferencePane: self];

      [(NSBox *)imageBox setContentView: mapView];
      RELEASE (mapView);
      RELEASE (map);

      if (zone)
	{
	  [zoneField setStringValue: zone];
	}
    }  
}

- (void)showInfoOfLocation:(MapLocation *)loc
{
  if (loc) {
    [zoneField setStringValue: [loc zone]];
    [codeField setStringValue: [loc code]];
    [commentsField setStringValue: (([loc comments] != nil) ? [loc comments] : @"")];
  } else {
    [zoneField setStringValue: @""];
    [codeField setStringValue: @""];
    [commentsField setStringValue: @""];
  }
}

- (IBAction)setButtAction:(id)sender
{
  CREATE_AUTORELEASE_POOL(arp);
  NSUserDefaults *defaults;
  NSMutableDictionary *domain;

  defaults = [NSUserDefaults standardUserDefaults];
  [defaults synchronize];
  domain = [[defaults persistentDomainForName: NSGlobalDomain] mutableCopy];

  [domain setObject: [zoneField stringValue] forKey: @"Local Time Zone"];  
  
  [defaults setPersistentDomain: domain forName: NSGlobalDomain];
  [defaults synchronize];
  RELEASE (domain);

  RELEASE (arp);
}

@end







