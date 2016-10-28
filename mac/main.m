#import <Cocoa/Cocoa.h>
#include "../lib/lib.h"

@interface ExampleAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow* _window;
}
@end


@implementation ExampleAppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
	_window = [[NSWindow alloc]
		initWithContentRect: CGRectMake(335, 390, 480, 360)
		styleMask: (NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask )
		backing: NSBackingStoreBuffered
		defer: YES
	];

	[_window makeKeyAndOrderFront:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end


#define MENUITEM(t,a,k) [[[NSMenuItem alloc] initWithTitle:t action:a keyEquivalent:k] autorelease]

static void build_menu(NSApplication* app) {
	NSMenu* mainMenu = [[[NSMenu alloc] init] autorelease];
	[app setMainMenu:mainMenu];

	NSMenuItem* appMenuItem = MENUITEM(@"Example", NULL, @"");
	[mainMenu addItem:appMenuItem];

	NSMenu* appMenu = [[[NSMenu alloc] initWithTitle:@"Example"] autorelease];
	[appMenuItem setSubmenu:appMenu];

	[appMenu addItem:MENUITEM(@"About Example", @selector(orderFrontStandardAboutPanel:), @"")];
	[appMenu addItem:[NSMenuItem separatorItem]];
	[appMenu addItem:MENUITEM(@"Preferences…", NULL, @",")];
	[appMenu addItem:[NSMenuItem separatorItem]];

	NSMenuItem* servicesMenuItem = MENUITEM(@"Services", NULL, @"");
	[appMenu addItem:servicesMenuItem];

	NSMenu* servicesMenu = [[[NSMenu alloc] initWithTitle:@"Services"] autorelease];
	[servicesMenuItem setSubmenu:servicesMenu];
	[app setServicesMenu:servicesMenu];

	[appMenu addItem:[NSMenuItem separatorItem]];
	[appMenu addItem:MENUITEM(@"Hide Example", @selector(hide:), @"h")];

	NSMenuItem* hideOthersMenuItem = MENUITEM(@"Hide Others", @selector(hideOtherApplications:), @"h");
	[hideOthersMenuItem setKeyEquivalentModifierMask:NSEventModifierFlagCommand|NSEventModifierFlagOption];
	[appMenu addItem:hideOthersMenuItem];

	[appMenu addItem:[NSMenuItem separatorItem]];
	[appMenu addItem:MENUITEM(@"Quit Example", @selector(terminate:), @"q")];
}

#undef MENUITEM

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		NSApplication* app = [NSApplication sharedApplication];
		build_menu(app);
		[app setActivationPolicy:NSApplicationActivationPolicyRegular];
		[app setDelegate:[[[ExampleAppDelegate alloc] init] autorelease]];
		[app run];
	}

	return EXIT_SUCCESS;
}
