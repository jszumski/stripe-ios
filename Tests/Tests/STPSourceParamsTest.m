//
//  STPSourceParamsTest.m
//  Stripe
//
//  Created by Ben Guo on 1/25/17.
//  Copyright © 2017 Stripe, Inc. All rights reserved.
//

@import XCTest;

#import "STPSource+Private.h"
#import "STPSourceParams+Private.h"

#import "Stripe.h"
#import "STPFormEncoder.h"

@interface STPSourceParamsTest : XCTestCase

@end

@implementation STPSourceParamsTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -

- (void)testInit {
    STPSourceParams *sourceParams = [[STPSourceParams alloc] init];
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"");
    XCTAssertEqual(sourceParams.flow, STPSourceFlowUnknown);
    XCTAssertEqual(sourceParams.usage, STPSourceUsageUnknown);
    XCTAssertEqualObjects(sourceParams.additionalAPIParameters, @{});
}

- (void)testType {
    STPSourceParams *sourceParams = [[STPSourceParams alloc] init];
    XCTAssertEqual(sourceParams.type, STPSourceTypeUnknown);

    sourceParams.rawTypeString = @"bancontact";
    XCTAssertEqual(sourceParams.type, STPSourceTypeBancontact);

    sourceParams.rawTypeString = @"bitcoin";
    XCTAssertEqual(sourceParams.type, STPSourceTypeBitcoin);

    sourceParams.rawTypeString = @"card";
    XCTAssertEqual(sourceParams.type, STPSourceTypeCard);

    sourceParams.rawTypeString = @"giropay";
    XCTAssertEqual(sourceParams.type, STPSourceTypeGiropay);

    sourceParams.rawTypeString = @"ideal";
    XCTAssertEqual(sourceParams.type, STPSourceTypeIDEAL);

    sourceParams.rawTypeString = @"sepa_debit";
    XCTAssertEqual(sourceParams.type, STPSourceTypeSEPADebit);

    sourceParams.rawTypeString = @"sofort";
    XCTAssertEqual(sourceParams.type, STPSourceTypeSofort);

    sourceParams.rawTypeString = @"three_d_secure";
    XCTAssertEqual(sourceParams.type, STPSourceTypeThreeDSecure);

    sourceParams.rawTypeString = @"unknown";
    XCTAssertEqual(sourceParams.type, STPSourceTypeUnknown);

    sourceParams.rawTypeString = @"garbage";
    XCTAssertEqual(sourceParams.type, STPSourceTypeUnknown);
}

- (void)testSetType {
    STPSourceParams *sourceParams = [[STPSourceParams alloc] init];
    XCTAssertEqual(sourceParams.type, STPSourceTypeUnknown);

    sourceParams.type = STPSourceTypeBancontact;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"bancontact");

    sourceParams.type = STPSourceTypeBitcoin;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"bitcoin");

    sourceParams.type = STPSourceTypeCard;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"card");

    sourceParams.type = STPSourceTypeGiropay;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"giropay");

    sourceParams.type = STPSourceTypeIDEAL;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"ideal");

    sourceParams.type = STPSourceTypeSEPADebit;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"sepa_debit");

    sourceParams.type = STPSourceTypeSofort;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"sofort");

    sourceParams.type = STPSourceTypeThreeDSecure;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"three_d_secure");

    sourceParams.type = STPSourceTypeUnknown;
    XCTAssertNil(sourceParams.rawTypeString);
}

- (void)testSetTypePreserveUnknownRawTypeString {
    STPSourceParams *sourceParams = [[STPSourceParams alloc] init];
    sourceParams.rawTypeString = @"money";
    sourceParams.type = STPSourceTypeUnknown;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"money");
}

- (void)testRawTypeString {
    STPSourceParams *sourceParams = [STPSourceParams new];

    // Check defaults to unknown
    XCTAssertEqual(sourceParams.type, STPSourceTypeUnknown);

    // Check changing type sets rawTypeString
    sourceParams.type = STPSourceTypeCard;
    XCTAssertEqualObjects(sourceParams.rawTypeString, [STPSource stringFromType:STPSourceTypeCard]);

    // Check changing to unknown raw string sets type to unknown
    sourceParams.rawTypeString = @"new_source_type";
    XCTAssertEqual(sourceParams.type, STPSourceTypeUnknown);

    // Check once unknown that setting type to unknown doesnt clobber string
    sourceParams.type = STPSourceTypeUnknown;
    XCTAssertEqualObjects(sourceParams.rawTypeString, @"new_source_type");

    // Check setting string to known type sets type correctly
    sourceParams.rawTypeString = [STPSource stringFromType:STPSourceTypeIDEAL];
    XCTAssertEqual(sourceParams.type, STPSourceTypeIDEAL);
}

