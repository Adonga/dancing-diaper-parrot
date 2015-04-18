#define GJ_clear_data_global
ds_list_clear(_GJ_globalKeys);
ds_map_clear(_GJ_globalData);

#define GJ_clear_data_user
if (_GJ_loggedIn)
{
    ds_list_clear(_GJ_userKeys);
    ds_map_clear(_GJ_userData);
}

#define GJ_clear_tableScores
var curMap, targetList, i;

if (_GJ_begun && _GJ_tablesLoaded == 2)
{
    curMap = ds_map_find_value(_GJ_scoreTables, argument0);
    targetList = ds_map_find_value(curMap, "scores");
    
    if (targetList != noone)
    {
        for (i = 0; i < ds_list_size(targetList); i+= 1)
        {
            ds_map_destroy(ds_list_find_value(targetList, i));
        }
        
        ds_list_destroy(targetList);
        ds_map_replace(curMap, "scores", noone);
    }
}

#define GJ_clear_tableScores_all
var curID, curMap, mainMap, targetList, i;

if (_GJ_begun && _GJ_tablesLoaded == 2)
{
    mainMap = ds_map_find_value(_GJ_scoreTables, 0);
    ds_map_delete(_GJ_scoreTables, 0);
    
    for (curID = ds_map_find_first(_GJ_scoreTables); ds_map_exists(_GJ_scoreTables, curID); curID = ds_map_find_next(_GJ_scoreTables, curID))
    {
        curMap = ds_map_find_value(_GJ_scoreTables, curID);
        targetList = ds_map_find_value(curMap, "scores");
        
        if (targetList != noone)
        {
            for (i = 0; i < ds_list_size(targetList); i+= 1)
            {
                ds_map_destroy(ds_list_find_value(targetList, i));
            }
            
            ds_list_destroy(targetList);
            ds_map_replace(curMap, "scores", noone);
        }
    }
    
    ds_map_add(_GJ_scoreTables, 0, mainMap);
}

#define GJ_clear_tableScores_user
var curMap, targetList, i;

if (_GJ_loggedIn && _GJ_tablesLoaded == 2)
{
    curMap = ds_map_find_value(_GJ_scoreTables, argument0);
    targetList = ds_map_find_value(curMap, "userScores");
    
    if (targetList != noone)
    {
        for (i = 0; i < ds_list_size(targetList); i+= 1)
        {
            ds_map_destroy(ds_list_find_value(targetList, i));
        }
        
        ds_list_destroy(targetList);
        ds_map_replace(curMap, "userScores", noone);
    }
}

#define GJ_clear_tableScores_user_all
var curID, curMap, mainMap, targetList, i;

if (_GJ_loggedIn && _GJ_tablesLoaded == 2)
{
    mainMap = ds_map_find_value(_GJ_scoreTables, 0);
    ds_map_delete(_GJ_scoreTables, 0);
    
    for (curID = ds_map_find_first(_GJ_scoreTables); ds_map_exists(_GJ_scoreTables, curID); curID = ds_map_find_next(_GJ_scoreTables, curID))
    {
        curMap = ds_map_find_value(_GJ_scoreTables, curID);
        targetList = ds_map_find_value(curMap, "userScores");
        
        if (targetList != noone)
        {
            for (i = 0; i < ds_list_size(targetList); i+= 1)
            {
                ds_map_destroy(ds_list_find_value(targetList, i));
            }
            
            ds_list_destroy(targetList);
            ds_map_replace(curMap, "userScores", noone);
        }
    }
    
    ds_map_add(_GJ_scoreTables, 0, mainMap);
}

#define GJ_clear_trophies
var curID, curMap, sprite;

if (_GJ_trophiesLoaded == 2)
{
    for (curID = ds_map_find_first(_GJ_trophyMaps); ds_map_exists(_GJ_trophyMaps, curID); curID = ds_map_find_next(_GJ_trophyMaps, curID))
    {
        curMap = ds_map_find_value(_GJ_trophyMaps, curID);
        sprite = ds_map_find_value(curMap, "image");
        
        if (sprite_exists(sprite))
        {
            sprite_delete(sprite);
        }
        
        ds_map_destroy(curMap);
    }
    
    ds_map_clear(_GJ_trophyMaps);
    _GJ_trophiesLoaded = 0;
}

#define GJ_clear_user
var curMap, data, retVal;

if (argument0 == 0 || argument0 == _GJ_loggedInID)
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (ds_map_exists(_GJ_userMaps, argument0)) {
    curMap = ds_map_find_value(_GJ_userMaps, argument0);
    data = ds_map_find_value(curMap, "avatar");
    
    if (sprite_exists(data))
    {
        sprite_delete(data);
    }
    
    ds_map_destroy(curMap);
    ds_map_delete(_GJ_userMaps, argument0);
    
    retVal = GJ_STATUS_OK;
}

return retVal;

#define GJ_clear_user_all
var curID, curUserMap, curMap, data;

curUserMap = ds_map_find_value(_GJ_userMaps, 0);
ds_map_delete(_GJ_userMaps, 0);
ds_map_delete(_GJ_userMaps, _GJ_loggedInID);

for (curID = ds_map_find_first(_GJ_userMaps); ds_map_exists(_GJ_userMaps, curID); curID = ds_map_find_next(_GJ_userMaps, curID))
{
    curMap = ds_map_find_value(_GJ_userMaps, curID);
    data = ds_map_find_value(curMap, "avatar");
    
    if (sprite_exists(data))
    {
        sprite_delete(data);
    }
    
    ds_map_destroy(curMap);
}

ds_map_clear(_GJ_userMaps);
ds_map_add(_GJ_userMaps, 0, curUserMap);
ds_map_add(_GJ_userMaps, _GJ_loggedInID, curUserMap);

#define GJ_begin
var retVal;

if (_GJ_begun)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    _GJ_apiURL_gameStr = "game_id=" + string(argument0);
    _GJ_privateKey = string(argument1);
    _GJ_loggedIn = false;
    _GJ_begun = true;
    
    GJ_autoLogin();
    GJ_fetch_tables(true);
    
    retVal = GJ_STATUS_OK;
}

return retVal;

#define GJ_cleanUp
/* GJ_cleanUp() will completely wipe all GJ related data from your game. In order to run GJ
** functions after calling this, you will need to call GJ_init() and GJ_begin() again. If you like
** having absolute control over the data associated w/ your game, then this is the script for you!
** You can end the game w/o calling it if you really want to though!
*/
var retVal, curID, curMap, data;

if (_GJ_begun)
{
    GJ_logout();
    GJ_clear_user_all();
    GJ_clear_tableScores_all();
    GJ_clear_data_global();

    while (!ds_list_empty(_GJ_apiHTTP_requests))
    {
        data = ds_list_find_value(_GJ_apiHTTP_requests, 0);
        ds_list_delete(_GJ_apiHTTP_requests, 0);
        ds_list_delete(_GJ_apiHTTP_requests, 0);
        httprequest_destroy(ds_list_find_value(_GJ_apiHTTP_requests, 0));
        ds_list_delete(_GJ_apiHTTP_requests, 0);
        
        repeat (data - 3)
        {
            ds_list_delete(_GJ_apiHTTP_requests, 0);
        }
    }
    
    ds_list_clear(_GJ_errorLog);

    _GJ_begun = false;
    _GJ_loggedIn = false;
    _GJ_privateKey = "";
    _GJ_apiURL_userStr = "";
    _GJ_apiURL_gameStr = "";
    _GJ_isActive = false;
    _GJ_sessionClock = noone;
    _GJ_sessionAttempts = 0;
    _GJ_session_pingRate = 30;
    _GJ_sessionOpen = 0;
    _GJ_tablesLoaded = 0;
    _GJ_trophiesLoaded = 0;
    
    retVal = GJ_STATUS_OK;
} else {
    retVal = GJ_STATUS_INVALID_CALL;
}

