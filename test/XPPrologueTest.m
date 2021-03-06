//
//  XPPrologueTest
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPTestScaffold.h"
#import "XPNodeTypeTest.h"
#import "XPLibxmlDocumentImpl.h"
#import "XPLibxmlNodeImpl.h"
#import "XPPathExpression.h"
#import "XPNodeInfo.h"
#import "XPItem.h"
#import "XPStandaloneContext.h"

#import <libxml/tree.h>

@interface XPPrologueTest : XCTestCase
@property (nonatomic, retain) XPStandaloneContext *env;
@property (nonatomic, assign) xmlNodePtr contextNode;
@property (nonatomic, assign) xmlParserCtxtPtr parserCtx;
@property (nonatomic, retain) XPSequenceValue *res;
@property (nonatomic, retain) NSArray *ids;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSArray *paras;
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) NSArray *pis;
@end

@implementation XPPrologueTest

- (void)setUp {
    [super setUp];
    
    self.ids = @[@"c1", @"c2", @"c3"];
    self.titles = @[@"Chapter 1", @"Chapter 2", @"Chapter 3"];
    self.paras = @[@"Chapter 1 content. ", @"Chapter 2 content.", @"Chapter 3 content."];
    self.comments = @[@" some comment  text "];
    self.pis = @[@"bar='baz'"];
    
    //NSString *str = XPContentsOfFile(@"book.xml");
    NSString *path = XPPathOfFile(@"book.xml");
    
    
    self.parserCtx = xmlNewParserCtxt();
    
    xmlLineNumbersDefault(1);
    
    int record_info = 1;
    xmlSetFeature(_parserCtx, "gather line info", &record_info);
    //    int validate = 1;
    //    xmlSetFeature(_parserCtx, "validate", &validate);
    //XML_PARSE_DTDVALID
    xmlDocPtr doc = xmlCtxtReadFile(_parserCtx, [path UTF8String], NULL, XML_PARSE_NOENT);
    //xmlDocPtr doc = xmlCtxtReadMemory(_parserCtx, [str UTF8String], [str length], NULL, "utf-8", XML_PARSE_NOENT|);
    TDTrue(NULL != doc);
    
    //
    // NOTE: the <book> outermost element is the context node in all tests!!!
    //
    
    xmlNodePtr docEl = xmlFirstElementChild((void *)doc);
    TDTrue(NULL != docEl);
    TDTrue(0 == strcmp((char *)docEl->name, "book"));
    
    self.env = [XPStandaloneContext standaloneContext];
    [_env setItem:[XPStringValue stringValueWithString:@"hello"] forVariable:@"foo"];
    [_env setItem:[XPStringValue stringValueWithString:@"bye"] forVariable:@"bar"];
    
    self.contextNode = docEl;
}


- (void)eval:(NSString *)xpathStr {
    TDNotNil(_env);
    NSError *err = nil;
    
    id <XPNodeInfo>ctxNode = [XPLibxmlNodeImpl nodeInfoWithNode:_contextNode parserContext:_parserCtx];
    self.res = [_env execute:xpathStr withContextNode:ctxNode error:&err];
    if (err) {
        NSLog(@"%@", err);
    }
    //TDNil(err);
    TDNotNil(_res);
}


- (void)tearDown {
    self.ids = nil;
    self.titles = nil;
    self.paras = nil;
    self.comments = nil;
    self.pis = nil;
    [super tearDown];
}


- (void)testDelcareVariableRef {
    [self eval:@"declare variable $foo := 'zentradi'; $foo"];
    
    TDEqualObjects(@"zentradi", [_res asString]);
}


- (void)testDelcareFunctionLiteralReturn {
    [self eval:@"declare function foo() { 'breetai' }; foo()"];
    
    TDEqualObjects(@"breetai", [_res asString]);
}


- (void)testDelcareFunctionParamReturn {
    [self eval:@"declare function foo($arg) { $arg }; foo('exedore')"];
    
    TDEqualObjects(@"exedore", [_res asString]);
}


- (void)testDelcareFunctionParamReturnSameName {
    [self eval:@"declare function foo($foo) { $foo }; foo('Karl Reber')"];
    
    TDEqualObjects(@"Karl Reber", [_res asString]);
}


