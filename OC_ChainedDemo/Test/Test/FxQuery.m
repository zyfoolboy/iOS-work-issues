//
//  FxQuery.m
//  Test
//
//  Created by 林盼盼 on 2016/12/21.
//  Copyright © 2016年 林盼盼. All rights reserved.
//

#import "FxQuery.h"

#define FxQueryCst_Str(_name) \
+ (NSString *)_name { \
return @#_name; \
}

@implementation FxQueryCst

FxQueryCst_Str(AND)
FxQueryCst_Str(OR)
FxQueryCst_Str(EQ)
FxQueryCst_Str(NE)
FxQueryCst_Str(GE)
FxQueryCst_Str(LE)
FxQueryCst_Str(GT)
FxQueryCst_Str(LT)
FxQueryCst_Str(IN)
FxQueryCst_Str(LIKE)
FxQueryCst_Str(BETWEEN)
FxQueryCst_Str(ASC)
FxQueryCst_Str(DESC)

@end


@implementation FxPage

@end

@implementation FxOrderBy

+ (FxOrderBy *(^)(NSString *, NSString *))create {
    return ^(NSString *column, NSString *seq){
        FxOrderBy *orderBy = [FxOrderBy new];
        orderBy.column = column;
        orderBy.seq = seq;
        return orderBy;
    };
}

@end

@implementation FxTerm


- (instancetype)init {
    self = [super init];
    if (self) {
        _type = FxQueryCst.AND;
        _value = [NSMutableArray array];
        _subTerms = [NSMutableArray array];
    }
    return self;
}
+ (FxTerm *(^)(NSString *, NSString *))create {
    return ^(NSString *type, NSString *column){
        FxTerm *fxTerm = [FxTerm new];
        fxTerm.value = [NSMutableArray array];
        fxTerm.subTerms = [NSMutableArray array];
        fxTerm.type = type;
        fxTerm.column = column;
        return fxTerm;
    };
}

- (FxTerm *(^)(FxTerm *))addTerm {
    return ^(FxTerm *subTerm) {
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id))eq {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.EQ, columnName);
        [subTerm.value addObject:value];
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id))ne {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.NE, columnName);
        [subTerm.value addObject:value];
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id))le {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.LE, columnName);
        [subTerm.value addObject:value];
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id))lt {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.LT, columnName);
        [subTerm.value addObject:value];
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id))ge {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.GE, columnName);
        [subTerm.value addObject:value];
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id))gt {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.GT, columnName);
        [subTerm.value addObject:value];
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id , ...))in {
    return ^(NSString *columnName, id value, ...) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.IN, columnName);
        va_list _arguments;
        va_start(_arguments, value);
        for (id key = value; key != nil; key = (__bridge id)va_arg(_arguments, void *)) {
            [subTerm.value addObject:key];
        }
        va_end(_arguments);
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id))like {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.LIKE, columnName);
        [subTerm.value addObject:value];
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)(NSString *, id , ...))between {
    return ^(NSString *columnName, id value, ...) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.BETWEEN, columnName);
        va_list _arguments;
        va_start(_arguments, value);
        for (id key = value; key != nil; key = (__bridge id)va_arg(_arguments, void *)) {
            [subTerm.value addObject:key];
        }
        va_end(_arguments);
        [self.subTerms addObject:subTerm];
        return self;
    };
}

- (FxTerm *(^)())and {
    return ^() {
        self.type = FxQueryCst.AND;
        return self;
    };
}

- (FxTerm *(^)())or {
    return ^() {
        self.type = FxQueryCst.OR;
        return self;
    };
}

@end


@implementation FxQuery

- (instancetype)init {
    self = [super init];
    if (self) {
        _range = LIST;
        _where = [FxTerm new];
        _sort = [NSMutableArray array];
        _page = [FxPage new];
    }
    return self;
}

+ (FxQuery *(^)(BOOL, FxRange))create {
    return ^(BOOL unio, FxRange range){
        FxQuery *query = [FxQuery new];
        query.sort = [NSMutableArray array];
        query.unio = unio;
        query.range = range;
        query.where = [FxTerm new];
        return query;
    };
}

- (FxQuery *(^)(NSString *,id))eq {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.EQ, columnName);
        [subTerm.value addObject:value];
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *,id))ne {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.NE, columnName);
        [subTerm.value addObject:value];
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *,id))le {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.LE, columnName);
        [subTerm.value addObject:value];
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *,id))lt {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.LT, columnName);
        [subTerm.value addObject:value];
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *,id))ge {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.GE, columnName);
        [subTerm.value addObject:value];
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *,id))gt {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.GT, columnName);
        [subTerm.value addObject:value];
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *, id ,...))in {
    return ^(NSString *columnName, id value, ...) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.IN, columnName);
        va_list _arguments;
        va_start(_arguments, value);
        for (id key = value; key != nil; key = (__bridge id)va_arg(_arguments, void *)) {
            [subTerm.value addObject:key];
        }
        va_end(_arguments);
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *,id))like {
    return ^(NSString *columnName, id value) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.LIKE, columnName);
        [subTerm.value addObject:value];
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *, id ,...))between {
    return ^(NSString *columnName, id value, ...) {
        FxTerm *subTerm = FxTerm.create(FxQueryCst.BETWEEN, columnName);
        va_list _arguments;
        va_start(_arguments, value);
        for (id key = value; key != nil; key = (__bridge id)va_arg(_arguments, void *)) {
            [subTerm.value addObject:key];
        }
        va_end(_arguments);
        self.where.addTerm(subTerm);
        return self;
    };
}

- (FxQuery *(^)(NSString *,...))orderBy {
    return ^(NSString *columnName , ...) {
        NSMutableArray *params = [NSMutableArray array];
        va_list _arguments;
        va_start(_arguments, columnName);
        for (id key = columnName; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [params addObject:key];
        }
        va_end(_arguments);
        
        for (int i = 0 ; i < params.count; i += 2) {
            [self.sort addObject:FxOrderBy.create(params[i], params[i + 1])];
        }
        
        return self;
    };
}

- (FxQuery *(^)(BOOL))withUnion {
    return ^(BOOL Union) {
        self.unio = Union;
        return self;
    };
}

- (FxQuery *(^)(FxRange))withRange {
    return ^(FxRange range) {
        self.range = range;
        return self;
    };
}

- (FxQuery *(^)(NSInteger))pageNo {
    return ^(NSInteger pageNo) {
        self.page.pageNo = pageNo;
        return self;
    };
}

- (FxQuery *(^)(NSInteger))pageSize {
    return ^(NSInteger pageSize) {
        self.page.pageSize = pageSize;
        return self;
    };
}

- (FxQuery *(^)(FxTerm *))addSubTerm {
    return ^(FxTerm *subTerm) {
        [self.where.subTerms addObject:subTerm];
        return self;
    };
}

- (FxQuery *(^)())and {
    return ^() {
        self.where.type = FxQueryCst.AND;
        return self;
    };
}

- (FxQuery *(^)())or {
    return ^() {
        self.where.type = FxQueryCst.OR;
        return self;
    };
}

- (FxQuery *(^)())selectBasic {
    return ^() {
        self.range = BASIC;
        return self;
    };
}

- (FxQuery *(^)())selectList {
    return ^() {
        self.range = LIST;
        return self;
    };
}

- (FxQuery *(^)())selectMore {
    return ^() {
        self.range = MORE;
        return self;
    };
}

@end