return retVal;

#define GJ_init
globalvar _GJ_loggedIn, _GJ_apiURL, _GJ_apiURL_userStr, _GJ_apiURL_gameStr, _GJ_errorLog, _GJ_userMaps, _GJ_apiHTTP_requests,
_GJ_sessionOpen, _GJ_sessionAttempts, _GJ_sessionClock, _GJ_isActive, _GJ_session_pingRate, _GJ_privateKey, _GJ_trophyMaps,
_GJ_trophiesLoaded, _GJ_begun, _GJ_scoreTables, _GJ_tablesLoaded, _GJ_tempBuffer, _GJ_globalKeys, _GJ_globalData, _GJ_userData,
_GJ_userKeys, _GJ_loggedInID;

_GJ_userMaps = ds_map_create();
_GJ_trophyMaps = ds_map_create();
_GJ_scoreTables = ds_map_create();
_GJ_globalData = ds_map_create();
_GJ_userData = ds_map_create();

_GJ_apiHTTP_requests = ds_list_create();
_GJ_errorLog = ds_list_create();
_GJ_globalKeys = ds_list_create();
_GJ_userKeys = ds_list_create();

_GJ_tempBuffer = buffer_create();

_GJ_begun = false;
_GJ_loggedIn = false;
_GJ_apiURL = "http://gamejolt.com/api/game/v1/";
_GJ_apiURL_userStr = "";
_GJ_apiURL_gameStr = "";
_GJ_privateKey = "";
_GJ_loggedInID = -1;
_GJ_sessionOpen = 0;
_GJ_sessionClock = noone;
_GJ_sessionAttempts = 0;
_GJ_isActive = false;
_GJ_session_pingRate = 30;
_GJ_tablesLoaded = 0;
_GJ_trophiesLoaded = 0;

ds_map_add(_GJ_userMaps, 0, noone);
ds_map_add(_GJ_scoreTables, 0, noone);

#define GJ_isLoggedIn
var retVal;

retVal = _GJ_loggedIn;

return retVal;

#define GJ_kill
GJ_cleanUp();

ds_map_destroy(_GJ_userMaps);
ds_map_destroy(_GJ_trophyMaps);
ds_map_destroy(_GJ_scoreTables);
ds_map_destroy(_GJ_globalData);

ds_list_destroy(_GJ_apiHTTP_requests);
ds_list_destroy(_GJ_errorLog);
ds_list_destroy(_GJ_globalKeys);

buffer_destroy(_GJ_tempBuffer);

#define GJ_login
var userName, userToken, handle, url, state, buffer, resultStr, retVal, tempHandle;

if (_GJ_loggedIn || !_GJ_begun)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    userName = string(argument0);
    userToken = string(argument1);
    _GJ_apiURL_userStr = "username=" + userName + "&user_token=" + userToken;
    
    handle = httprequest_create();
    url = GJ_make_url("users/auth/?format=dump&" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (GJ_awaitResult(handle) == 5)
    {
        httprequest_destroy(handle);
        retVal = GJ_STATUS_NETWORK_ERROR;
    } else {
        resultStr = GJ_getCallResult(handle);
        httprequest_destroy(handle);
        
        if (GJ_newError(resultStr) == GJ_STATUS_OK)
        {
            retVal = GJ_STATUS_REQUEST_FAILED;
        } else {
            handle = httprequest_create();
            url = GJ_make_url("users/?username=" + userName + "&");
            httprequest_connect(handle, url, false);
            
            if (GJ_awaitResult(handle) == 4)
            {
                _GJ_loggedIn = true;
                
                resultStr = GJ_getCallResult(handle);
                GJ_make_userMap(string_delete(resultStr, 1, 16), true);
                
                GJ_session_open();
                
                retVal = GJ_STATUS_OK;
            } else {
                retVal = GJ_STATUS_NETWORK_ERROR;
            }
            
            httprequest_destroy(handle);
        }
    }
}

return retVal;

#define GJ_logout
var retVal, curUser;

if (!_GJ_loggedIn)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    GJ_session_close();
    GJ_clear_tableScores_user_all();
    GJ_clear_data_user();
    GJ_clear_trophies();
    ds_map_replace(_GJ_userMaps, 0, noone);
    
    _GJ_loggedIn = false;
    _GJ_loggedInID = -1;
    retVal = GJ_STATUS_OK;
}

return retVal;

#define GJ_step
var i, curTime, killProcess, paramCount, ithCallType, ithHandle, ithID, ithState, fileType, newFile, buffer, new;

if (_GJ_begun)
{
    i = 0;
    curTime = date_current_time();
    killProcess = false;
    
    /** HANDLE SESSION PINGING AND OPENING **/
    if (_GJ_sessionClock != noone)
    {
        if (date_second_span(_GJ_sessionClock, curTime) >= _GJ_session_pingRate)
        {
            GJ_session_ping();
        }
    }
    
    /** HANDLE CALLS **/
    while (i < ds_list_size(_GJ_apiHTTP_requests))
    {
        paramCount = ds_list_find_value(_GJ_apiHTTP_requests, i);
        ithCallType = ds_list_find_value(_GJ_apiHTTP_requests, i + 1);
        ithHandle = ds_list_find_value(_GJ_apiHTTP_requests, i + 2);
        
        httprequest_update(ithHandle);
        ithState = httprequest_get_state(ithHandle);
    
        if (ithState == 5)
        {
            killProcess = true;
            
            switch (ithCallType)
            {
                case 20:
                    _GJ_sessionAttempts+= 1;
                    
                    if (_GJ_sessionAttempts == 3)
                    {
                        GJ_logout();
                        _GJ_sessionAttempts = 0;
                    }
                    break;
                    
                case 21:
                    _GJ_sessionAttempts+= 1;
                    
                    if (_GJ_sessionAttempts == 3)
                    {
                        GJ_session_open();
                        _GJ_sessionAttempts = 0;
                    }
                    break;
                
                case 30:
                    _GJ_trophiesLoaded = 0;
                    break;
                
                case 40:
                    _GJ_tablesLoaded = 0;
                    break;
            }
        } else if (ithState == 4) {
            killProcess = true;
            
            switch (ithCallType)
            {
                /** 1X ** USER CALLS **/
                
                    case 10:
                        GJ_handle_userFetch(ithHandle);
                        break;
                        
                /** 2X ** SESSION CALLS **/
                
                    case 20:
                        if (GJ_handle_openSesh(ithHandle) == GJ_STATUS_OK)
                        {
                            _GJ_sessionClock = curTime;
                        }
                        break;
                        
                    case 21:
                        if (GJ_handle_pingSesh(ithHandle) == GJ_STATUS_OK)
                        {
                            _GJ_sessionClock = curTime;
                        }
                        break;
                        
                /** 3X ** TROPHY CALLS **/
                
                    case 30:
                        GJ_handle_trophyFetch(ithHandle);
                        break;
                        
                    case 31:
                        GJ_handle_trophyAchieve(ithHandle, ds_list_find_value(_GJ_apiHTTP_requests, i + 3));
                        break;
                        
                /** 4X ** SCORE TABLE CALLS **/
                
                    case 40:
                        GJ_handle_tableFetch(ithHandle);
                        break;
                        
                    case 41:
                    case 42:
                        GJ_handle_scoreFetch(ithHandle, ds_list_find_value(_GJ_apiHTTP_requests, i + 3), ithCallType);
                        break;
                        
                /** 5X ** DATA STORAGE CALLS **/
                
                    case 50:
                        GJ_handle_globalKeyFetch(ithHandle);
                        break;
                        
                    case 51:
                        GJ_handle_userKeyFetch(ithHandle);
                        break;
                    
                    case 52:
                        GJ_handle_globalData(ithHandle, ds_list_find_value(_GJ_apiHTTP_requests, i + 3));
                        break;
                        
                    case 53:
                        GJ_handle_userData(ithHandle, ds_list_find_value(_GJ_apiHTTP_requests, i + 3));
                        break;
                    
                    case 54:
                    case 55:
                        GJ_handle_dataFile(ithHandle, ds_list_find_value(_GJ_apiHTTP_requests, i + 3), ds_list_find_value(_GJ_apiHTTP_requests, i + 4), ithCallType);
                        break;
                    
                    case 56:
                    case 57:
                        GJ_handle_dataRemoval(ithHandle, ds_list_find_value(_GJ_apiHTTP_requests, i + 3), ithCallType - 56);
                    
                    case 58:
                    case 59:
                        GJ_handle_storage(ithHandle, ds_list_find_value(_GJ_apiHTTP_requests, i + 3), ithCallType - 58);
                        break;
                        
                /** 6X ** IMAGE REQUESTS **/
                
                    case 60:
                    case 61:
                        ithID = ds_list_find_value(_GJ_apiHTTP_requests, i + 3);
                        fileType = httprequest_find_response_header(ithHandle, "Content-Type");
                        
                        if (string_length(fileType))
                        {
                            fileType = string_delete(fileType, 1, 6);
                            newFile = temp_directory + "\tempImage." + fileType;
                            buffer = buffer_create();
                            httprequest_get_message_body_buffer(ithHandle, buffer);
                            buffer_write_to_file(buffer, newFile);
                            buffer_destroy(buffer);
                            new = sprite_add(newFile, 1, false, false, 0, 0);
                            file_delete(newFile);
                            
                            if (ithCallType == 60)
                            {
                                ds_map_replace(ds_map_find_value(_GJ_userMaps, ithID), "avatar", new);
                            } else {
                                ds_map_replace(ds_map_find_value(_GJ_trophyMaps, ithID), "image", new);
                            }
                        }
                        break;
                        
                /** END REQUEST TYPES **/
                
                    default:
                        GJ_handle_default(ithHandle);
                        break;
            }
        }
        
        if (killProcess)
        {
            repeat (paramCount)
            {
                ds_list_delete(_GJ_apiHTTP_requests, i);
            }
            
            httprequest_destroy(ithHandle);
            killProcess = false;
        } else {
            i+= paramCount;
        }
    }
}