- (void)testFlowString {
    STPSourceParams *sourceParams = [[STPSourceParams alloc] init];
    XCTAssertNil(sourceParams.flowString);

    sourceParams.flow = STPSourceFlowRedirect;
    XCTAssertEqualObjects(sourceParams.flowString, @"redirect");

    sourceParams.flow = STPSourceFlowReceiver;
    XCTAssertEqualObjects(sourceParams.flowString, @"receiver");

    sourceParams.flow = STPSourceFlowCodeVerification;
    XCTAssertEqualObjects(sourceParams.flowString, @"code_verification");

    sourceParams.flow = STPSourceFlowNone;
    XCTAssertEqualObjects(sourceParams.flowString, @"none");
}

#pragma mark - Description Tests

- (void)testDescription {
    STPSourceParams *sourceParams = [[STPSourceParams alloc] init];
    XCTAssert(sourceParams.description);
}

#pragma mark - Constructors Tests

- (void)testCardParamsWithCard {
    STPCardParams *card = [STPCardParams new];
    card.number = @"4242 4242 4242 4242";
    card.cvc = @"123";
    card.expMonth = 6;
    card.expYear = 2018;
    card.currency = @"usd";
    card.name = @"Jenny Rosen";
    card.addressLine1 = @"123 Fake Street";
    card.addressLine2 = @"Apartment 4";
    card.addressCity = @"New York";
    card.addressState = @"NY";
    card.addressCountry = @"USA";
    card.addressZip = @"10002";

    STPSourceParams *source = [STPSourceParams cardParamsWithCard:card];
    NSDictionary *sourceCard = source.additionalAPIParameters[@"card"];
    XCTAssertEqualObjects(sourceCard[@"number"], card.number);
    XCTAssertEqualObjects(sourceCard[@"cvc"], card.cvc);
    XCTAssertEqualObjects(sourceCard[@"exp_month"], @(card.expMonth));
    XCTAssertEqualObjects(sourceCard[@"exp_year"], @(card.expYear));
    XCTAssertEqualObjects(source.owner[@"name"], card.name);
    NSDictionary *sourceAddress = source.owner[@"address"];
    XCTAssertEqualObjects(sourceAddress[@"line1"], card.addressLine1);
    XCTAssertEqualObjects(sourceAddress[@"line2"], card.addressLine2);
    XCTAssertEqualObjects(sourceAddress[@"city"], card.addressCity);
    XCTAssertEqualObjects(sourceAddress[@"state"], card.addressState);
    XCTAssertEqualObjects(sourceAddress[@"postal_code"], card.addressZip);
    XCTAssertEqualObjects(sourceAddress[@"country"], card.addressCountry);
}

#pragma mark - Redirect Dictionary Tests

- (NSString *)redirectMerchantNameQueryItemValueFromURLString:(NSString *)urlString {
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name isEqualToString:@"redirect_merchant_name"]) {
            return item.value;
        }
    }
    return nil;
}

- (void)testRedirectMerchantNameURL {
    STPSourceParams *sourceParams = [STPSourceParams sofortParamsWithAmount:1000
                                                                  returnURL:@"test://foo?value=baz"
                                                                    country:@"DE"
                                                        statementDescriptor:nil];

    NSDictionary *params = [STPFormEncoder dictionaryForObject:sourceParams];
    // Should be nil because we have no app name in tests
    XCTAssertNil([self redirectMerchantNameQueryItemValueFromURLString:params[@"redirect"][@"return_url"]]);

    sourceParams.redirectMerchantName = @"bar";
    params = [STPFormEncoder dictionaryForObject:sourceParams];
    XCTAssertEqualObjects([self redirectMerchantNameQueryItemValueFromURLString:params[@"redirect"][@"return_url"]], @"bar");

    sourceParams = [STPSourceParams sofortParamsWithAmount:1000
                                                 returnURL:@"test://foo?redirect_merchant_name=Manual%20Custom%20Name"
                                                   country:@"DE"
                                       statementDescriptor:nil];
    sourceParams.redirectMerchantName = @"bar";
    params = [STPFormEncoder dictionaryForObject:sourceParams];
    // Don't override names set by the user directly in the url
    XCTAssertEqualObjects([self redirectMerchantNameQueryItemValueFromURLString:params[@"redirect"][@"return_url"]], @"Manual Custom Name");

}

#pragma mark - STPFormEncodable Tests

- (void)testRootObjectName {
    XCTAssertNil([STPSourceParams rootObjectName]);
}

- (void)testPropertyNamesToFormFieldNamesMapping {
    STPSourceParams *sourceParams = [[STPSourceParams alloc] init];

    NSDictionary *mapping = [STPSourceParams propertyNamesToFormFieldNamesMapping];

    for (NSString *propertyName in [mapping allKeys]) {
        XCTAssertFalse([propertyName containsString:@":"]);
        XCTAssert([sourceParams respondsToSelector:NSSelectorFromString(propertyName)]);
    }

    for (NSString *formFieldName in [mapping allValues]) {
        XCTAssert([formFieldName isKindOfClass:[NSString class]]);
        XCTAssert([formFieldName length] > 0);
    }

    XCTAssertEqual([[mapping allValues] count], [[NSSet setWithArray:[mapping allValues]] count]);
}

@end
