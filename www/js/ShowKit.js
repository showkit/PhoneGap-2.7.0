var ShowKit = {
    
    initializeShowKit: function (apiKey)
    {
        cordova.exec(null,null,"ShowKitPlugin","initializeShowKit",[apiKey]);
    }
    ,
    
    registerUser: function (callBack, username, password)
    {
        cordova.exec(callBack,callBack,"ShowKitPlugin","registerUser",[username, password]);
    }
    ,
    
    login: function (username, password)
    {
        cordova.exec(null,null,"ShowKitPlugin","login",[username, password]);
    }
    ,
    
    loginWithCompletion: function (callBack, username, password)
    {
        cordova.exec(callBack,callBack,"ShowKitPlugin","login",[username, password]);
    }
    ,
    
    initiateCallWithUser: function (username)
    {
        cordova.exec(null,null,"ShowKitPlugin","initiateCallWithUser",[username]);
    }
    ,
    
    acceptCall: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","acceptCall",[null]);
    }
    ,
    
    rejectCall: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","rejectCall",[null]);
    }
    ,
    
    logout: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","logout",[null]);
    }
    ,
    
    setDeviceTorch: function (state)
    {
        cordova.exec(null,null,"ShowKitPlugin","setDeviceTorch",[state]);
    }
    ,
    
    presentModalViewController: function (nibName)
    {
        cordova.exec(null,null,"ShowKitPlugin","presentModalViewController",[nibName]);
    }
    ,
    
    enableConnectionStatusChangedNotification: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","enableConnectionStatusChangedNotification",[null]);
    }
    ,
    
    disableConnectionStatusChangedNotification: function ()
    {
        cordova.exec(null,null,"ShowKitPlugin","disableConnectionStatusChangedNotification",[null]);
    }    
    ,
    
    setState: function (key, value)
    {
        cordova.exec(null,null,"ShowKitPlugin","setState",[key, value]);
    }
    ,
    
    getState: function (callBack,key)
    {
        cordova.exec(callBack,callBack,"ShowKitPlugin","getState",[key]);
    }
    ,
    
    parseConnectionState: function (array)
    {
        var state=new Object();
        state.value = array[0];
        state.callerUsername=array[1];
        state.errorCode = array[2];
        state.error = array[3];
        
//        console.log("array="+array);
        return state;
    }
    
};