#define GJ_fetch_globalData
var retVal, url, handle;

if (!_GJ_begun)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    handle = httprequest_create();
    url = GJ_make_url("data-store/?format=dump&key=" + key + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_globalData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 52);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_globalFile
var retVal, url, handle;

if (!_GJ_begun)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("data-store/?format=dump&key=" + string(argument1) + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_dataFile(handle, argument2, argument1, 54);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 5);
        ds_list_add(_GJ_apiHTTP_requests, 54);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument2);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_globalKeys
var retVal, url, handle;

if (!_GJ_begun)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("data-store/get-keys/?");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_globalKeyFetch(handle);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 3);
        ds_list_add(_GJ_apiHTTP_requests, 50);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_tables
if (_GJ_tablesLoaded || !_GJ_begun)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    _GJ_tablesLoaded = 1;
    handle = httprequest_create();
    url = GJ_make_url("scores/tables/?");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_tableFetch(handle);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 3);
        ds_list_add(_GJ_apiHTTP_requests, 40);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_tableScores
var retVal, url, handle;

if (!is_real(argument1) || !is_real(argument2) || !ds_map_exists(_GJ_scoreTables, argument1))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = "scores/?limit=" + string(argument2)+"&";
    
    if (argument1 != 0)
    {
        url+= "table_id=" + string(argument1) + "&";
    }
    
    url = GJ_make_url(url);
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_scoreFetch(handle, argument1, 41);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 41);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_tableScores_user
var retVal, scoreMap, url, handle;

if (!is_real(argument1) || !is_real(argument2) || !ds_map_exists(_GJ_scoreTables, argument1))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_loggedIn) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = "scores/?limit=" + string(argument2)+"&"+_GJ_apiURL_userStr+"&";
    
    if (argument1 != 0)
    {
        url+= "table_id=" + string(argument1) + "&";
    }
    
    url = GJ_make_url(url);
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_scoreFetch(handle, argument1, 42);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 42);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_trophies
var retVal, url, handle;

if (!_GJ_loggedIn || _GJ_trophiesLoaded)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("trophies/?" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    _GJ_trophiesLoaded = 1;
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_trophyFetch(handle);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 3);
        ds_list_add(_GJ_apiHTTP_requests, 30);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_user
var retVal, url, handle;

if (!is_real(argument1))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun || ds_map_exists(_GJ_userMaps, argument1)) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("users/?user_id=" + string(argument1) + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userFetch(handle);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 3);
        ds_list_add(_GJ_apiHTTP_requests, 10);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_userData
var retVal, url, handle, key;

if (!_GJ_loggedIn)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    handle = httprequest_create();
    url = GJ_make_url("data-store/?format=dump&key=" + key + "&" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 53);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_userFile
var retVal, url, handle;

if (!_GJ_loggedIn)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("data-store/?format=dump&key=" + string(argument1) + "&" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_dataFile(handle, argument2, argument1, 55);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 5);
        ds_list_add(_GJ_apiHTTP_requests, 55);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument2);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_fetch_userKeys
var retVal, handle, url;

if (!_GJ_loggedIn)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("data-store/get-keys/?" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userKeyFetch(handle);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 3);
        ds_list_add(_GJ_apiHTTP_requests, 51);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_handle_dataFile
var resultStr, retVal, file;
resultStr = GJ_getCallResult(argument0);

