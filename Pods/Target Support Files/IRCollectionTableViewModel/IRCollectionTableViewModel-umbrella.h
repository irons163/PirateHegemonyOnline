#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "RowBasicModelItem+Private.h"
#import "RowBasicModelItem.h"
#import "RowType.h"
#import "SectionBasicModelItem.h"
#import "SectionModelItem.h"
#import "SectionType.h"
#import "TableViewBasicViewModel.h"
#import "IRCollectionTableViewModel.h"

FOUNDATION_EXPORT double IRCollectionTableViewModelVersionNumber;
FOUNDATION_EXPORT const unsigned char IRCollectionTableViewModelVersionString[];

