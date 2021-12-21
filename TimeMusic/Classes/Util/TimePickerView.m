//
//  TimePickerView.m
//  YourTurn
//
//  Created by Masaru Kuratomi on 11/02/19.
//

#import "TimePickerView.h"

#define _HOUR 0
#define _MIN 1
#define _SEC 2

#define _UINT_ 10


@implementation TimePickerView

@synthesize pickerViewDelegate;
@synthesize timeInterval;

//列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//各列のデータの数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case _HOUR:
            return 10;
        case _MIN:
            return 60 * _UINT_;
        case _SEC:
            return 60 * _UINT_;
        default:
            return 0;
    }
}

//データをビューで返す
- (UIView *)pickerView:(UIPickerView *)picker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	if ( _HOUR != component ) {	
		row = (row % 60);
	}

    UILabel *label = (UILabel *)view;
    if (!label){
        label = [[[UILabel alloc] init] autorelease];
        label.backgroundColor = [UIColor clearColor];	
		label.textAlignment = UITextAlignmentLeft;
		label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, 85, 30);
		label.font = [UIFont boldSystemFontOfSize:22];
		if ( 0 == row ){
			if ( _HOUR == component ) {
				label.text =  @"0 hours";
			}
			else if ( _MIN == component ) {
				label.text =  @"0 mins";
			}
			else if ( _SEC == component ) {
				label.text =  @"0 secs";
			}
		}
		else {
			label.text =  [[NSNumber numberWithInteger:row] stringValue];
		}
    }
	else{
		label.text =  [[NSNumber numberWithInteger:row] stringValue];
    }
    return label;
}

//単位をつける
- (void)setSelectRowUnit:(NSInteger)row inComponent:(NSInteger)component 
{	
	for (int i = -2; i <= 2; i++ ){
		NSInteger labalcnt = row - i;
		NSInteger num = labalcnt;
		if ( _HOUR != component ) {	
			num = (labalcnt % 60);
		}
		
		UILabel *label = (UILabel*)[self viewForRow:labalcnt forComponent:component];
		if (! label) {
			continue;
		}
		if ( i != 0 ) {
			label.text =  [[NSNumber numberWithInteger:num] stringValue];
		}
		else {
			if ( 1 == num && _HOUR == component ) {
				label.text =  [NSString stringWithFormat:@"%d hour", num];
			}
			else if ( 1 != num && _HOUR == component ) {
				label.text =  [NSString stringWithFormat:@"%d hours", num];
			}
			else if ( 1 == num && _MIN == component ) {
				label.text =  [NSString stringWithFormat:@"%d min", num];
			}
			else if ( 1 != num && _MIN == component ) {
				label.text =  [NSString stringWithFormat:@"%d mins", num];
			}
			else if ( 1 == num && _SEC == component ) {
				label.text =  [NSString stringWithFormat:@"%d sec", num];
			}
			else if ( 1 != num && _SEC == component ) {
				label.text =  [NSString stringWithFormat:@"%d secs", num];
			}
		}
	}
}


//データを選択したときの動作
- (void)pickerView:(TimePickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 時間を作成する
    timeInterval = [self selectedRowInComponent:_HOUR] * 3600;
	timeInterval += ([self selectedRowInComponent:_MIN] % 60) * 60;
	timeInterval += ([self selectedRowInComponent:_SEC] % 60);
	
    // run delegate method
    if ([pickerViewDelegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [pickerViewDelegate pickerView:pickerView didSelectRow:row inComponent:component];
    }
	[pickerView setSelectRowUnit:row inComponent:component];
}

//真ん中あたりに移動
-(void)pickerViewLoaded: (id)blah {
	
	NSInteger rowMin = [self selectedRowInComponent:_MIN];
	[self selectRow:[self calcSelectRow: rowMin] inComponent:_MIN animated:NO];
	NSInteger rowSec = [self selectedRowInComponent:_SEC];
	[self selectRow:[self calcSelectRow: rowSec] inComponent:_SEC animated:NO];
}


//真ん中あたりにの選択位置を返す
-(NSInteger)calcSelectRow: (NSInteger)selectRow {
	NSInteger max = 60 * _UINT_;
	NSInteger base = ( max / 2 ) - ( max / 2 ) % 60;
	return (selectRow % 60 + base);
}


//時間から選択する
- (void)selectRowWithCurrentTime
{
	//現在の時間に
	NSInteger time = (NSInteger)timeInterval;
    NSInteger hour = (NSInteger)(time / 3600);
    NSInteger min = [self calcSelectRow:(NSInteger)(time % 3600 / 60)];
    NSInteger sec = [self calcSelectRow:(time % 3600 % 60)];
	
	[self selectRow:hour inComponent:_HOUR animated:NO];
	[self selectRow:min inComponent:_MIN animated:NO];
    [self selectRow:sec inComponent:_SEC animated:NO];
    [self reloadAllComponents];
	[self setSelectRowUnit:hour inComponent:_HOUR];
	[self setSelectRowUnit:min inComponent:_MIN];
	[self setSelectRowUnit:sec inComponent:_SEC];
}

@end
