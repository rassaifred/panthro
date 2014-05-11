//
//  XPNSXMLNodeImpl.m
//  Panthro
//
//  Created by Todd Ditchendorf on 4/27/14.
//
//

#import "XPNSXMLNodeImpl.h"
#import "XPNSXMLDocumentImpl.h"
#import "XPAxis.h"
#import "XPNodeSetValueEnumeration.h"
#import "XPNodeTest.h"
#import "XPNodeSetValue.h"
#import "XPEmptyNodeSet.h"
#import "XPLocalOrderComparer.h"

@interface XPNSXMLNodeImpl ()
@property (nonatomic, retain, readwrite) NSXMLNode *node;
@property (nonatomic, retain, readwrite) id <XPNodeInfo>parent;
@property (nonatomic, assign, readwrite) NSInteger sortIndex;
@end

@implementation XPNSXMLNodeImpl

- (instancetype)initWithNode:(NSXMLNode *)node sortIndex:(NSInteger)idx {
    NSParameterAssert(node);
    self = [super init];
    if (self) {
        self.node = node;
        self.sortIndex = idx;
    }
    return self;
}


- (void)dealloc {
    self.node = nil;
    self.parent = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %@ %@>", [self class], self, XPNodeTypeName[self.nodeType], self.name];
}


- (NSComparisonResult)compareOrderTo:(id <XPNodeInfo>)other {
    XPAssert([other isKindOfClass:[XPNSXMLNodeImpl class]]);
    
    NSComparisonResult result = NSOrderedSame;
    
    // are they the same node?
    if ([self isSameNodeInfo:other]) {
        return result;
    }

    XPNSXMLNodeImpl *that = (id)other;

    // are they siblings (common case)
    if ([self.parent isSameNodeInfo:other.parent]) {
        return self.node.index - that.node.index;
    }
    
    // find the depths of both nodes in the tree
    
    NSUInteger depth1 = [self.node level];
    NSUInteger depth2 = [that.node level];
    id <XPNodeInfo>p1 = nil;
    id <XPNodeInfo>p2 = nil;
    
    // move up one branch of the tree so we have two nodes on the same level
    
    p1 = self;
    while (depth1>depth2) {
        p1 = p1.parent;
        if ([p1 isSameNodeInfo:that]) {
            return NSOrderedDescending;
        }
        depth1--;
    }
    
    p2 = that;
    while (depth2>depth1) {
        p2 = p2.parent;
        if ([p2 isSameNodeInfo:self]) {
            return NSOrderedAscending;
        }
        depth2--;
    }
    
    // now move up both branches in sync until we find a common parent
    while (1) {
        id <XPNodeInfo>par1 = p1.parent;
        id <XPNodeInfo>par2 = p2.parent;
        if (!par1 || !par2) {
            [NSException raise:@"NullPointerException" format:@"NSXML Tree Compare - internal error"];
        }
        if ([par1 isSameNodeInfo:par2]) {
            return ((XPNSXMLNodeImpl *)p1).node.index - ((XPNSXMLNodeImpl *)p2).node.index;
        }
        p1 = par1;
        p2 = par2;
    }

    return result;
}


- (XPNodeType)nodeType {
    XPAssert(_node);
    XPNodeType type = XPNodeTypeNone;
    
    switch ([self.node kind]) {
        case NSXMLDocumentKind:
            type = XPNodeTypeRoot;
            break;
        case NSXMLElementKind:
            type = XPNodeTypeElement;
            break;
        case NSXMLAttributeKind:
            type = XPNodeTypeAttribute;
            break;
        case NSXMLNamespaceKind:
            type = XPNodeTypeNamespace;
            break;
        case NSXMLProcessingInstructionKind:
            type = XPNodeTypePI;
            break;
        case NSXMLCommentKind:
            type = XPNodeTypeComment;
            break;
        case NSXMLTextKind:
            type = XPNodeTypeText;
            break;
        case NSXMLInvalidKind:
        case NSXMLDTDKind:
        case NSXMLEntityDeclarationKind:
        case NSXMLAttributeDeclarationKind:
        case NSXMLNotationDeclarationKind:
        case NSXMLElementDeclarationKind:
        default:
            type = XPNodeTypeNone;
            break;
    }
    
    return type;
}


- (NSString *)stringValue {
    XPAssert(_node);
    return [_node stringValue];
}


- (NSString *)name {
    XPAssert(_node);
    return [_node name];
}


- (NSString *)localName {
    XPAssert(_node);
    return [_node localName];
}


- (NSString *)prefix {
    XPAssert(_node);
    return [_node prefix];
}


- (id <XPNodeInfo>)parent {
    XPAssert(_node);
    
    if (!_parent) {
        NSXMLNode *parent = [self.node parent];
        id <XPNodeInfo>node = nil;
        
        if (parent) {
            Class cls = (NSXMLDocumentKind == [parent kind]) ? [XPNSXMLDocumentImpl class] : [XPNSXMLNodeImpl class];
            node = [[[cls alloc] initWithNode:parent sortIndex:NSNotFound] autorelease];
            self.parent = node;
        }
    }
    
    return _parent;
}


