//
//Created by ESJsonFormatForMac on 18/12/19.
//

#import <Foundation/Foundation.h>

@class Tid,Recinfo,Readagent,Dyuserinfo,Incentiveinfolist,Videoinfo,Videotopic,Motif,Images,Imgnewextra,Recommendsources;
@interface newsRootModel : NSObject

@property (nonatomic, strong) NSArray *tid;

@end
@interface Tid : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger albumCount;

@property (nonatomic, assign) NSInteger imgType;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, copy) NSString *lmodify;

@property (nonatomic, assign) NSInteger rank;

@property (nonatomic, strong) NSArray *unlikeReason;

@property (nonatomic, assign) NSInteger unfoldMode;

@property (nonatomic, copy) NSString *prompt;

@property (nonatomic, assign) NSInteger picCount;

@property (nonatomic, strong) Recinfo *recInfo;

@property (nonatomic, copy) NSString *recSource;

@property (nonatomic, copy) NSString *ptime;

@property (nonatomic, copy) NSString *videoID;

@property (nonatomic, assign) NSInteger hasHead;

@property (nonatomic, copy) NSString *reqId;

@property (nonatomic, strong) NSArray *recommendSources;

@property (nonatomic, assign) NSInteger recType;

@property (nonatomic, copy) NSString *template;

@property (nonatomic, copy) NSString *digest;

@property (nonatomic, assign) NSInteger hasAD;

@property (nonatomic, assign) NSInteger recNews;

@property (nonatomic, copy) NSString *recprog;

@property (nonatomic, copy) NSString *skipType;

@property (nonatomic, assign) NSInteger imgsum;

@property (nonatomic, copy) NSString *imgsrc;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, strong) Videoinfo *videoinfo;

@property (nonatomic, assign) NSInteger showType;

@property (nonatomic, assign) NSInteger downTimes;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) NSInteger imgLineNum;

@property (nonatomic, assign) NSInteger clkNum;

@property (nonatomic, assign) NSInteger danmu;

@property (nonatomic, copy) NSString *boardid;

@property (nonatomic, copy) NSString *interest;

@property (nonatomic, assign) NSInteger adtype;

@property (nonatomic, copy) NSString *docid;

@property (nonatomic, copy) NSString *TAG;

@property (nonatomic, strong) NSArray *imgnewextra;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, assign) NSInteger upTimes;

@property (nonatomic, strong) Motif *motif;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger refreshPrompt;

@property (nonatomic, copy) NSString *program;

@property (nonatomic, assign) NSInteger recomCount;

@property (nonatomic, copy) NSString *TAGS;

@property (nonatomic, copy) NSString *replyid;

@property (nonatomic, copy) NSString *skipID;

//加工后的
@property (nonatomic, strong) NSMutableAttributedString *showTitle;
@property (nonatomic, strong) NSMutableAttributedString *showBottom;

@end

@interface Recinfo : NSObject

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, assign) NSInteger criticismCount;

@property (nonatomic, assign) NSInteger praiseCount;

@property (nonatomic, strong) Readagent *readAgent;

@end

@interface Readagent : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, assign) NSInteger isHamletUser;

@property (nonatomic, strong) Dyuserinfo *dyUserInfo;

@property (nonatomic, copy) NSString *readerCert;

@property (nonatomic, copy) NSString *head;

@property (nonatomic, assign) NSInteger publishReaderPrivilige;

@property (nonatomic, strong) NSArray *incentiveInfoList;

@property (nonatomic, copy) NSString *passport;

@property (nonatomic, assign) NSInteger userType;

@end

@interface Dyuserinfo : NSObject

@property (nonatomic, copy) NSString *pushSwitch;

@property (nonatomic, copy) NSString *tid;

@property (nonatomic, copy) NSString *ename;

@property (nonatomic, copy) NSString *tdesc;

@property (nonatomic, copy) NSString *onlineState;

@end

@interface Incentiveinfolist : NSObject

@property (nonatomic, copy) NSString *info;

@property (nonatomic, assign) NSInteger iconType;

@property (nonatomic, copy) NSString *iconHref;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *url;

@end

@interface Videoinfo : NSObject

@property (nonatomic, assign) NSInteger voteCount;

@property (nonatomic, assign) NSInteger playCount;

@property (nonatomic, assign) NSInteger cntCLevel;

@property (nonatomic, copy) NSString *m3u8Hd_url;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, assign) NSInteger sizeSHD;

@property (nonatomic, copy) NSString *ViedeoDescription;

@property (nonatomic, copy) NSString *ptime;

@property (nonatomic, copy) NSString *m3u8_url;

@property (nonatomic, assign) NSInteger covCLevel;

@property (nonatomic, copy) NSString *topicName;

@property (nonatomic, assign) NSInteger sizeHD;

@property (nonatomic, copy) NSString *mp4_url;

@property (nonatomic, copy) NSString *cover;

@property (nonatomic, copy) NSString *vid;

@property (nonatomic, assign) NSInteger sizeSD;

@property (nonatomic, assign) NSInteger length;

@property (nonatomic, copy) NSString *replyBoard;

@property (nonatomic, copy) NSString *videosource;

@property (nonatomic, assign) NSInteger accoutClassify;

@property (nonatomic, copy) NSString *topicDesc;

@property (nonatomic, copy) NSString *topicSid;

@property (nonatomic, strong) NSArray *videoTag;

@property (nonatomic, assign) NSInteger danmu;

@property (nonatomic, copy) NSString *mp4Hd_url;

@property (nonatomic, assign) NSInteger playersize;

@property (nonatomic, assign) NSInteger autoPlay;

@property (nonatomic, copy) NSString *topicImg;

@property (nonatomic, assign) NSInteger videoRatio;

@property (nonatomic, strong) Videotopic *videoTopic;

@property (nonatomic, copy) NSString *sectiontitle;

@property (nonatomic, copy) NSString *firstFrameImg;

@property (nonatomic, strong) NSArray *extraTags;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *replyid;

@property (nonatomic, assign) BOOL shortV;

@end

@interface Videotopic : NSObject

@property (nonatomic, copy) NSString *tname;

@property (nonatomic, copy) NSString *alias;

@property (nonatomic, copy) NSString *topic_icons;

@property (nonatomic, copy) NSString *ename;

@property (nonatomic, copy) NSString *tid;

@end

@interface Motif : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, assign) NSInteger style;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *introduction;

@end

@interface Images : NSObject

@property (nonatomic, assign) NSInteger width;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger height;

@end

@interface Imgnewextra : NSObject

@property (nonatomic, copy) NSString *imgsrc;

@end

@interface Recommendsources : NSObject

@property (nonatomic, copy) NSString *tname;

@property (nonatomic, assign) NSInteger sub_num;

@property (nonatomic, copy) NSString *alias;

@property (nonatomic, copy) NSString *headline;

@property (nonatomic, copy) NSString *tid;

@property (nonatomic, copy) NSString *ename;

@property (nonatomic, copy) NSString *topic_icons;

@property (nonatomic, copy) NSString *incentiveTitle;

@end

