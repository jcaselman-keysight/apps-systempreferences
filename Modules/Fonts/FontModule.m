/* (c) Ingolf Jandt, September 2006 
 *
 * Copyright (C) 2010 Free Software Foundation, Inc.
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
#import "FontModule.h"

#import <Foundation/NSNotification.h>

@implementation FontModule

- (void)mainViewDidLoad
{
  fontKeys = [[NSArray arrayWithObjects: @"NSFont", @"NSLabelFont",
		       @"NSBoldFont",
		       @"NSMenuFont", @"NSMessageFont",
		       @"NSPaletteFont", @"NSTitleBarFont",
		       @"NSToolTipsFont", @"NSControlContentFont", 
		       @"NSUserFont", @"NSUserFixedPitchFont", nil] retain];
  [keyPopup removeAllItems];
  [keyPopup addItemsWithTitles: [NSArray arrayWithObjects:
	    @"Default Font", @"Label Font",
	    @"Bold Font",
	    @"Menu Font", @"Message Font",
	    @"Palette Font", @"Title Bar Font",
	    @"Tool Tip Font", @"Control Content Font",
	    @"User Font", @"User Fixed-Pitch Font", nil]];
  [keyPopup selectItemAtIndex: 0];

  [self updatePreview];
}

- (void) keyPopupAction: (id)sender
{
  [self updatePreview];
}

- (void) setButtonAction: (id)sender
{
  NSFontManager *fontMgr = [NSFontManager sharedFontManager];
  [fontMgr setSelectedFont: [previewTextField font]  isMultiple:NO];
  [fontMgr orderFrontFontPanel: self];
}

- (void) changeFont: (id) sender
{
  NSFont *newFont;

  newFont = [sender convertFont: [previewTextField font]];

  if (newFont != nil)
    {
      NSString *fontKey;
      NSUserDefaults *defaults;
      NSMutableDictionary *domain; 

      defaults = [NSUserDefaults standardUserDefaults];
      domain =  [[defaults persistentDomainForName: NSGlobalDomain] mutableCopy];
      fontKey  = [fontKeys objectAtIndex: [keyPopup indexOfSelectedItem]];

      [domain setObject:[newFont fontName] 
		 forKey: fontKey];
      [domain setObject: 
		[NSString stringWithFormat: @"%.1f", [newFont pointSize]]
		 forKey: [fontKey stringByAppendingString:@"Size"]];

      [defaults setPersistentDomain: domain forName: NSGlobalDomain];
      [domain release];
      [self updatePreview];
    }
}

- (void) updatePreview;
{
  static NSDictionary *domain = nil;
  NSString *fontName, *fontKey, *sizeKey, *sizeString;
  float fontSize;

  domain = [[NSUserDefaults standardUserDefaults] 
	     persistentDomainForName: NSGlobalDomain];
  fontKey = [fontKeys objectAtIndex:[keyPopup indexOfSelectedItem]];
  fontName = [domain objectForKey: fontKey];
  if (fontName)
    {
      sizeKey = [fontKey stringByAppendingString:@"Size"];
      sizeString = [domain objectForKey: sizeKey];
      if (sizeString!=nil)
	{
	  fontSize=[sizeString floatValue];
	  [previewTextField setFont: [NSFont fontWithName: fontName 
					     size:fontSize]];
	  [previewTextField setStringValue: 
			      [fontName stringByAppendingFormat:
					  @", %.1f pt",	fontSize]];
	}
      else
	{
	  [previewTextField setFont:[NSFont fontWithName: fontName size:12.0]];
	  [previewTextField setStringValue: fontName];
	}
    }
  else
    {
      [previewTextField setFont:[NSFont systemFontOfSize: -1]];
      [previewTextField setStringValue: @"(unset)"];
    }
}

-(void) willUnselect
{
  NSFontPanel *panel = [[NSFontManager sharedFontManager] fontPanel:NO];
  if (panel!=nil)
    {
      [panel close];
    }
}

-(void) dealloc
{
  [fontKeys release];
  [super dealloc];
}
@end
