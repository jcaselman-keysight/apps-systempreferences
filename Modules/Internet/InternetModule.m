/*
 * InternetModule.m
 * Internet Module preferences panel
 * 
 * (c) 2010 Free Software Foundation
 *
 * Authors: Riccardo Mottola
 *          Wolfgang Lux
 *
 * Created 15 October 2010
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

#include <AppKit/AppKit.h>
#include "InternetModule.h"


@implementation InternetModule

- (void)mainViewDidLoad
{
  NSWorkspace *ws;
  NSArray     *httpApps;
  NSString    *browserName;
  NSImage     *browserIcon;

  ws = [NSWorkspace sharedWorkspace];
  httpApps =  [[ws infoForScheme: @"http"] allKeys];
  [defaultBrowserPopup removeAllItems];
  [defaultBrowserPopup addItemsWithTitles: httpApps];

  browserName = [ws getBestAppInRole: nil forScheme: @"http"];
  [defaultBrowserPopup selectItemWithTitle: browserName];

  browserIcon = [ws iconForFile: [ws fullPathForApplication: browserName]];
  [browserIconView setImage: browserIcon];
}

-(void) willUnselect
{
}

- (IBAction) browserChanged: (id)sender
{
  NSString *browserName;
  NSWorkspace *ws;
  NSImage     *browserIcon;

  ws = [NSWorkspace sharedWorkspace];
  browserName = [[defaultBrowserPopup selectedItem] title];
  browserIcon = [ws iconForFile: [ws fullPathForApplication: browserName]];
  [browserIconView setImage: browserIcon];

  [ws setBestApp: browserName inRole: nil forScheme: @"http"];
  if ([[ws infoForScheme:@"https"] objectForKey: browserName] != nil)
      [ws setBestApp: browserName inRole: nil forScheme: @"https"];
}


@end