- (NSString *)attributeValueForURI:(NSString *)uri localName:(NSString *)localName {
    XPAssert([_node isKindOfClass:[NSXMLElement class]]);
    NSXMLNode *attrNode = [(NSXMLElement *)_node attributeForLocalName:localName URI:uri];
    return [attrNode stringValue];
}


- (BOOL)isSameNodeInfo:(id <XPNodeInfo>)other {
    XPAssert(!other || [other isKindOfClass:[XPNSXMLNodeImpl class]]);
    return other == self || [(id)other node] == self.node;
}


- (id <XPDocumentInfo>)documentRoot {
    XPAssert(_node);
    return [[[XPNSXMLDocumentImpl alloc] initWithNode:[_node rootDocument] sortIndex:0] autorelease];
}


- (id <XPAxisEnumeration>)enumerationForAxis:(XPAxis)axis nodeTest:(XPNodeTest *)nodeTest {
    NSArray *nodes = nil;
    BOOL sorted = NO;
    
    switch (axis) {
        case XPAxisAncestor:
            sorted = NO;
            nodes = [self nodesForAncestorAxis:nodeTest];
            break;
        case XPAxisAncestorOrSelf:
            sorted = NO;
            nodes = [self nodesForAncestorOrSelfAxis:nodeTest];
            break;
        case XPAxisAttribute:
            sorted = YES;
            nodes = [self nodesForAttributeAxis:nodeTest];
            break;
        case XPAxisChild:
            sorted = YES;
            nodes = [self nodesForChildAxis:nodeTest];
            break;
        case XPAxisDescendant:
            sorted = YES;
            nodes = [self nodesForDescendantAxis:nodeTest];
            break;
        case XPAxisDescendantOrSelf:
            sorted = YES;
            nodes = [self nodesForDescendantOrSelfAxis:nodeTest];
            break;
        case XPAxisFollowing:
            sorted = YES;
            nodes = [self nodesForFollowingSiblingAxis:nodeTest includeDescendants:YES];
            break;
        case XPAxisFollowingSibling:
            sorted = YES;
            nodes = [self nodesForFollowingSiblingAxis:nodeTest includeDescendants:NO];
            break;
        case XPAxisNamespace:
            sorted = YES;
            break;
        case XPAxisParent:
            sorted = YES;
            nodes = [self nodesForParentAxis:nodeTest];
            break;
        case XPAxisPreceding:
            sorted = NO;
            nodes = [self nodesForPrecedingSiblingAxis:nodeTest includeDescendants:YES];
            break;
        case XPAxisPrecedingSibling:
            sorted = NO;
            nodes = [self nodesForPrecedingSiblingAxis:nodeTest includeDescendants:NO];
            break;
        case XPAxisSelf:
            sorted = YES;
            nodes = [self nodesForSelfAxis:nodeTest];
            break;
        default:
            XPAssert(0);
            break;
    }
    
    XPNodeSetValue *nodeSet = nil;
    
    if ([nodes count]) {
        nodeSet = [[[XPNodeSetValue alloc] initWithNodes:nodes comparer:[XPLocalOrderComparer instance]] autorelease];
        if (sorted) {
            [nodeSet sort];
        }
    } else {
        nodeSet = [XPEmptyNodeSet emptyNodeSet];
    }
    
    id <XPAxisEnumeration>enm = (id <XPAxisEnumeration>)[nodeSet enumerate];
    return enm;
}


- (NSArray *)nodesForSelfAxis:(XPNodeTest *)nodeTest {
    NSArray *result = nil;
    
    if ([nodeTest matches:self]) {
        result = @[self];
    }
    
    return result;
}


- (NSArray *)descendantNodesFromParent:(NSXMLNode *)parent nodeTest:(XPNodeTest *)nodeTest sortIndex:(NSInteger)sortIndex {
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSXMLNode *child in [parent children]) {
        ++sortIndex;
        
        [result addObjectsFromArray:[self descendantNodesFromParent:child nodeTest:nodeTest sortIndex:sortIndex]];
        
        id <XPNodeInfo>node = [[[XPNSXMLNodeImpl alloc] initWithNode:child sortIndex:sortIndex] autorelease];
        
        if ([nodeTest matches:node]) {
            [result addObject:node];
        }
    }
    
    return result;
}


- (NSArray *)nodesForDescendantOrSelfAxis:(XPNodeTest *)nodeTest {
    NSMutableArray *result = [NSMutableArray array];
    
    if ([nodeTest matches:self]) {
        [result addObject:self];
    }
    
    NSInteger sortIndex = self.sortIndex;
    [result addObjectsFromArray:[self descendantNodesFromParent:self.node nodeTest:nodeTest sortIndex:sortIndex]];
    
    return result;
}


- (NSArray *)nodesForDescendantAxis:(XPNodeTest *)nodeTest {
    NSMutableArray *nodes = [NSMutableArray array];
    
    NSInteger sortIndex = self.sortIndex;
    [nodes addObjectsFromArray:[self descendantNodesFromParent:self.node nodeTest:nodeTest sortIndex:sortIndex]];
    
    return nodes;
}


