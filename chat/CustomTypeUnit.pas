/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                       ТОЛЬКО СОЗДАННЫЕ ТИПЫ ДАННЫХ                        ///
///                                                                           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit CustomTypeUnit;

interface

   type  // какой браузер сейчас активен основной или дополнительный
   enumActiveBrowser = (  eMaster = 0,
                          eSlave  = 1,
                          eNone   = 2
                        );

   type
   enumChannel  = ( ePublic,  // публичный (main)
                    ePrivate  // приватный (тет-а-тет)
                  );


  type  // типы ID чатов
 enumChatID = ( eChatMain = -1,
                eChatID0  = 0,
                eChatID1  = 1,
                eChatID2  = 2,
                eChatID3  = 3,
                eChatID4  = 4,
                eChatID5  = 5,
                eChatID6  = 6,
                eChatID7  = 7,
                eChatID8  = 8,
                eChatID9  = 9
                );


implementation

end.
