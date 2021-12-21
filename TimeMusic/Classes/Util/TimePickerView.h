//
//  TimePickerView.h
//  YourTurn
//
//  Created by Masaru Kuratomi on 11/02/19.
//

#import <UIKit/UIKit.h>


@interface TimePickerView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet id<UIPickerViewDelegate> pickerViewDelegate;
	IBOutlet NSTimeInterval timeInterval;
}

@property (nonatomic, assign) id<UIPickerViewDelegate>pickerViewDelegate;
@property (nonatomic, assign) NSTimeInterval timeInterval;

- (void)selectRowWithCurrentTime;
- (void)setSelectRowUnit:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerViewLoaded:(id)blah;

- (NSInteger)calcSelectRow:(NSInteger)selectRow;

@end

@interface NSObject (TimePickerViewDelegate)
- (void)pickerView:(TimePickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