if (string_pos("SUCCESS", resultStr) == 1)
{
    file = file_text_open_write(argument1);
    file_text_write_string(file, string_delete(resultStr, 1, 9));
    file_text_close(file);
    
    if (argument3 == 54)
    {
        if (ds_list_find_index(_GJ_globalKeys, argument2) == -1)
        {
            ds_list_add(_GJ_globalKeys, argument2);
        }
    } else {
        if (ds_list_find_index(_GJ_userKeys, argument2) == -1)
        {
            ds_list_add(_GJ_userKeys, argument2);
        }
    }
    
    retVal = GJ_STATUS_OK;
} else {
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_dataRemoval
var resultStr, retVal, pos;
resultStr = GJ_getCallResult(argument0);

if (string_pos("SUCCESS", resultStr) == 1)
{
    if (argument2)
    {
        if (ds_map_exists(_GJ_userData, argument1))
        {
            ds_map_delete(_GJ_userData, argument1);
        }
        
        pos = ds_list_find_index(_GJ_userKeys, argument1);
        if (pos > -1)
        {
            ds_list_delete(_GJ_userKeys, pos);
        }
    } else {
        if (ds_map_exists(_GJ_globalData, argument1))
        {
            ds_map_delete(_GJ_globalData, argument1);
        }
        
        pos = ds_list_find_index(_GJ_globalKeys, argument1);
        if (pos > -1)
        {
            ds_list_delete(_GJ_globalKeys, pos);
        }
    }
    
    retVal = GJ_STATUS_OK;
} else {
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_default
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (GJ_newError(resultStr) == GJ_STATUS_OK)
{
    retVal = GJ_STATUS_REQUEST_FAILED;
} else {
    retVal = GJ_STATUS_OK;
}

return retVal;

#define GJ_handle_globalData
var resultStr, retVal, key;
resultStr = GJ_getCallResult(argument0);
key = string(argument1);

if (string_pos("SUCCESS", resultStr) == 1)
{
    if (ds_map_exists(_GJ_globalData, key))
    {
        ds_map_replace(_GJ_globalData, key, string_delete(resultStr, 1, 9));
    } else {
        ds_map_add(_GJ_globalData, key, string_delete(resultStr, 1, 9));
    }
        
    if (ds_list_find_index(_GJ_globalKeys, key) == -1)
    {
        ds_list_add(_GJ_globalKeys, key);
    }
    
    retVal = GJ_STATUS_OK;
} else {
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_globalKeyFetch
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (string_pos('success:"true"', resultStr) == 1)
{
    ds_list_clear(_GJ_globalKeys);
    GJ_make_keys(_GJ_globalKeys, string_delete(resultStr, 1, 16));
    retVal = GJ_STATUS_OK;
} else {
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_openSesh
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (string_pos("SUCCESS", resultStr) == 1)
{
    _GJ_sessionOpen = true;
    _GJ_isActive = true;
    retVal = GJ_STATUS_OK;
} else {
    GJ_logout();
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

_GJ_sessionAttempts = 0;
return retVal;

#define GJ_handle_pingSesh
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (string_pos("SUCCESS", resultStr) == 1)
{
    retVal = GJ_STATUS_OK;
} else {
    GJ_session_open();
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

_GJ_sessionAttempts = 0;
return retVal;

#define GJ_handle_scoreFetch
var resultStr, result, retVal, curList;
resultStr = GJ_getCallResult(argument0);

if (string_pos('success:"true"', resultStr) == 1)
{
    result = ds_list_create();
    GJ_make_scoreListEntry(result, string_delete(resultStr, 1, 16));
    
    if (argument2 == 41)
    {
        curList = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument1), "scores");
        
        if (curList != noone)
        {
            GJ_clear_tableScores(argument1);
        }
        
        ds_map_replace(ds_map_find_value(_GJ_scoreTables, argument1), "scores", result);
    } else {
        curList = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument1), "userScores");
        
        if (curList != noone)
        {
            GJ_clear_tableScores_user(argument1);
        }
        
        ds_map_replace(ds_map_find_value(_GJ_scoreTables, argument1), "userScores", result);
    }
    
    retVal = GJ_STATUS_OK;
} else {
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_storage
var resultStr, retVal, pos;
resultStr = GJ_getCallResult(argument0);

if (string_pos("SUCCESS", resultStr) == 1)
{
    if (argument2)
    {
        if (ds_list_find_index(_GJ_userKeys, argument1) == -1)
        {
            ds_list_add(_GJ_userKeys, argument1);
        }
    } else {
        if (ds_list_find_index(_GJ_globalKeys, argument1) == -1)
        {
            ds_list_add(_GJ_globalKeys, argument1);
        }
    }
    retVal = GJ_STATUS_OK;
} else {
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_tableFetch
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (string_pos('success:"true"', resultStr) == 1)
{
    _GJ_tablesLoaded = 2;
    GJ_make_scoreTable(string_delete(resultStr, 1, 16));
    retVal = GJ_STATUS_OK;
} else {
    _GJ_tablesLoaded = 0;
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_trophyAchieve
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (string_pos('SUCCESS', resultStr) == 1)
{
    if (_GJ_trophiesLoaded == 2)
    {
        ds_map_replace(ds_map_find_value(_GJ_trophyMaps, argument1), "isAchieved", true);
        ds_map_replace(ds_map_find_value(_GJ_trophyMaps, argument1), "timeAchieved", "just now");
    }
    
    retVal = GJ_STATUS_OK;
} else {
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_trophyFetch
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (string_pos('success:"true"', resultStr) == 1)
{
    _GJ_trophiesLoaded = 2;
    GJ_make_trophyMap(string_delete(resultStr, 1, 16));
    retVal = GJ_STATUS_OK;
} else {
    _GJ_trophiesLoaded = 0;
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_userData
var resultStr, retVal, key;
resultStr = GJ_getCallResult(argument0);
key = string(argument1);

if (string_pos("SUCCESS", resultStr) == 1)
{
    if (ds_map_exists(_GJ_userData, key))
    {
        ds_map_replace(_GJ_userData, key, string_delete(resultStr, 1, 9));
    } else {
        ds_map_add(_GJ_userData, key, string_delete(resultStr, 1, 9));
    }
        
    if (ds_list_find_index(_GJ_userKeys, key) == -1)
    {
        ds_list_add(_GJ_userKeys, key);
    }
    
    retVal = GJ_STATUS_OK;
} else {
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_userFetch
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (string_pos('success:"true"', resultStr) == 1)
{
    GJ_make_userMap(string_delete(resultStr, 1, 16), false);
    retVal = GJ_STATUS_OK;
} else {
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_handle_userKeyFetch
var resultStr, retVal;
resultStr = GJ_getCallResult(argument0);

if (string_pos('success:"true"', resultStr) == 1)
{
    ds_list_clear(_GJ_userKeys);
    GJ_make_keys(_GJ_userKeys, string_delete(resultStr, 1, 16));
    retVal = GJ_STATUS_OK;
} else {
    GJ_newError(resultStr);
    retVal = GJ_STATUS_REQUEST_FAILED;
}

return retVal;

#define GJ_make_keys
var dataString, data, curLineEnd, keyName, newLine;
dataString = string(argument1);
newLine = chr(13)+chr(10);

while (string_length(dataString))
{
    curLineEnd = string_pos(newLine, dataString) + 1;
    if (!curLineEnd) curLineEnd = string_length(dataString) + 1;
    data = string_copy(dataString, 6, curLineEnd - 8);
    dataString = string_delete(dataString, 1, curLineEnd);
        ds_list_add(argument0, data);
}

#define GJ_make_scoreListEntry
var targetList, curMap, curLineEnd, data, dataString, newLine;
targetList = argument0;
dataString = argument1;
newLine = chr(13)+chr(10);

if (string_length(dataString))
{
    if (string_pos('scores:""', dataString) == 1)
    {
        exit;
    }

    curMap = ds_map_create();
    
    curLineEnd = string_pos(newLine, dataString) + 1;
    data = string_copy(dataString, 8, curLineEnd - 10);
    dataString = string_delete(dataString, 1, curLineEnd);
    ds_map_add(curMap, "score", data);
    
    curLineEnd = string_pos(newLine, dataString) + 1;
    data = real(string_copy(dataString, 7, curLineEnd - 9));
    dataString = string_delete(dataString, 1, curLineEnd);
    ds_map_add(curMap, "sort", data);
    
    curLineEnd = string_pos(newLine, dataString) + 1;
    data = string_copy(dataString, 13, curLineEnd - 15);
    dataString = string_delete(dataString, 1, curLineEnd);
    ds_map_add(curMap, "extra", data);
    
    curLineEnd = string_pos(newLine, dataString) + 1;
    data = string_copy(dataString, 7, curLineEnd - 9);
    dataString = string_delete(dataString, 1, curLineEnd);
    ds_map_add(curMap, "userName", data);
    
    curLineEnd = string_pos(newLine, dataString) + 1;
    data = string_copy(dataString, 10, curLineEnd - 12);
    dataString = string_delete(dataString, 1, curLineEnd);
    
    if (string_length(data) > 0)
    {
        data = real(data);
        ds_map_add(curMap, "isGuestScore", false);
        ds_map_add(curMap, "isUserScore", true);
    } else {
        ds_map_add(curMap, "isGuestScore", true);
        ds_map_add(curMap, "isUserScore", false);
    }
    
    ds_map_add(curMap, "userID", data);
    
    curLineEnd = string_pos(newLine, dataString) + 1;
    data = string_copy(dataString, 8, curLineEnd - 10);
    dataString = string_delete(dataString, 1, curLineEnd);
    ds_map_add(curMap, "guestName", data);
    
    ds_list_add(targetList, curMap);
    dataString = string_delete(dataString, 1, string_pos(newLine, dataString) + 1);
    GJ_make_scoreListEntry(targetList, dataString);
}

#define GJ_make_scoreTable
var dataString, scoreTableID, data, scoreTableMap, curLineEnd, newLine;
dataString = argument0;
newLine = chr(13)+chr(10);

if (string_length(dataString))
{
    curLineEnd = string_pos(newLine, dataString) + 1;
    scoreTableID = real(string_copy(dataString, 5, curLineEnd - 7));
    dataString = string_delete(dataString, 1, curLineEnd);
    
    if (ds_map_exists(_GJ_scoreTables, scoreTableID))
    {
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        if (!curLineEnd) curLineEnd = string_length(dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
    } else {
        scoreTableMap = ds_map_create();
        ds_map_add(_GJ_scoreTables, scoreTableID, scoreTableMap);
        ds_map_add(scoreTableMap, "scores", noone);
        ds_map_add(scoreTableMap, "userScores", noone);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 7, curLineEnd - 9);
        dataString = string_delete(dataString, 1, curLineEnd);
        ds_map_add(scoreTableMap, "name", data);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 14, curLineEnd - 16);
        dataString = string_delete(dataString, 1, curLineEnd);
        ds_map_add(scoreTableMap, "description", data);
    
        curLineEnd = string_pos(newLine, dataString);
        if (!curLineEnd) curLineEnd = string_length(dataString);
        data = string_copy(dataString, 10, curLineEnd - 11);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        
        if (data == "1")
        {
            ds_map_replace(_GJ_scoreTables, 0, scoreTableMap);
        }
    }
    
    GJ_make_scoreTable(dataString);
}

#define GJ_make_trophyMap
var dataString, trophyID, difficulty, data, trophyMap, curLineEnd, handle, newLine;
dataString = argument0;
newLine = chr(13)+chr(10);

if (string_length(dataString))
{
    curLineEnd = string_pos(newLine, dataString) + 1;
    trophyID = real(string_copy(dataString, 5, curLineEnd - 7));
    dataString = string_delete(dataString, 1, curLineEnd);

    if (ds_map_exists(_GJ_trophyMaps, trophyID))
    {
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        if (!curLineEnd) curLineEnd = string_length(dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
    } else {
        trophyMap = ds_map_create();
        ds_map_add(_GJ_trophyMaps, trophyID, trophyMap);
        ds_map_add(trophyMap, "image", noone);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 8, curLineEnd - 10);
        dataString = string_delete(dataString, 1, curLineEnd);
            ds_map_add(trophyMap, "title", data);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 14, curLineEnd - 16);
        dataString = string_delete(dataString, 1, curLineEnd);
            ds_map_add(trophyMap, "description", data);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 13, curLineEnd - 15);
        dataString = string_delete(dataString, 1, curLineEnd);
            switch (data)
            {
                case "Bronze":
                    difficulty = 0;
                    break;
                    
                case "Silver":
                    difficulty = 1;
                    break;
                    
                case "Gold":
                    difficulty = 2;
                    break;
                    
                case "Platinum":
                    difficulty = 3;
                    break;
            }
            ds_map_add(trophyMap, "difficulty", difficulty);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 12, curLineEnd - 14);
        dataString = string_delete(dataString, 1, curLineEnd);
            handle = httprequest_create();
            httprequest_connect(handle, data, false);
            ds_list_add(_GJ_apiHTTP_requests, 4);
            ds_list_add(_GJ_apiHTTP_requests, 61);
            ds_list_add(_GJ_apiHTTP_requests, handle);
            ds_list_add(_GJ_apiHTTP_requests, trophyID);
    
        curLineEnd = string_pos(newLine, dataString);
        if (!curLineEnd) curLineEnd = string_length(dataString);
        data = string_copy(dataString, 11, curLineEnd - 12);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
            ds_map_add(trophyMap, "isAchieved", (data != "false"));
            ds_map_add(trophyMap, "timeAchieved", data);
    }

    GJ_make_trophyMap(dataString);
}

#define GJ_make_url
var retVal;
retVal = _GJ_apiURL + argument0 + _GJ_apiURL_gameStr;

md5_begin();
md5_read_string(retVal + _GJ_privateKey);
md5_end();

return retVal + "&signature=" + md5_result();

#define GJ_make_userMap
var dataString, userID, userType, data, userMap, curLineEnd, handle, newLine;
dataString = argument0;
newLine = chr(13)+chr(10);

if (string_length(dataString))
{
    curLineEnd = string_pos(newLine, dataString) + 1;
    userID = real(string_copy(dataString, 5, curLineEnd - 7));
    dataString = string_delete(dataString, 1, curLineEnd);
    
    if (ds_map_exists(_GJ_userMaps, userID))
    {
        userMap = ds_map_find_value(_GJ_userMaps, userID);
        
        if (argument1)
        {
            ds_map_replace(_GJ_userMaps, 0, userMap);
            _GJ_loggedInID = userID;
        }
        
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        curLineEnd = string_pos(newLine, dataString);
        if (!curLineEnd) curLineEnd = string_length(dataString);
        dataString = string_delete(dataString, 1, curLineEnd + 1);
        
        if (string_pos('developer_name:"', dataString) == 1)
        {
            curLineEnd = string_pos(newLine, dataString);
            dataString = string_delete(dataString, 1, curLineEnd + 1);
            curLineEnd = string_pos(newLine, dataString);
            dataString = string_delete(dataString, 1, curLineEnd + 1);
            curLineEnd = string_pos(newLine, dataString);
            if (!curLineEnd) curLineEnd = string_length(dataString);
            dataString = string_delete(dataString, 1, curLineEnd + 1);
        }
    } else {
        userMap = ds_map_create();
        ds_map_add(_GJ_userMaps, userID, userMap);
        ds_map_add(userMap, "avatar", noone);
        
        if (argument1)
        {
            ds_map_replace(_GJ_userMaps, 0, userMap);
            _GJ_loggedInID = userID;
        }
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 7, curLineEnd - 9);
        dataString = string_delete(dataString, 1, curLineEnd);
        
            switch (data)
            {
                case "Moderator":
                    ds_map_add(userMap, "isModerator", true);
                    ds_map_add(userMap, "isAdministrator", false);
                    break;
                    
                case "Administrator":
                    ds_map_add(userMap, "isModerator", false);
                    ds_map_add(userMap, "isAdministrator", true);
                    break;
            }
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 11, curLineEnd - 13);
        dataString = string_delete(dataString, 1, curLineEnd);
            ds_map_add(userMap, "userName", data);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 13, curLineEnd - 15);
        dataString = string_delete(dataString, 1, curLineEnd);
            handle = httprequest_create();
            httprequest_connect(handle, data, false);
            ds_list_add(_GJ_apiHTTP_requests, 4);
            ds_list_add(_GJ_apiHTTP_requests, 60);
            ds_list_add(_GJ_apiHTTP_requests, handle);
            ds_list_add(_GJ_apiHTTP_requests, userID);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 12, curLineEnd - 14);
        dataString = string_delete(dataString, 1, curLineEnd);
            ds_map_add(userMap, "memberAge", data);
    
        curLineEnd = string_pos(newLine, dataString) + 1;
        data = string_copy(dataString, 17, curLineEnd - 19);
        dataString = string_delete(dataString, 1, curLineEnd);
            ds_map_add(userMap, "lastLogIn", data);
        
        curLineEnd = string_pos(newLine, dataString) + 1;
        if (!curLineEnd) curLineEnd = string_length(dataString) + 1;
        data = string_copy(dataString, 9, curLineEnd - 11);
        dataString = string_delete(dataString, 1, curLineEnd);
            ds_map_add(userMap, "banned", (data == "Banned"));
        
        if (string_pos('developer_name:"', dataString) == 1)
        {
            ds_map_add(userMap, "isDeveloper", true);
            ds_map_add(userMap, "isGamer", false);
            
            curLineEnd = string_pos(newLine, dataString) + 1;
            data = string_copy(dataString, 17, curLineEnd - 19);
            dataString = string_delete(dataString, 1, curLineEnd);
                ds_map_add(userMap, "devName", data);
        
            curLineEnd = string_pos(newLine, dataString) + 1;
            data = string_copy(dataString, 20, curLineEnd - 22);
            dataString = string_delete(dataString, 1, curLineEnd);
                ds_map_add(userMap, "devSite", data);
        
            curLineEnd = string_pos(newLine, dataString) + 1;
            if (!curLineEnd) curLineEnd = string_length(dataString) + 1;
            data = string_copy(dataString, 24, curLineEnd - 26);
            dataString = string_delete(dataString, 1, curLineEnd);
                ds_map_add(userMap, "devDesc", string_replace_all(data, '\"', '"'));
        } else {
            ds_map_add(userMap, "isDeveloper", false);
            ds_map_add(userMap, "isGamer", true);
        }
    }
    
    GJ_make_userMap(dataString, false);
}

#define GJ_autoLogin
var p, inputData, userName, userToken, validInput, retVal;

if (!_GJ_begun || _GJ_loggedIn)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    validInput = 0;
    
    for (p = 1; p <= parameter_count() && validInput != 3; p+= 1)
    {
        inputData = parameter_string(p);
        
        if (!(validInput & 1))
        {
            if (string_pos("gjapi_username:", inputData) == 1)
            {
                userName = string_delete(inputData, 1, 15);
                validInput|= 1;
            }
        }
        
        if (!(validInput & 2))
        {
            if (string_pos("gjapi_token:", inputData) == 1)
            {
                userToken = string_delete(inputData, 1, 12);
                validInput|= 2;
            }
        }
    }
    
    if (validInput != 3)
    {
        if (file_exists("gjapi-credentials.txt"))
        {
            inputData = file_text_open_read("gjapi-credentials.txt");
            userName = file_text_read_string(inputData);
            file_text_readln(inputData);
            userToken = file_text_read_string(inputData);
            file_text_close(inputData);
        }
    }
    
    if (validInput == 3)
    {
        retVal = GJ_login(userName, userToken);
    } else {
        retVal = GJ_STATUS_REQUEST_FAILED;
    }
}

