/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIView.h>

#import "FBShimmering.h"


@protocol UIScrollViewDelegateWithKVOScrollingProperty <NSObject>

@property (nonatomic) BOOL scrolling;

@end


/**
  @abstract Lightweight, generic shimmering view.
 */
@interface FBShimmeringView : UIView <FBShimmering>

@property (weak, nonatomic) id<UIScrollViewDelegateWithKVOScrollingProperty> scrollingDelegate;

@end
