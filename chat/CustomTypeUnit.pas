/////////////////////////////////////////////////////////////////////////////////
///                                                                           ///
///                                                                           ///
///                       “ќЋ№ ќ —ќ«ƒјЌЌџ≈ “»ѕџ ƒјЌЌџ’                        ///
///                                                                           ///
///                                                                           ///
///                                                                           ///
/////////////////////////////////////////////////////////////////////////////////


unit CustomTypeUnit;

interface

   type   // тип подгрузки сообщений
   enumLoadMessage = (eAll,        // все
                      eDiff        // разница
                      );

   type  // какой браузер сейчас активен основной или дополнительный  !TODO эти же типы есть еще и в dashboard.exe
   enumActiveBrowser = (  eMaster = 0,
                          eSlave  = 1,
                          eNone   = 2
                        );

   type // типы чатов  !TODO эти же типы есть еще и в dashboard.exe
   enumChannel  = ( ePublic,  // публичный (main)
                    ePrivate  // приватный (тет-а-тет)
                  );


  type  // типы ID чатов   !TODO эти же типы есть еще и в dashboard.exe
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
