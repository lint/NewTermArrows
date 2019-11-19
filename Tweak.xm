
@interface TerminalKeyInput
-(void)upKeyPressed;
-(void)downKeyPressed;
-(void)leftKeyPressed;
-(void)rightKeyPressed;

@property(strong, nonatomic) NSTimer *haTimer;
-(void) haHandleLongPress:(UILongPressGestureRecognizer *) arg1;
@end


%hook TerminalKeyInput
%property(strong, nonatomic) NSTimer *haTimer;

-(id) initWithFrame:(CGRect) arg1 {
	id orig = %orig;
	
	UILongPressGestureRecognizer *upLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(haHandleLongPress:)];
	UILongPressGestureRecognizer *downLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(haHandleLongPress:)];
	UILongPressGestureRecognizer *leftLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(haHandleLongPress:)];
	UILongPressGestureRecognizer *rightLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(haHandleLongPress:)];
	
	id keyboardToolbar = MSHookIvar<id>(self, "toolbar");
	
	[MSHookIvar<UIButton *>(keyboardToolbar, "upKey") addGestureRecognizer:upLongPress];
	[MSHookIvar<UIButton *>(keyboardToolbar, "downKey") addGestureRecognizer:downLongPress];
	[MSHookIvar<UIButton *>(keyboardToolbar, "leftKey") addGestureRecognizer:leftLongPress];
	[MSHookIvar<UIButton *>(keyboardToolbar, "rightKey") addGestureRecognizer:rightLongPress];	
	
	return orig;
}

%new
-(void) haHandleLongPress:(UILongPressGestureRecognizer *) recognizer {
	
	NSString *keyName = [[recognizer view] accessibilityLabel];
	
	if (recognizer.state == UIGestureRecognizerStateBegan){
		
		if (![self haTimer]){
			if ([keyName isEqualToString:@"Up"]){
				[self setHaTimer:[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(upKeyPressed) userInfo:nil repeats:YES]];
			} else if ([keyName isEqualToString:@"Down"]){
				[self setHaTimer:[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(downKeyPressed) userInfo:nil repeats:YES]];
			} else if ([keyName isEqualToString:@"Left"]){
				[self setHaTimer:[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(leftKeyPressed) userInfo:nil repeats:YES]];
			} else if ([keyName isEqualToString:@"Right"]){
				[self setHaTimer:[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(rightKeyPressed) userInfo:nil repeats:YES]];
			}
		}
		
	} else if (recognizer.state == UIGestureRecognizerStateEnded){
		
		if ([self haTimer]){
			[[self haTimer] invalidate];
			[self setHaTimer:nil];
		}
		
	}
}

%end


%ctor {

	%init(TerminalKeyInput = objc_getClass("NewTerm.TerminalKeyInput"));

}