- (void)testDelcareFunctionParamReturnSameNameOverride {
    [self eval:@"declare variable $foo := 'Lynn Kyle'; declare function foo($foo) { $foo }; (foo('Karl Reber'), $foo)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    TDEqualObjects(@"Karl Reber", [[enm nextItem] stringValue]);
    TDEqualObjects(@"Lynn Kyle", [[enm nextItem] stringValue]);
}


- (void)testDelcareFunctionParamReturnSameNameFetchGlobal {
    [self eval:@"declare variable $three := 3; declare function print($arg1, $arg2) { ($arg2, $arg1, $three) }; print(4, 5)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    TDEqualObjects(@"5", [[enm nextItem] stringValue]);
    TDEqualObjects(@"4", [[enm nextItem] stringValue]);
    TDEqualObjects(@"3", [[enm nextItem] stringValue]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testOpenForCInChapterReturnC {
    [self eval:@"declare function myfunc($arg) { string($arg) }; for $attr in chapter/@id return myfunc($attr)"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        TDEqualObjects(_ids[i], [[enm nextItem] stringValue]);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testForCInChapterHasTitle {
    [self eval:@"declare function hasTitle($arg) { $arg/title }; for $c in chapter[hasTitle(.)] return $c/title"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    
    for (NSUInteger i = 0; i < 3; ++i) {
        TDEqualObjects(_titles[i], [[enm nextItem] stringValue]);
    }
    
    TDFalse([enm hasMoreItems]);
}


- (void)testRecursion {
    [self eval:
        @"declare function mysum($v) {\n"
        @"    let $head := $v[1],\n"
        @"        $tail := subsequence($v, 2),\n"
        @"         $len := count($v)\n"
        @"            return \n"
        @"                if ($len = 1) then \n"
        @"                    $head \n"
        @"                else \n"
        @"                    $head + mysum($tail)\n"
        @"};\n"
        @"mysum((1,2,3))\n"
    ];
    
    TDEqualObjects(@"6", [_res asString]);
}


- (void)testFunctionLiteral {
    [self eval:@"let $myfunc := function ($arg) { concat($arg, 'bar') } return $myfunc('foo')"];
    
    TDEqualObjects(@"foobar", [_res asString]);
}


- (void)testHigherOrderFunc {
    [self eval:@"let $filter := function($arg) { concat($arg, ' san') } let $apply := function ($f, $arg) { ($f($arg)) } for $name in ('Todd', 'Macy') return ($apply($filter, $name))"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    TDEqualObjects(@"Todd san", [[enm nextItem] stringValue]);
    TDEqualObjects(@"Macy san", [[enm nextItem] stringValue]);

    TDFalse([enm hasMoreItems]);
}


- (void)testAnonFunc {
    [self eval:@"(function (){ 'rick hunter' })()"];
    
    TDEqualObjects(@"rick hunter", [_res asString]);
}


- (void)testAnonArgs {
    [self eval:@"(function ($a, $b){ concat($a, ' ', $b) })('Rick', 'Hunter')"];
    
    TDEqualObjects(@"Rick Hunter", [_res asString]);
}


- (void)testAnonHigherOrderFunc {
    [self eval:@"let $apply := function ($f, $seq) { for $item in $seq return $f($item) } return $apply(function ($arg) { concat($arg, ' san')}, ('Todd', 'Macy'))"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    TDEqualObjects(@"Todd san", [[enm nextItem] stringValue]);
    TDEqualObjects(@"Macy san", [[enm nextItem] stringValue]);
    
    TDFalse([enm hasMoreItems]);
}


- (void)testAnonHigherOrderFuncSeq {
    [self eval:@"let $apply := function ($f, $seq) { for $item in $seq return $f($item) } return 1, $apply(function ($arg) { concat($arg, ' san')}, ('Todd', 'Macy'))"];
    
    id <XPSequenceEnumeration>enm = [_res enumerate];
    TDEqualObjects(@"1", [[enm nextItem] stringValue]);
    TDEqualObjects(@"Todd san", [[enm nextItem] stringValue]);
    TDEqualObjects(@"Macy san", [[enm nextItem] stringValue]);
    
    TDFalse([enm hasMoreItems]);
}

@end