return retVal;

#define GJ_awaitResult
var retVal;
retVal = 0;

while (retVal < 4)
{
    httprequest_update(argument0);
    retVal = httprequest_get_state(argument0);
}

return retVal;

#define GJ_fileCondense
var retVal, targetFile, newLine;
targetFile = file_text_open_read(string(argument0));
retVal = file_text_read_string(targetFile);
newLine = chr(13)+chr(10);

while (!file_text_eof(targetFile))
{
    file_text_readln(targetFile);
    retVal+= newLine + file_text_read_string(targetFile);
}

file_text_close(targetFile);
return retVal;

#define GJ_getCallResult
var retVal;

httprequest_get_message_body_buffer(argument0, _GJ_tempBuffer);
retVal = buffer_to_string(_GJ_tempBuffer);
buffer_clear(_GJ_tempBuffer);

return retVal;

#define GJ_newError
var retVal;

if (string_pos('success:"false"', argument0) == 1)
{
    ds_list_insert(_GJ_errorLog, 0, string_delete(string_copy(argument0, 1, string_length(argument0) - 1), 1, 26));
    retVal = GJ_STATUS_OK;
} else if (string_pos("FAILURE", argument0) == 1) {
    ds_list_insert(_GJ_errorLog, 0, string_delete(argument0, 1, 9));
    retVal = GJ_STATUS_OK;
} else {
    retVal = GJ_STATUS_INVALID_INPUT;
}