- (NSArray *)nodesForAncestorOrSelfAxis:(XPNodeTest *)nodeTest {
    NSMutableArray *result = [NSMutableArray array];
    
    if ([nodeTest matches:self]) {
        [result addObject:self];
    }
    
    [result addObjectsFromArray:[self nodesForAncestorAxis:nodeTest]];
    
    return result;
}


- (NSArray *)nodesForAncestorAxis:(XPNodeTest *)nodeTest {
    NSMutableArray *result = nil;
    
    NSInteger sortIndex = self.sortIndex;
    
    NSXMLNode *parent = [self.node parent];
    while (parent) {
        Class cls = (NSXMLDocumentKind == [parent kind]) ? [XPNSXMLDocumentImpl class] : [XPNSXMLNodeImpl class];
        id <XPNodeInfo>node = [[[cls alloc] initWithNode:parent sortIndex:--sortIndex] autorelease];
        
        if ([nodeTest matches:node]) {
            if (!result) {
                result = [NSMutableArray array];
            }
            [result addObject:node];
        }
        
        parent = [parent parent];
    }
    
    return result;
}


- (NSArray *)nodesForParentAxis:(XPNodeTest *)nodeTest {
    NSXMLNode *parent = [self.node parent];
    Class cls = (NSXMLDocumentKind == [parent kind]) ? [XPNSXMLDocumentImpl class] : [XPNSXMLNodeImpl class];

    id <XPNodeInfo>node = [[[cls alloc] initWithNode:parent sortIndex:self.sortIndex-1] autorelease];
    
    NSArray *result = nil;
    
    if ([nodeTest matches:node]) {
        result = @[node];
    }
    
    return result;
}


- (NSArray *)nodesForChildAxis:(XPNodeTest *)nodeTest {
    NSArray *children = [self.node children];
    
    NSMutableArray *result = nil;
    
    NSInteger sortIndex = self.sortIndex;
    
    for (NSXMLNode *child in children) {
        id <XPNodeInfo>node = [[[XPNSXMLNodeImpl alloc] initWithNode:child sortIndex:++sortIndex] autorelease];
        
        if ([nodeTest matches:node]) {
            if (!result) {
                result = [NSMutableArray array];
            }
            [result addObject:node];
        }
    }
    
    return result;
}


- (NSArray *)nodesForAttributeAxis:(XPNodeTest *)nodeTest {
    XPAssert(XPNodeTypeElement == self.nodeType);
    
    NSArray *attrs = [(NSXMLElement *)self.node attributes];
    
    NSMutableArray *result = nil;
    
    NSInteger sortIndex = self.sortIndex;
    
    for (NSXMLNode *attr in attrs) {
        id <XPNodeInfo>node = [[[XPNSXMLNodeImpl alloc] initWithNode:attr sortIndex:++sortIndex] autorelease];
        
        if ([nodeTest matches:node]) {
            if (!result) {
                result = [NSMutableArray array];
            }
            [result addObject:node];
        }
    }
    
    return result;
}


- (NSArray *)nodesForFollowingSiblingAxis:(XPNodeTest *)nodeTest includeDescendants:(BOOL)includeDescendants {
    NSMutableArray *result = [NSMutableArray array];

    NSXMLNode *parent = [self.node parent];
    NSArray *children = [parent children];
    NSUInteger c = [children count];
    NSUInteger i = [self.node index] + 1;
    
    children = [children subarrayWithRange:NSMakeRange(i, c - i)];
    
    NSInteger sortIndex = self.sortIndex;
    
    for (NSXMLNode *child in children) {
        id <XPNodeInfo>node = [[[XPNSXMLNodeImpl alloc] initWithNode:child sortIndex:++sortIndex] autorelease];
        
        if ([nodeTest matches:node]) {
            [result addObject:node];
        }
        
        if (includeDescendants) {
            [result addObjectsFromArray:[self descendantNodesFromParent:child nodeTest:nodeTest sortIndex:sortIndex]];
        }
    }
    
    return result;
}


- (NSArray *)nodesForPrecedingSiblingAxis:(XPNodeTest *)nodeTest includeDescendants:(BOOL)includeDescendants  {
    NSMutableArray *result = [NSMutableArray array];

    NSUInteger i = [self.node index];
    NSArray *children = [[[self.node parent] children] subarrayWithRange:NSMakeRange(0, i)];
    
    NSInteger sortIndex = self.sortIndex;
    
    for (NSXMLNode *child in [children reverseObjectEnumerator]) {
        id <XPNodeInfo>node = [[[XPNSXMLNodeImpl alloc] initWithNode:child sortIndex:++sortIndex] autorelease];
        
        if ([nodeTest matches:node]) {
            [result addObject:node];
        }

        if (includeDescendants) {
            [result addObjectsFromArray:[self descendantNodesFromParent:child nodeTest:nodeTest sortIndex:sortIndex]];
        }
    }
    
    return result;
}

@end
