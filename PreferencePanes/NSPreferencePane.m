/* NSPreferencePane.m
 *
 * Copyright (C) 2005-2010 Free Software Foundation, Inc.
 *
 * Author: Enrico Sersale <enrico@imago.ro>
 * Date: December 2005
 *
 * This file is part of the GNUstep PreferencePanes framework
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 31 Milk Street #960789 Boston, MA 02196 USA.
 */

#include <AppKit/AppKit.h>
#include "NSPreferencePane.h"

@implementation NSPreferencePane

- (void) dealloc
{
  TEST_RELEASE (_bundle);
  TEST_RELEASE (_mainView);
  [super dealloc];
}

- (NSUInteger) hash
{
  return [[_bundle bundleIdentifier] hash];
}

- (BOOL) isEqual: (id)other
{
  if (other == self)
    {
      return YES;
    }
  if ([other isKindOfClass: [NSPreferencePane class]])
    {
      return [[_bundle bundleIdentifier]
	isEqual: [[other bundle] bundleIdentifier]];
    }
  return NO;
}
//
// Initializing the preference pane
//
- (id) initWithBundle: (NSBundle *)bundle
{
  self = [super init];

  if (self)
    {
      if ([bundle bundleIdentifier] != nil)
        {
	  ASSIGN (_bundle, bundle);
	}
      else
	{
	  DESTROY(self);
	}
    }

  return self;
}

//
// Obtaining the preference pane bundle
//
- (NSBundle *) bundle
{
  return _bundle;
}

//
// Setting up the main view
//
- (NSView *) assignMainView
{
  NSView *view = [self mainView];

  if (view == nil)
    {
      if (_window == nil)
	{
	  [NSException raise: NSInternalInconsistencyException
	    format: @"The \"_window\" outlet doesn't exist in the nib!"];
	  return nil;
	}

      view = [_window contentView];
      [self setMainView: view];
      [view removeFromSuperview];

      if (_firstKeyView == nil)
	{
	  [self setFirstKeyView: view];
	}
      if (_initialKeyView == nil)
	{
	  [self setInitialKeyView: view];
	}
      if (_lastKeyView == nil)
	{
	  [self setLastKeyView: view];
	}

      DESTROY (_window);
    }

  return view;
}

- (NSView *) loadMainView
{
  NSView *view = [self mainView];

  if (view == nil)
    {
      if ([NSBundle loadNibNamed: [self mainNibName] owner: self] == NO)
	{
	  return nil;
	}

      view = [self assignMainView];
      [self mainViewDidLoad];
    }

  return view;
}

- (NSString *) mainNibName
{
  NSString *name = [[_bundle infoDictionary] objectForKey: @"NSMainNibFile"];

  if (name)
    {
      name = [name stringByDeletingPathExtension];
    }

  return ((name != nil) ? name : (NSString *)@"Main");
}

- (NSView *) mainView
{
  return _mainView;
}

- (void) mainViewDidLoad
{
  /*
    Override this method to initialize the main view
    with the current preference settings.
  */
}

- (void) setMainView:(NSView *)view
{
  ASSIGN (_mainView, view);
}

//
// Handling keyboard focus
//
- (NSView *) firstKeyView
{
  return _firstKeyView;
}

- (NSView *) initialKeyView
{
  return _initialKeyView;
}

- (NSView *) lastKeyView
{
  return _lastKeyView;
}

- (void) setFirstKeyView: (NSView *)view
{
  _firstKeyView = view;
}

- (void) setInitialKeyView: (NSView *)view
{
  _initialKeyView = view;
}

- (void) setLastKeyView: (NSView *)view
{
  _lastKeyView = view;
}

- (BOOL) autoSaveTextFields
{
  return YES;
}

//
// Handling preference pane selection
//
- (BOOL) isSelected
{
  return (_mainView && [_mainView superview]);
}

- (void) didSelect
{
}

- (void) willSelect
{
}

- (void) didUnselect
{
}

- (void) replyToShouldUnselect: (BOOL)shouldUnselect
{
  NSString *notifName;

  if (shouldUnselect)
    {
      notifName = @"NSPreferencePaneDoUnselectNotification";
    }
  else
    {
      notifName = @"NSPreferencePaneCancelUnselectNotification";
    }

  [[NSNotificationCenter defaultCenter] postNotificationName: notifName
                                                      object: self];
}

- (NSPreferencePaneUnselectReply) shouldUnselect
{
  return NSUnselectNow;
}

- (void) willUnselect
{
}

//
// Help Menu support
//
- (void) updateHelpMenuWithArray: (NSArray *)arrayOfMenuItems
{
}

@end


@implementation NSPreferencePane (GNUstepExtensions)

- (NSString *) iconLabel
{
  return [[_bundle infoDictionary] objectForKey: @"NSPrefPaneIconLabel"];
}

- (NSComparisonResult) comparePane:(id)other
{
  return [[self iconLabel] compare: [other iconLabel]];
}

@end