return retVal;

#define GJ_data_global_exists
var retVal, key;
key = string(argument0);

retVal = ds_map_exists(_GJ_globalData, key);

return retVal;

#define GJ_data_global_getReal
var retVal, key;
key = string(argument0);

if (ds_map_exists(_GJ_globalData, key))
{
    retVal = ds_map_find_value(_GJ_globalData, key);
    
    if (is_string(retVal))
    {
        retVal = real(retVal);
        ds_map_replace(_GJ_globalData, key, retVal);
    }
} else {
    retVal = 0;
}

return retVal;

#define GJ_data_global_getString
var retVal, key;
key = string(argument0);

if (ds_map_exists(_GJ_globalData, key))
{
    retVal = ds_map_find_value(_GJ_globalData, key);
    
    if (is_real(retVal))
    {
        retVal = string(retVal);
        ds_map_replace(_GJ_globalData, key, retVal);
    }
} else {
    retVal = "";
}

return retVal;

#define GJ_data_global_key_count
var retVal;

retVal = ds_list_size(_GJ_globalKeys);

return retVal;

#define GJ_data_global_key_find
var retVal;

retVal = ds_list_find_index(_GJ_globalKeys, argument0);

return retVal;

#define GJ_data_global_key_get
var retVal;

if (argument0 < 0 || argument0 >= ds_list_size(_GJ_globalKeys))
{
    retVal = "";
} else {
    retVal = ds_list_find_value(_GJ_globalKeys, argument0);
}

return retVal;

#define GJ_data_global_set
var key;
key = string(argument0);

if (ds_map_exists(_GJ_globalData, key))
{
    ds_map_replace(_GJ_globalData, key, argument1);
} else {
    ds_map_add(_GJ_globalData, key, argument1);
}

if (ds_list_find_index(_GJ_globalKeys, key) == -1)
{
    ds_list_add(_GJ_globalKeys, key);
}

#define GJ_data_user_exists
var retVal, key;
key = string(argument0);

if (_GJ_loggedIn)
{
    retVal = ds_map_exists(_GJ_userData, key);
} else {
    retVal = false;
}

return retVal;

#define GJ_data_user_getReal
var retVal, key;
key = string(argument0);

if (_GJ_loggedIn && ds_map_exists(_GJ_userData, key))
{
    retVal = ds_map_find_value(_GJ_userData, key);
    
    if (is_string(retVal))
    {
        retVal = real(retVal);
        ds_map_replace(_GJ_userData, key, retVal);
    }
} else {
    retVal = 0;
}

return retVal;

#define GJ_data_user_getString
var retVal, key;
key = string(argument0);

if (_GJ_loggedIn && ds_map_exists(_GJ_userData, key))
{
    retVal = ds_map_find_value(_GJ_userData, key);
    
    if (is_real(retVal))
    {
        retVal = string(retVal);
        ds_map_replace(_GJ_userData, key, retVal);
    }
} else {
    retVal = "";
}

return retVal;

#define GJ_data_user_key_count
var retVal;

if (_GJ_loggedIn)
{
    retVal = ds_list_size(_GJ_userKeys);
} else {
    retVal = 0;
}

return retVal;

#define GJ_data_user_key_find
var retVal;

if (_GJ_loggedIn)
{
    retVal = ds_list_find_index(_GJ_userKeys, argument0);
} else {
    retVal = -1;
}

return retVal;

#define GJ_data_user_key_get
var retVal;

if (_GJ_loggedIn && (argument0 < 0 || argument0 >= ds_list_size(_GJ_userKeys)))
{
    retVal = "";
} else {
    retVal = ds_list_find_value(_GJ_userKeys, argument0);
}

return retVal;

#define GJ_data_user_set
var key, retVal;
key = string(argument0);

