//  UITableView+KeyboardOffset.m
//  Copyright (c) 2018 HJ-Cai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "UITableView+KeyboardOffset.h"

@implementation UITableView (YKKeyboardOffset)
- (BOOL)yk_fitKeyboardShowing {
    return ((NSNumber *)objc_getAssociatedObject(self, _cmd)).boolValue;
}

- (void)setYk_fitKeyboardShowing:(BOOL)yk_fitKeyboardShowing {
    objc_setAssociatedObject(self, @selector(yk_fitKeyboardShowing), @(yk_fitKeyboardShowing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (yk_fitKeyboardShowing) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yk_observeKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yk_observeKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)yk_observeKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *keyBoardInfo = [notification userInfo];
    CGFloat duration = [[keyBoardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize keyboardSize = [[keyBoardInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGSize storedSize = CGSizeZero;
    [objc_getAssociatedObject(self, _cmd) getValue:&storedSize];
    CGSize keyboardSizeOffset = CGSizeZero;
    keyboardSizeOffset.width = keyboardSize.width - storedSize.width;
    keyboardSizeOffset.height = keyboardSize.height - storedSize.height;
    objc_setAssociatedObject(self, _cmd, @(keyboardSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!CGSizeEqualToSize(keyboardSizeOffset, CGSizeZero)) {
        [UIView animateWithDuration:duration animations:^{
            CGSize size = self.contentSize;
            size.height += keyboardSizeOffset.height;
            self.contentSize = size;
        } completion:nil];
    }
    
}

- (void)yk_observeKeyboardWillHide:(NSNotification *)notification {
    NSDictionary *keyBoardInfo = [notification userInfo];
    CGFloat duration = [[keyBoardInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize storedSize = CGSizeZero;
    [objc_getAssociatedObject(self, @selector(yk_observeKeyboardWillShow:)) getValue:&storedSize];
    objc_setAssociatedObject(self, @selector(yk_observeKeyboardWillShow:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (CGSizeEqualToSize(storedSize, CGSizeZero)) return;
    [UIView animateWithDuration:duration animations:^{
        CGSize size = self.contentSize;
        size.height -= storedSize.height;
        self.contentSize = size;
    } completion:nil];
}
@end
