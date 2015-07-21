//
//  OB_Macro.h
//  Engage
//
//  Created by Praveen Kumar on 1/18/15.
//  Copyright (c) 2015 Praveen Kumar. All rights reserved.
//

#ifndef Engage_OB_Macro_h
#define Engage_OB_Macro_h


#endif

#define PROD 1


#if PROD
#define SERVERIP @"prod.offerbeam.com" // PROD
#define SERVICEURL @"http://prod.offerbeam.com/web_services/" // PROD
#define SERVICEURLJAVA @"http://offerbeam.com:8080/OfferBeamWebServices/" // PROD
#define SERVERHOSTNAME @"prod.offerbeam.com"
#define ImageUrl  @"http://prod.offerbeam.com/img/uploads/"
#else
#define SERVERIP @"app.dev.offerbeam.com" // PROD
#define SERVERHOSTNAME @"app.dev.offerbeam.com"
#define ImageUrl  @"http://app.dev.offerbeam.com/img/uploads/"
#endif