if (_GJ_loggedIn)
{
    if (ds_map_exists(_GJ_userData, key))
    {
        ds_map_replace(_GJ_userData, key, argument1);
    } else {
        ds_map_add(_GJ_userData, key, argument1);
    }
    
    if (ds_list_find_index(_GJ_userKeys, key) == -1)
    {
        ds_list_add(_GJ_userKeys, key);
    }
    
    retVal = GJ_STATUS_OK;
} else {
    retVal = GJ_STATUS_INVALID_CALL;
}

return retVal;

#define GJ_remove_globalData
var retVal, url, handle;

if (!_GJ_begun)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    handle = httprequest_create();
    url = GJ_make_url("data-store/remove/?format=dump&key=" + key + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_dataRemoval(handle, key, false);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 56);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_remove_userData
var retVal, url, handle;

if (!_GJ_loggedIn)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    handle = httprequest_create();
    url = GJ_make_url("data-store/remove/?format=dump&key=" + key + "&" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_dataRemoval(handle, key, true);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 57);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_table_size
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = 0;
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");

    if (list == noone)
    {
        retVal = 0;
    } else {
        retVal = ds_list_size(list);
    }
}

return retVal;

#define GJ_table_user_size
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = 0;
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "userScores");

    if (list == noone)
    {
        retVal = 0;
    } else {
        retVal = ds_list_size(list);
    }
}

return retVal;

#define GJ_tableScore_getExtraData
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = "N/A";
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");
    
    if (list == noone)
    {
        retVal = "N/A";
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = "N/A";
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "extra");
    }
}

return retVal;

#define GJ_tableScore_getGuestName
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = "N/A";
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");
    
    if (list == noone)
    {
        retVal = "N/A";
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = "N/A";
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "guestName");
    }
}

return retVal;

#define GJ_tableScore_getScoreName
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = "N/A";
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");
    
    if (list == noone)
    {
        retVal = "N/A";
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = "N/A";
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "score");
    }
}

return retVal;

#define GJ_tableScore_getSortValue
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = 0;
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");
    
    if (list == noone)
    {
        retVal = 0;
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = 0;
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "sort");
    }
}

return retVal;

#define GJ_tableScore_getUserID
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = -1;
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");
    
    if (list == noone)
    {
        retVal = -1;
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = -1;
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "userID");
    }
}

return retVal;

#define GJ_tableScore_getUserName
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = "N/A";
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");
    
    if (list == noone)
    {
        retVal = "N/A";
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = "N/A";
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "userName");
    }
}

return retVal;

#define GJ_tableScore_isGuestScore
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = false;
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");
    
    if (list == noone)
    {
        retVal = false;
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = false;
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "isGuestScore");
    }
}

return retVal;

#define GJ_tableScore_isUserScore
var retVal, list;

if (!_GJ_begun || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = false;
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "scores");
    
    if (list == noone)
    {
        retVal = false;
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = false;
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "isUserScore");
    }
}

return retVal;

#define GJ_tableScore_user_getExtraData
var retVal, list;

if (!_GJ_loggedIn || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = "N/A";
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "userScores");
    
    if (list == noone)
    {
        retVal = "N/A";
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = "N/A";
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "extra");
    }
}

return retVal;

#define GJ_tableScore_user_getScoreName
var retVal, list;

if (!_GJ_loggedIn || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = "N/A";
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "userScores");
    
    if (list == noone)
    {
        retVal = "N/A";
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = "N/A";
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "score");
    }
}

return retVal;

#define GJ_tableScore_user_getSortValue
var retVal, list;

if (!_GJ_loggedIn || _GJ_tablesLoaded != 2 || !is_real(argument1) || !ds_map_exists(_GJ_scoreTables, argument0))
{
    retVal = 0;
} else {
    list = ds_map_find_value(ds_map_find_value(_GJ_scoreTables, argument0), "userScores");
    
    if (list == noone)
    {
        retVal = 0;
    } else if (argument1 < 1 || argument1 > ds_list_size(list)) {
        retVal = 0;
    } else {
        retVal = ds_map_find_value(ds_list_find_value(list, argument1 - 1), "sort");
    }
}

return retVal;

#define GJ_tablesReady
var retVal;

retVal = (_GJ_tablesLoaded == 2);

return retVal;

#define GJ_isActive
var retVal;

if (_GJ_loggedIn)
{
    retVal = _GJ_isActive;
} else {
    retVal = false;
}

return retVal;

#define GJ_session_close
var retVal, handle, url;

if (!_GJ_loggedIn || !_GJ_sessionOpen)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    _GJ_sessionClock = noone;
    _GJ_sessionOpen = false;

    handle = httprequest_create();
    url = GJ_make_url("sessions/close/?format=dump&" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (GJ_awaitResult(handle) == 5)
    {
        retVal = GJ_STATUS_REQUEST_FAILED;
    } else {
        retVal = GJ_handle_default(handle);
    }
}

return retVal;

#define GJ_session_open
var retVal, url, handle;

if (_GJ_sessionOpen || !_GJ_loggedIn)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("sessions/open/?format=dump&" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    
    ds_list_add(_GJ_apiHTTP_requests, 3);
    ds_list_add(_GJ_apiHTTP_requests, 20);
    ds_list_add(_GJ_apiHTTP_requests, handle);
    _GJ_sessionClock = noone;
    
    retVal = GJ_STATUS_OK;
}

return retVal;

#define GJ_session_ping
var retVal, url, handle;

if (!_GJ_sessionOpen || !_GJ_loggedIn)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = "sessions/ping/?format=dump&" + _GJ_apiURL_userStr + "&";
    
    if (_GJ_isActive)
    {
        url+= "status=active&";
    } else {
        url+= "status=idle&";
    }
    
    url = GJ_make_url(url);
    httprequest_connect(handle, url, false);
    
    ds_list_add(_GJ_apiHTTP_requests, 3);
    ds_list_add(_GJ_apiHTTP_requests, 21);
    ds_list_add(_GJ_apiHTTP_requests, handle);
    
    _GJ_sessionClock = noone;
    retVal = GJ_STATUS_OK;
}

return retVal;

#define GJ_setActive
var retVal;

if (!_GJ_loggedIn || !_GJ_sessionOpen)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    _GJ_isActive = (argument0 == true);
    retVal = GJ_STATUS_OK;
}

return retVal;

#define GJ_setPingRate
var retVal;

if (!_GJ_loggedIn || !_GJ_sessionOpen)
{
    retVal = GJ_STATUS_INVALID_CALL;
} else if (argument0 <= 0) {
    retVal = GJ_STATUS_INVALID_INPUT;
} else {
    _GJ_session_pingRate = argument0;
    retVal = GJ_STATUS_OK;
}

return retVal;

#define GJ_store_globalData
var retVal, handle, url;

if (!ds_map_exists(_GJ_globalData, argument1))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("data-store/set/?format=dump&key=" + string(argument1) + "&");
    httprequest_set_post_parameter(handle, "data", string(ds_map_find_value(_GJ_globalData, argument1)));
    httprequest_connect(handle, url, true);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_storage(handle, argument1, false);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 58);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_store_globalFile
var retVal, url, handle;

if (!file_exists(argument2))
{
    return GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    return GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("data-store/set/?format=dump&key=" + string(argument1) + "&");
    httprequest_set_post_parameter(handle, "data", GJ_fileCondense(argument2));
    httprequest_connect(handle, url, true);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_storage(handle, argument1, false);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 58);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_store_guestScore
var retVal, handle, url;

if (!is_real(argument1) || !is_real(argument4) || !string_length(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun || !ds_map_exists(_GJ_scoreTables, argument1)) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = "scores/add/?guest=" +string(argument2)+ "&score=" +string(argument3)+ "&sort=" +string(argument4)+ "&extra_data=" +string(argument5)+ "&";
    
    if (argument1)
    {
        url+= "table_id=" +string(argument1)+ "&";
    }
    
    url = GJ_make_url(url);
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_default(handle);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 3);
        ds_list_add(_GJ_apiHTTP_requests, 44);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_store_score
