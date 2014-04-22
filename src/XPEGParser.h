#import <PEGKit/PKParser.h>

enum {
    XPEGPARSER_TOKEN_KIND_GE_SYM = 14,
    XPEGPARSER_TOKEN_KIND_PIPE,
    XPEGPARSER_TOKEN_KIND_PRECEDING_SIBLING,
    XPEGPARSER_TOKEN_KIND_TRUE,
    XPEGPARSER_TOKEN_KIND_PARENT,
    XPEGPARSER_TOKEN_KIND_ATTRIBUTE,
    XPEGPARSER_TOKEN_KIND_MOD,
    XPEGPARSER_TOKEN_KIND_NOT_EQUAL,
    XPEGPARSER_TOKEN_KIND_TEXT,
    XPEGPARSER_TOKEN_KIND_SELF,
    XPEGPARSER_TOKEN_KIND_COMMENT,
    XPEGPARSER_TOKEN_KIND_COLON,
    XPEGPARSER_TOKEN_KIND_CHILD,
    XPEGPARSER_TOKEN_KIND_DIV,
    XPEGPARSER_TOKEN_KIND_PRECEDING,
    XPEGPARSER_TOKEN_KIND_DOLLAR,
    XPEGPARSER_TOKEN_KIND_LT_SYM,
    XPEGPARSER_TOKEN_KIND_FOLLOWING,
    XPEGPARSER_TOKEN_KIND_DESCENDANT,
    XPEGPARSER_TOKEN_KIND_EQUALS,
    XPEGPARSER_TOKEN_KIND_FOLLOWING_SIBLING,
    XPEGPARSER_TOKEN_KIND_NODE,
    XPEGPARSER_TOKEN_KIND_GT_SYM,
    XPEGPARSER_TOKEN_KIND_DOUBLE_COLON,
    XPEGPARSER_TOKEN_KIND_NAMESPACE,
    XPEGPARSER_TOKEN_KIND_DOT_DOT,
    XPEGPARSER_TOKEN_KIND_OPEN_PAREN,
    XPEGPARSER_TOKEN_KIND_ABBREVIATEDAXISSPECIFIER,
    XPEGPARSER_TOKEN_KIND_CLOSE_PAREN,
    XPEGPARSER_TOKEN_KIND_DOUBLE_SLASH,
    XPEGPARSER_TOKEN_KIND_MULTIPLYOPERATOR,
    XPEGPARSER_TOKEN_KIND_OR,
    XPEGPARSER_TOKEN_KIND_PLUS,
    XPEGPARSER_TOKEN_KIND_PROCESSING_INSTRUCTION,
    XPEGPARSER_TOKEN_KIND_OPEN_BRACKET,
    XPEGPARSER_TOKEN_KIND_COMMA,
    XPEGPARSER_TOKEN_KIND_AND,
    XPEGPARSER_TOKEN_KIND_MINUS,
    XPEGPARSER_TOKEN_KIND_ANCESTOR,
    XPEGPARSER_TOKEN_KIND_CLOSE_BRACKET,
    XPEGPARSER_TOKEN_KIND_DESCENDANT_OR_SELF,
    XPEGPARSER_TOKEN_KIND_DOT,
    XPEGPARSER_TOKEN_KIND_FORWARD_SLASH,
    XPEGPARSER_TOKEN_KIND_FALSE,
    XPEGPARSER_TOKEN_KIND_LE_SYM,
    XPEGPARSER_TOKEN_KIND_ANCESTOR_OR_SELF,
};

@interface XPEGParser : PKParser

@end

