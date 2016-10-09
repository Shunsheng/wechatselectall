@interface CMessageWrap : NSObject
@property (nonatomic) unsigned int m_uiMessageType;
@property (retain, nonatomic) NSString *m_nsToUsr;
@property (retain, nonatomic) NSString *m_nsMsgSource;
@property (retain, nonatomic) NSString *m_nsContent;
@property (retain, nonatomic) NSString *m_nsFromUsr; 
@end

@interface CContact : NSObject
@property (retain, nonatomic) NSString *m_nsUsrName;
+ (id)getChatRoomMemberWithoutMyself:(id)arg1;
@end


@interface CContactMgr : NSObject
- (CContact *)getSelfContact;
@end

@interface MMServiceCenter : NSObject
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end