var retVal, url, handle;

if (!is_real(argument1) || !is_real(argument3) || !ds_map_exists(_GJ_scoreTables, argument1))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_loggedIn || !_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = "scores/add/?score="+string(argument2)+"&sort="+string(argument3)+"&extra_data="+string(argument4)+"&"+_GJ_apiURL_userStr+"&";
    
    if (argument1 != 0)
    {
        url+= "table_id="+string(argument1)+"&";
    }
    
    url = GJ_make_url(url);
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_default(handle);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 3);
        ds_list_add(_GJ_apiHTTP_requests, 43);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_store_trophyEarned
var retVal, handle, url;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2) {
    retVal = GJ_STATUS_INVALID_CALL;
} else if (!is_real(argument1) || !ds_map_exists(_GJ_trophyMaps, argument1)) {
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument1), "isAchieved")) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("trophies/add-achieved/?format=dump&trophy_id=" + string(argument1) + "&" + _GJ_apiURL_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_trophyAchieve(handle, argument1);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 31);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_store_userData
var retVal, handle, url;

if (!ds_map_exists(_GJ_userData, argument1))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_loggedIn) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("data-store/set/?format=dump&key=" + string(argument1) + "&" + _GJ_apiURL_userStr + "&");
    httprequest_set_post_parameter(handle, "data", string(ds_map_find_value(_GJ_userData, argument1)));
    httprequest_connect(handle, url, true);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_storage(handle, argument1, true);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 59);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_store_userFile
var retVal, url, handle;

if (!file_exists(argument2))
{
    return GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_loggedIn) {
    return GJ_STATUS_INVALID_CALL;
} else {
    handle = httprequest_create();
    url = GJ_make_url("data-store/set/?format=dump&key=" + string(argument1) + "&" + _GJ_apiURL_userStr + "&");
    httprequest_set_post_parameter(handle, "data", GJ_fileCondense(argument2));
    httprequest_connect(handle, url, true);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_storage(handle, argument1, true);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 59);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, argument1);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_trophiesReady
var retVal;

retVal = (_GJ_trophiesLoaded == 2);

return retVal;

#define GJ_trophy_getDescription
var retVal;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "description");
}

return retVal;

#define GJ_trophy_getImage
var retVal;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = noone;
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "image");
}

return retVal;

#define GJ_trophy_getTimeAchieved
var retVal;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "timeAchieved");
}

return retVal;

#define GJ_trophy_getTitle
var retVal;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "title");
}

return retVal;

#define GJ_trophy_isAchieved
var retVal;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = false;
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "isAchieved");
}

return retVal;

#define GJ_trophy_isBronze
var retVal;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = false;
} else {
    retVal = (ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "difficulty") == 0);
}

return retVal;

#define GJ_trophy_isGold
var retVal;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = false;
} else {
    retVal = (ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "difficulty") == 2);
}

return retVal;

#define GJ_trophy_isPlatinum
var retVal, map;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = false;
} else {
    retVal = (ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "difficulty") == 3);
}

return retVal;

#define GJ_trophy_isSilver
var retVal;

if (!_GJ_loggedIn || _GJ_trophiesLoaded != 2 || !ds_map_exists(_GJ_trophyMaps, argument0))
{
    retVal = false;
} else {
    retVal = (ds_map_find_value(ds_map_find_value(_GJ_trophyMaps, argument0), "difficulty") == 1);
}

return retVal;

#define GJ_update_globalData_add
var retVal, url, handle, value;

if (!is_real(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = string(argument2);
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=add&value=" + value + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_globalData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 52);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_globalData_append
var retVal, url, handle, value;

if (!is_string(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = argument2;
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=append&value=" + value + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_globalData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 52);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_globalData_divide
var retVal, url, handle, value;

if (!is_real(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = string(argument2);
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=divide&value=" + value + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_globalData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 52);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_globalData_multiply
var retVal, url, handle, value;

if (!is_real(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = string(argument2);
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=multiply&value=" + value + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_globalData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 52);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_globalData_prepend
var retVal, url, handle, value;

if (!is_string(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = argument2;
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=prepend&value=" + value + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_globalData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 52);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_globalData_subtract
var retVal, url, handle, value;

if (!is_real(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = string(argument2);
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=subtract&value=" + value + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_globalData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 52);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_userData_add
var retVal, url, handle, value;

if (!is_real(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = string(argument2);
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=add&value=" + value + "&" + _GJ_apiHTTP_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 53);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_userData_append
var retVal, url, handle, value;

if (!is_string(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = argument2;
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=append&value=" + value + "&" + _GJ_apiHTTP_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 53);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_userData_divide
var retVal, url, handle, value;

if (!is_real(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = string(argument2);
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=divide&value=" + value + "&" + _GJ_apiHTTP_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 53);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_userData_multiply
var retVal, url, handle, value;

if (!is_real(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = string(argument2);
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=multiply&value=" + value + "&" + _GJ_apiHTTP_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 53);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_userData_prepend
var retVal, url, handle, value;

if (!is_string(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = argument2;
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=prepend&value=" + value + "&" + _GJ_apiHTTP_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 53);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_update_userData_subtract
var retVal, url, handle, value;

if (!is_real(argument2))
{
    retVal = GJ_STATUS_INVALID_INPUT;
} else if (!_GJ_begun) {
    retVal = GJ_STATUS_INVALID_CALL;
} else {
    key = string(argument1);
    value = string(argument2);
    handle = httprequest_create();
    url = GJ_make_url("data-store/update/?format=dump&key=" + key + "&operation=subtract&value=" + value + "&" + _GJ_apiHTTP_userStr + "&");
    httprequest_connect(handle, url, false);
    
    if (argument0)
    {
        if (GJ_awaitResult(handle) == 4)
        {
            retVal = GJ_handle_userData(handle, key);
        } else {
            retVal = GJ_STATUS_NETWORK_ERROR;
        }
        
        httprequest_destroy(handle);
    } else {
        ds_list_add(_GJ_apiHTTP_requests, 4);
        ds_list_add(_GJ_apiHTTP_requests, 53);
        ds_list_add(_GJ_apiHTTP_requests, handle);
        ds_list_add(_GJ_apiHTTP_requests, key);
        
        retVal = GJ_STATUS_OK;
    }
}

return retVal;

#define GJ_user_getAvatar
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = noone;
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "avatar");
}

return retVal;

#define GJ_user_getDevDescription
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "devDesc");
}

return retVal;

#define GJ_user_getDevName
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "devName");
}

return retVal;

#define GJ_user_getDevWebsite
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "devSite");
}

return retVal;

#define GJ_user_getLastLogIn
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "lastLogIn");
}

return retVal;

#define GJ_user_getLoggedID
var retVal;

retVal = _GJ_loggedInID;

return retVal;

#define GJ_user_getMemberAge
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "memberAge");
}

return retVal;

#define GJ_user_getName
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = "N/A";
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "userName");
}

return retVal;

#define GJ_user_isAdministrator
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = false;
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "isAdministrator");
}

return retVal;

#define GJ_user_isBanned
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = false;
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "banned");
}

return retVal;

#define GJ_user_isDeveloper
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = false;
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "isDeveloper");
}

return retVal;

#define GJ_user_isGamer
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = false;
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "isGamer");
}

return retVal;

#define GJ_user_isModerator
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = false;
} else {
    retVal = ds_map_find_value(ds_map_find_value(_GJ_userMaps, argument0), "isModerator");
}

return retVal;

#define GJ_user_isReady
var retVal;

if (!_GJ_begun || !ds_map_exists(_GJ_userMaps, argument0))
{
    retVal = false;
} else {
    retVal = true;
}

return retVal;

