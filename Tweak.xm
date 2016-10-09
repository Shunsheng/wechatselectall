#import "wechatselectall.h"

%hook CMessageMgr
- (void)AddMsg:(id)arg1 MsgWrap:(CMessageWrap *)wrap{
	//Get Service
	Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
	IMP impMMSC = method_getImplementation(methodMMServiceCenter);
 	id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));

 	//Contact Manager
 	id contactManager = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("CContactMgr"));

 	//Get My ID
	Method methodGetSelfContact = class_getInstanceMethod(objc_getClass("CContactMgr"), @selector(getSelfContact));
	IMP impGS = method_getImplementation(methodGetSelfContact);
	id me = impGS(contactManager, @selector(getSelfContact));

	Ivar nsUsrNameIvar = class_getInstanceVariable([me class], "m_nsUsrName");
	id myName = object_getIvar(me, nsUsrNameIvar);

	//Text Message Type
	if (wrap.m_uiMessageType == 1) {
		//From Me
		if ([wrap.m_nsFromUsr isEqualToString:myName]) {
			//Group Chat
			if ([wrap.m_nsToUsr hasSuffix:@"@chatroom"]) {
				//m_nsMsgSource is nil in text message
				if (wrap.m_nsMsgSource == nil) {
					//Format
					if ([wrap.m_nsContent hasPrefix:@"!all"]) {
						//Get Members
						id members = ((id (*)(id, SEL, id))objc_msgSend)(objc_getClass("CContact"),@selector(getChatRoomMemberWithoutMyself:),wrap.m_nsToUsr);

						//Append Members
						NSMutableString *sourceString = [[NSMutableString alloc] initWithCapacity:1000];
						for (CContact *member in members) {
							[sourceString appendString:member.m_nsUsrName];
							[sourceString appendString:@","];
						}
						wrap.m_nsMsgSource = [NSString stringWithFormat:@"<msgsource><atuserlist>%@</atuserlist></msgsource>",sourceString];

						//Delete "!all"
						wrap.m_nsContent = [wrap.m_nsContent substringFromIndex:4];
					}
				}
			}
		}
	}

	//Send Message
    %orig;
}

%end

