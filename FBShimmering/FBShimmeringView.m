/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBShimmeringView.h"

#import "FBShimmeringLayer.h"
#import <KVOController/FBKVOController.h>

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Convert your project to ARC or specify the -fobjc-arc flag.
#endif


@interface FBShimmeringView ()

@property (nonatomic) BOOL shouldShimmer;

@end


@implementation FBShimmeringView

+ (Class)layerClass
{
  return [FBShimmeringLayer class];
}

#define __layer ((FBShimmeringLayer *)self.layer)

#define LAYER_ACCESSOR(accessor, ctype) \
- (ctype)accessor { \
  return [__layer accessor]; \
}

#define LAYER_MUTATOR(mutator, ctype) \
- (void)mutator (ctype)value { \
  [__layer mutator value]; \
}

#define LAYER_RW_PROPERTY(accessor, mutator, ctype) \
  LAYER_ACCESSOR (accessor, ctype) \
  LAYER_MUTATOR (mutator, ctype)

- (BOOL)shimmering {
    return ((FBShimmeringLayer *)self.layer).shimmering;
}

- (void)setShimmering:(BOOL)shimmering {
    self.shouldShimmer = shimmering;
    [((FBShimmeringLayer *)self.layer) setShimmering:shimmering];
    
    if (shimmering) {
        if (self.scrollingDelegate) {
            __weak typeof(self) weakSelf = self;
            [self.KVOController observe:self.scrollingDelegate
                                keyPath:@"scrolling"
                                options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                  block:^(id observer, id object, NSDictionary *change) {
                                      const BOOL scrolling = weakSelf.scrollingDelegate.scrolling;
                                      if (scrolling) {
                                          [((FBShimmeringLayer *)self.layer) setShimmering:NO];
                                      }
                                      else {
                                          if (weakSelf.shouldShimmer) {
                                              [((FBShimmeringLayer *)self.layer) setShimmering:YES];
                                          }
                                      }
                                  }];
        }
    }
    else {
        if (self.scrollingDelegate) {
            [self.KVOController unobserve:self.scrollingDelegate];
        }
    }
}

LAYER_RW_PROPERTY(shimmeringPauseDuration, setShimmeringPauseDuration:, CFTimeInterval)
LAYER_RW_PROPERTY(shimmeringAnimationOpacity, setShimmeringAnimationOpacity:, CGFloat)
LAYER_RW_PROPERTY(shimmeringOpacity, setShimmeringOpacity:, CGFloat)
LAYER_RW_PROPERTY(shimmeringSpeed, setShimmeringSpeed:, CGFloat)
LAYER_RW_PROPERTY(shimmeringHighlightLength, setShimmeringHighlightLength:, CGFloat)
LAYER_RW_PROPERTY(shimmeringDirection, setShimmeringDirection:, FBShimmerDirection)
LAYER_ACCESSOR(shimmeringFadeTime, CFTimeInterval)
LAYER_RW_PROPERTY(shimmeringBeginFadeDuration, setShimmeringBeginFadeDuration:, CFTimeInterval)
LAYER_RW_PROPERTY(shimmeringEndFadeDuration, setShimmeringEndFadeDuration:, CFTimeInterval)

@end
