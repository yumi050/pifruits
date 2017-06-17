function dv_rolloutManager(handlersDefsArray, baseHandler) {
    this.handle = function () {
        var errorsArr = [];

        var handler = chooseEvaluationHandler(handlersDefsArray);
        if (handler) {
            var errorObj = handleSpecificHandler(handler);
            if (errorObj === null) {
                return errorsArr;
            }
            else {
                var debugInfo = handler.onFailure();
                if (debugInfo) {
                    for (var key in debugInfo) {
                        if (debugInfo.hasOwnProperty(key)) {
                            if (debugInfo[key] !== undefined || debugInfo[key] !== null) {
                                errorObj[key] = encodeURIComponent(debugInfo[key]);
                            }
                        }
                    }
                }
                errorsArr.push(errorObj);
            }
        }

        var errorObjHandler = handleSpecificHandler(baseHandler);
        if (errorObjHandler) {
            errorObjHandler['dvp_isLostImp'] = 1;
            errorsArr.push(errorObjHandler);
        }
        return errorsArr;
    };

    function handleSpecificHandler(handler) {
        var url;
        var errorObj = null;

        try {
            url = handler.createRequest();
            if (url) {
                if (!handler.sendRequest(url)) {
                    errorObj = createAndGetError('sendRequest failed.',
                        url,
                        handler.getVersion(),
                        handler.getVersionParamName(),
                        handler.dv_script);
                }
            } else {
                errorObj = createAndGetError('createRequest failed.',
                    url,
                    handler.getVersion(),
                    handler.getVersionParamName(),
                    handler.dv_script,
                    handler.dvScripts,
                    handler.dvStep,
                    handler.dvOther
                );
            }
        }
        catch (e) {
            errorObj = createAndGetError(e.name + ': ' + e.message, url, handler.getVersion(), handler.getVersionParamName(), (handler ? handler.dv_script : null));
        }

        return errorObj;
    }

    function createAndGetError(error, url, ver, versionParamName, dv_script, dvScripts, dvStep, dvOther) {
        var errorObj = {};
        errorObj[versionParamName] = ver;
        errorObj['dvp_jsErrMsg'] = encodeURIComponent(error);
        if (dv_script && dv_script.parentElement && dv_script.parentElement.tagName && dv_script.parentElement.tagName == 'HEAD') {
            errorObj['dvp_isOnHead'] = '1';
        }
        if (url) {
            errorObj['dvp_jsErrUrl'] = url;
        }
        if (dvScripts) {
            var dvScriptsResult = '';
            for (var id in dvScripts) {
                if (dvScripts[id] && dvScripts[id].src) {
                    dvScriptsResult += encodeURIComponent(dvScripts[id].src) + ":" + dvScripts[id].isContain + ",";
                }
            }
            
           
           
        }
        return errorObj;
    }

    function chooseEvaluationHandler(handlersArray) {
        var config = window._dv_win.dv_config;
        var index = 0;
        var isEvaluationVersionChosen = false;
        if (config.handlerVersionSpecific) {
            for (var i = 0; i < handlersArray.length; i++) {
                if (handlersArray[i].handler.getVersion() == config.handlerVersionSpecific) {
                    isEvaluationVersionChosen = true;
                    index = i;
                    break;
                }
            }
        }
        else if (config.handlerVersionByTimeIntervalMinutes) {
            var date = config.handlerVersionByTimeInputDate || new Date();
            var hour = date.getUTCHours();
            var minutes = date.getUTCMinutes();
            index = Math.floor(((hour * 60) + minutes) / config.handlerVersionByTimeIntervalMinutes) % (handlersArray.length + 1);
            if (index != handlersArray.length) { 
                isEvaluationVersionChosen = true;
            }
        }
        else {
            var rand = config.handlerVersionRandom || (Math.random() * 100);
            for (var i = 0; i < handlersArray.length; i++) {
                if (rand >= handlersArray[i].minRate && rand < handlersArray[i].maxRate) {
                    isEvaluationVersionChosen = true;
                    index = i;
                    break;
                }
            }
        }

        if (isEvaluationVersionChosen == true && handlersArray[index].handler.isApplicable()) {
            return handlersArray[index].handler;
        }
        else {
            return null;
        }
    }    
}

function getCurrentTime() {
    "use strict";
    if (Date.now) {
        return Date.now();
    }
    return (new Date()).getTime();
}

function doesBrowserSupportHTML5Push() {
    "use strict";
    return typeof window.parent.postMessage === 'function' && window.JSON;
}

function dv_GetParam(url, name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS, 'i');
    var results = regex.exec(url);
    if (results == null) {
        return null;
    }
    else {
        return results[1];
    }
}

function dv_GetKeyValue(url) {
    var keyReg = new RegExp(".*=");
    var keyRet = url.match(keyReg)[0];
    keyRet = keyRet.replace("=", "");

    var valReg = new RegExp("=.*");
    var valRet = url.match(valReg)[0];
    valRet = valRet.replace("=", "");

    return {key: keyRet, value: valRet};
}

function dv_Contains(array, obj) {
    var i = array.length;
    while (i--) {
        if (array[i] === obj) {
            return true;
        }
    }
    return false;
}

function dv_GetDynamicParams(url, prefix) {
    try {
        prefix = (prefix != undefined && prefix != null) ? prefix : 'dvp';
        var regex = new RegExp("[\\?&](" + prefix + "_[^&]*=[^&#]*)", "gi");
        var dvParams = regex.exec(url);

        var results = [];
        while (dvParams != null) {
            results.push(dvParams[1]);
            dvParams = regex.exec(url);
        }
        return results;
    }
    catch (e) {
        return [];
    }
}

function dv_createIframe() {
    var iframe;
    if (document.createElement && (iframe = document.createElement('iframe'))) {
        iframe.name = iframe.id = 'iframe_' + Math.floor((Math.random() + "") * 1000000000000);
        iframe.width = 0;
        iframe.height = 0;
        iframe.style.display = 'none';
        iframe.src = 'about:blank';
    }

    return iframe;
}

function dv_GetRnd() {
    return ((new Date()).getTime() + "" + Math.floor(Math.random() * 1000000)).substr(0, 16);
}

function dv_SendErrorImp(serverUrl, errorsArr) {

    for (var j = 0; j < errorsArr.length; j++) {
        var errorObj = errorsArr[j];
        var errorImp = dv_CreateAndGetErrorImp(serverUrl, errorObj);
        dv_sendImgImp(errorImp);
    }
}

function dv_CreateAndGetErrorImp(serverUrl, errorObj) {
    var errorQueryString = '';
    for (var key in errorObj) {
        if (errorObj.hasOwnProperty(key)) {
            if (key.indexOf('dvp_jsErrUrl') == -1) {
                errorQueryString += '&' + key + '=' + errorObj[key];
            } else {
                var params = ['ctx', 'cmp', 'plc', 'sid'];
                for (var i = 0; i < params.length; i++) {
                    var pvalue = dv_GetParam(errorObj[key], params[i]);
                    if (pvalue) {
                        errorQueryString += '&dvp_js' + params[i] + '=' + pvalue;
                    }
                }
            }
        }
    }

    var windowProtocol = 'https:';
    var sslFlag = '&ssl=1';

    var errorImp = windowProtocol + '//' + serverUrl + sslFlag + errorQueryString;
    return errorImp;
}

function dv_sendImgImp(url) {
    (new Image()).src = url;
}

function dv_getPropSafe(obj, propName) {
    try {
        if (obj) {
            return obj[propName];
        }
    } catch (e) {
    }
}

function dvType() {
    var that = this;
    var eventsForDispatch = {};
    this.t2tEventDataZombie = {};

    this.processT2TEvent = function (data, tag) {
        try {
            if (tag.ServerPublicDns) {
                var tpsServerUrl = tag.dv_protocol + '//' + tag.ServerPublicDns + '/event.gif?impid=' + tag.uid;

                if (!tag.uniquePageViewId) {
                    tag.uniquePageViewId = data.uniquePageViewId;
                }

                tpsServerUrl += '&upvid=' + tag.uniquePageViewId;
                $dv.domUtilities.addImage(tpsServerUrl, tag.tagElement.parentElement);
            }
        } catch (e) {
            try {
                dv_SendErrorImp(window._dv_win.dv_config.tpsErrAddress + '/visit.jpg?ctx=818052&cmp=1619415&dvtagver=6.1.src&jsver=0&dvp_ist2tProcess=1', {dvp_jsErrMsg: encodeURIComponent(e)});
            } catch (ex) {
            }
        }
    };

    this.processTagToTagCollision = function (collision, tag) {
        var i;
        for (i = 0; i < collision.eventsToFire.length; i++) {
            this.pubSub.publish(collision.eventsToFire[i], tag.uid);
        }
        var tpsServerUrl = tag.dv_protocol + '//' + tag.ServerPublicDns + '/event.gif?impid=' + tag.uid;
        tpsServerUrl += '&colltid=' + collision.allReasonsForTagBitFlag;

        for (i = 0; i < collision.reasons.length; i++) {
            var reason = collision.reasons[i];
            tpsServerUrl += '&' + reason.name + "ms=" + reason.milliseconds;
        }

        if (collision.thisTag) {
            tpsServerUrl += '&tlts=' + collision.thisTag.t2tLoadTime;
        }
        if (tag.uniquePageViewId) {
            tpsServerUrl += '&upvid=' + tag.uniquePageViewId;
        }
        $dv.domUtilities.addImage(tpsServerUrl, tag.tagElement.parentElement);
    };

    this.processBSIdFound = function (bsID, tag) {
        var tpsServerUrl = tag.dv_protocol + '//' + tag.ServerPublicDns + '/event.gif?impid=' + tag.uid;
        tpsServerUrl += '&bsimpid=' + bsID;
        if (tag.uniquePageViewId) {
            tpsServerUrl += '&upvid=' + tag.uniquePageViewId;
        }
        $dv.domUtilities.addImage(tpsServerUrl, tag.tagElement.parentElement);
    };

    this.processBABSVerbose = function (verboseReportingValues, tag) {
        var queryString = "";
        


        var dvpPrepend = "&dvp_BABS_";
        queryString += dvpPrepend + 'NumBS=' + verboseReportingValues.bsTags.length;

        for (var i = 0; i < verboseReportingValues.bsTags.length; i++) {
            var thisFrame = verboseReportingValues.bsTags[i];

            queryString += dvpPrepend + 'GotCB' + i + '=' + thisFrame.callbackReceived;
            queryString += dvpPrepend + 'Depth' + i + '=' + thisFrame.depth;

            if (thisFrame.callbackReceived) {
                if (thisFrame.bsAdEntityInfo && thisFrame.bsAdEntityInfo.comparisonItems) {
                    for (var itemIndex = 0; itemIndex < thisFrame.bsAdEntityInfo.comparisonItems.length; itemIndex++) {
                        var compItem = thisFrame.bsAdEntityInfo.comparisonItems[itemIndex];
                        queryString += dvpPrepend + "tag" + i + "_" + compItem.name + '=' + compItem.value;
                    }
                }
            }
        }

        if (queryString.length > 0) {
            var tpsServerUrl = '';
            if (tag) {
                var tpsServerUrl = tag.dv_protocol + '//' + tag.ServerPublicDns + '/event.gif?impid=' + tag.uid;
            }
            var requestString = tpsServerUrl + queryString;
            $dv.domUtilities.addImage(requestString, tag.tagElement.parentElement);
        }
    };

    var messageEventListener = function (event) {
        try {
            var timeCalled = getCurrentTime();
            var data = window.JSON.parse(event.data);
            if (!data.action) {
                data = window.JSON.parse(data);
            }
            var myUID;
            var visitJSHasBeenCalledForThisTag = false;
            if ($dv.tags) {
                for (var uid in $dv.tags) {
                    if ($dv.tags.hasOwnProperty(uid) && $dv.tags[uid] && $dv.tags[uid].t2tIframeId === data.iFrameId) {
                        myUID = uid;
                        visitJSHasBeenCalledForThisTag = true;
                        break;
                    }
                }
            }

            var tag;
            switch (data.action) {
                case 'uniquePageViewIdDetermination':
                    if (visitJSHasBeenCalledForThisTag) {
                        $dv.processT2TEvent(data, $dv.tags[myUID]);
                        $dv.t2tEventDataZombie[data.iFrameId] = undefined;
                    }
                    else {
                        data.wasZombie = 1;
                        $dv.t2tEventDataZombie[data.iFrameId] = data;
                    }
                    break;
                case 'maColl':
                    tag = $dv.tags[myUID];
                    if (!tag.uniquePageViewId) {
                        tag.uniquePageViewId = data.uniquePageViewId;
                    }
                    data.collision.commonRecievedTS = timeCalled;
                    $dv.processTagToTagCollision(data.collision, tag);
                    break;
                case 'bsIdFound':
                    tag = $dv.tags[myUID];
                    if (!tag.uniquePageViewId) {
                        tag.uniquePageViewId = data.uniquePageViewId;
                    }
                    $dv.processBSIdFound(data.id, tag);
                    break;
                case 'babsVerbose':
                    try {
                        tag = $dv.tags[myUID];
                        $dv.processBABSVerbose(data, tag);
                    } catch (err) {
                    }
                    break;
            }

        } catch (e) {
            try {
                dv_SendErrorImp(window._dv_win.dv_config.tpsErrAddress + '/visit.jpg?ctx=818052&cmp=1619415&dvtagver=6.1.src&jsver=0&dvp_ist2tListener=1', {dvp_jsErrMsg: encodeURIComponent(e)});
            } catch (ex) {
            }
        }
    };

    if (window.addEventListener) {
        addEventListener("message", messageEventListener, false);
    }
    else {
        attachEvent("onmessage", messageEventListener);
    }

    this.pubSub = (function () {
        var previousEventsCapacity = 1000;
        var subscribers = {};       
        var eventsHistory = {};     
        var prerenderHistory = {};  
        return {
            subscribe: function (eventName, id, actionName, func) {
                handleHistoryEvents(eventName, id, func);
                if (!subscribers[eventName + id]) {
                    subscribers[eventName + id] = [];
                }
                subscribers[eventName + id].push({Func: func, ActionName: actionName});
            },

            publish: function (eventName, id, args) {
                var actionsResults = [];
                try {
                    if (eventName && id) {
                        if ($dv && $dv.tags[id] && $dv.tags[id].prndr) {
                            prerenderHistory[id] = prerenderHistory[id] || [];
                            prerenderHistory[id].push({eventName: eventName, args: args});
                        }
                        else {
                            actionsResults.push.apply(actionsResults, publishEvent(eventName, id, args));
                        }
                    }
                } catch (e) {
                }
                return actionsResults.join('&');
            },

            publishHistoryRtnEvent: function (id) {
                var actionsResults = [];
                if (prerenderHistory[id] instanceof Array) {
                    for (var i = 0; i < prerenderHistory[id].length; i++) {
                        var eventName = prerenderHistory[id][i].eventName;
                        var args = prerenderHistory[id][i].args;
                        if (eventName) {
                            actionsResults.push.apply(actionsResults, publishEvent(eventName, id, args));
                        }
                    }
                }

                prerenderHistory[id] = [];

                return actionsResults;
            }
        };

        function publishEvent(eventName, id, args) {
            var actionsResults = [];
            if (!eventsHistory[id]) {
                eventsHistory[id] = [];
            }
            if (eventsHistory[id].length < previousEventsCapacity) {
                eventsHistory[id].push({eventName: eventName, args: args});
            }
            if (subscribers[eventName + id] instanceof Array) {
                for (var i = 0; i < subscribers[eventName + id].length; i++) {
                    var funcObject = subscribers[eventName + id][i];
                    if (funcObject && funcObject.Func && typeof funcObject.Func == "function" && funcObject.ActionName) {
                        var isSucceeded = runSafely(function () {
                            return funcObject.Func(id, args);
                        });
                        actionsResults.push(encodeURIComponent(funcObject.ActionName) + '=' + (isSucceeded ? '1' : '0'));
                    }
                }
            }

            return actionsResults;
        }

        function handleHistoryEvents(eventName, id, func) {
            try {
                if (eventsHistory[id] instanceof Array) {
                    for (var i = 0; i < eventsHistory[id].length; i++) {
                        if (eventsHistory[id][i] && eventsHistory[id][i].eventName === eventName) {
                            func(id, eventsHistory[id][i].args);
                        }
                    }
                }
            } catch (e) {
            }
        }
    })();

    this.domUtilities = new function () {
        function getDefaultParent() {
            return document.body || document.head || document.documentElement;
        }

        this.createImage = function (parentElement) {
            parentElement = parentElement || getDefaultParent();
            var image = parentElement.ownerDocument.createElement("img");
            image.width = 0;
            image.height = 0;
            image.style.display = 'none';
            image.src = '';
            parentElement.insertBefore(image, parentElement.firstChild);
            return image;
        };

        var imgArr = [];
        var nextImg = 0;
        var imgArrCreated = false;
        if (!navigator.sendBeacon) {
            imgArr[0] = this.createImage();
            imgArr[1] = this.createImage();
            imgArrCreated = true;
        }

        this.addImage = function (url, parentElement, useGET, usePrerenderedImage) {
            parentElement = parentElement || getDefaultParent();
            if (!useGET && navigator.sendBeacon) {
                var message = appendCacheBuster(url);
                navigator.sendBeacon(message, {});
            } else {
                var image;
                if (usePrerenderedImage && imgArrCreated) {
                    image = imgArr[nextImg];
                    image.src = appendCacheBuster(url);
                    nextImg = (nextImg + 1) % imgArr.length;
                } else {
                    image = this.createImage(parentElement);
                    image.src = appendCacheBuster(url);
                    parentElement.insertBefore(image, parentElement.firstChild);
                }
            }
        };


        this.addScriptResource = function (url, parentElement) {
            parentElement = parentElement || getDefaultParent();
            var scriptElem = parentElement.ownerDocument.createElement("script");
            scriptElem.type = 'text/javascript';
            scriptElem.src = appendCacheBuster(url);
            parentElement.insertBefore(scriptElem, parentElement.firstChild);
        };

        this.addScriptCode = function (srcCode, parentElement) {
            parentElement = parentElement || getDefaultParent();
            var scriptElem = parentElement.ownerDocument.createElement("script");
            scriptElem.type = 'text/javascript';
            scriptElem.innerHTML = srcCode;
            parentElement.insertBefore(scriptElem, parentElement.firstChild);
        };

        this.addHtml = function (srcHtml, parentElement) {
            parentElement = parentElement || getDefaultParent();
            var divElem = parentElement.ownerDocument.createElement("div");
            divElem.style = "display: inline";
            divElem.innerHTML = srcHtml;
            parentElement.insertBefore(divElem, parentElement.firstChild);
        };
    };

    this.resolveMacros = function (str, tag) {
        var viewabilityData = tag.getViewabilityData();
        var viewabilityBuckets = viewabilityData && viewabilityData.buckets ? viewabilityData.buckets : {};
        var upperCaseObj = objectsToUpperCase(tag, viewabilityData, viewabilityBuckets);
        var newStr = str.replace('[DV_PROTOCOL]', upperCaseObj.DV_PROTOCOL);
        newStr = newStr.replace('[PROTOCOL]', upperCaseObj.PROTOCOL);
        newStr = newStr.replace(/\[(.*?)\]/g, function (match, p1) {
            var value = upperCaseObj[p1];
            if (value === undefined || value === null) {
                value = '[' + p1 + ']';
            }
            return encodeURIComponent(value);
        });
        return newStr;
    };

    this.settings = new function () {
    };

    this.tagsType = function () {
    };

    this.tagsPrototype = function () {
        this.add = function (tagKey, obj) {
            if (!that.tags[tagKey]) {
                that.tags[tagKey] = new that.tag();
            }
            for (var key in obj) {
                that.tags[tagKey][key] = obj[key];
            }
        };
    };

    this.tagsType.prototype = new this.tagsPrototype();
    this.tagsType.prototype.constructor = this.tags;
    this.tags = new this.tagsType();

    this.tag = function () {
    };

    this.tagPrototype = function () {
        this.set = function (obj) {
            for (var key in obj) {
                this[key] = obj[key];
            }
        };

        this.getViewabilityData = function () {
        };
    };

    this.tag.prototype = new this.tagPrototype();
    this.tag.prototype.constructor = this.tag;

    
    this.eventBus = (function () {
        var getRandomActionName = function () {
            return 'EventBus_' + Math.random().toString(36) + Math.random().toString(36);
        };
        return {
            addEventListener: function (dvFrame, eventName, func) {
                that.pubSub.subscribe(eventName, dvFrame.$frmId, getRandomActionName(), func);
            },
            dispatchEvent: function (dvFrame, eventName, data) {
                that.pubSub.publish(eventName, dvFrame.$frmId, data);
            }
        };
    })();

    
    var messagesClass = function () {
        var waitingMessages = [];

        this.registerMsg = function (dvFrame, data) {
            if (!waitingMessages[dvFrame.$frmId]) {
                waitingMessages[dvFrame.$frmId] = [];
            }

            waitingMessages[dvFrame.$frmId].push(data);

            if (dvFrame.$uid) {
                sendWaitingEventsForFrame(dvFrame, dvFrame.$uid);
            }
        };

        this.startSendingEvents = function (dvFrame, impID) {
            sendWaitingEventsForFrame(dvFrame, impID);
            
        };

        function sendWaitingEventsForFrame(dvFrame, impID) {
            if (waitingMessages[dvFrame.$frmId]) {
                var eventObject = {};
                while (waitingMessages[dvFrame.$frmId].length) {
                    var obj = waitingMessages[dvFrame.$frmId].pop();
                    for (var key in obj) {
                        if (typeof obj[key] !== 'function' && obj.hasOwnProperty(key)) {
                            eventObject[key] = obj[key];
                        }
                    }
                }
                that.registerEventCall(impID, eventObject);
            }
        }

        function startMessageManager() {
            for (var frm in waitingMessages) {
                if (frm && frm.$uid) {
                    sendWaitingEventsForFrame(frm, frm.$uid);
                }
            }
            setTimeout(startMessageManager, 10);
        }
    };
    this.messages = new messagesClass();

    var MAX_EVENTS_THRESHOLD = 100;
    window.eventsCounter = window.eventsCounter || {};
    var getImpressionIdToCall = function (impressionId) {
        return window.eventsCounter[impressionId] < MAX_EVENTS_THRESHOLD ? impressionId : 'tme-' + impressionId;
    };

    this.registerEventCall = function (impressionId, eventObject, timeoutMs, isRegisterEnabled, usePrerenderedImage) {

        window.eventsCounter[impressionId] =
            window.eventsCounter[impressionId] ? window.eventsCounter[impressionId] + 1 : 1;


        var avoTimeout = 0;
        if (this.tags[impressionId] && this.tags[impressionId].AVO
            && this.tags[impressionId].AVO['cto'] && !isNaN(this.tags[impressionId].AVO['cto'])) {
            avoTimeout = window._dv_win.$dv.tags[impressionId].AVO['cto'];
        }

        if (isRegisterEnabled !== false && avoTimeout) {
            addEventCallForDispatch(impressionId, eventObject);

            if (!timeoutMs || isNaN(timeoutMs)) {
                timeoutMs = avoTimeout;
            }

            var localThat = this;
            setTimeout(
                function () {
                    localThat.dispatchEventCalls(impressionId);
                }, timeoutMs);

        } else {
            this.dispatchEventImmediate(impressionId, eventObject);
        }
    };

    this.dispatchEventImmediate = function (impressionId, eventObject, timeoutMs, isRegisterEnabled, usePrerenderedImage) {
        var url = this.tags[impressionId].protocol + '//' + this.tags[impressionId].ServerPublicDns + "/event.gif?impid=" + getImpressionIdToCall(impressionId) + '&' + createQueryStringParams(eventObject);

        this.domUtilities.addImage(url, this.tags[impressionId].tagElement.parentNode, false, usePrerenderedImage);
    };

    var mraidObjectCache;
    this.getMraid = function () {
        var context = window._dv_win || window;
        var iterationCounter = 0;
        var maxIterations = 20;

        function getMraidRec(context) {
            iterationCounter++;
            var isTopWindow = context.parent == context;
            if (context.mraid || isTopWindow) {
                return context.mraid;
            } else {
                return ( iterationCounter <= maxIterations ) && getMraidRec(context.parent);
            }
        }

        try {
            return mraidObjectCache = mraidObjectCache || getMraidRec(context);
        } catch (e) {
        }
    };

    var dispatchEventCallsNow = function (impressionId, eventObject) {
        addEventCallForDispatch(impressionId, eventObject);
        dispatchEventCalls(impressionId);
    };

    var addEventCallForDispatch = function (impressionId, eventObject) {
        for (var key in eventObject) {
            if (typeof eventObject[key] !== 'function' && eventObject.hasOwnProperty(key)) {
                if (!eventsForDispatch[impressionId]) {
                    eventsForDispatch[impressionId] = {};
                }
                eventsForDispatch[impressionId][key] = eventObject[key];
            }
        }
    };

    this.dispatchRegisteredEventsFromAllTags = function () {
        for (var impressionId in this.tags) {
            if (typeof this.tags[impressionId] !== 'function' && typeof this.tags[impressionId] !== 'undefined') {
                this.dispatchEventCalls(impressionId);
            }
        }

        
        this.registerEventCall = this.dispatchEventImmediate;
    };

    this.dispatchEventCalls = function (impressionId) {
        if (typeof eventsForDispatch[impressionId] !== 'undefined' && eventsForDispatch[impressionId] != null) {
            var url = this.tags[impressionId].protocol + '//' + this.tags[impressionId].ServerPublicDns +
                "/event.gif?impid=" + getImpressionIdToCall(impressionId) + '&' + createQueryStringParams(eventsForDispatch[impressionId]);
            this.domUtilities.addImage(url, this.tags[impressionId].tagElement.parentElement);
            eventsForDispatch[impressionId] = null;
        }
    };

    if (window.addEventListener) {
        window.addEventListener('unload', function () {
            that.dispatchRegisteredEventsFromAllTags();
        }, false);
        window.addEventListener('beforeunload', function () {
            that.dispatchRegisteredEventsFromAllTags();
        }, false);
    }
    else if (window.attachEvent) {
        window.attachEvent('onunload', function () {
            that.dispatchRegisteredEventsFromAllTags();
        }, false);
        window.attachEvent('onbeforeunload', function () {
            that.dispatchRegisteredEventsFromAllTags();
        }, false);
    }
    else {
        window.document.body.onunload = function () {
            that.dispatchRegisteredEventsFromAllTags();
        };
        window.document.body.onbeforeunload = function () {
            that.dispatchRegisteredEventsFromAllTags();
        };
    }

    var createQueryStringParams = function (values) {
        var params = '';
        for (var key in values) {
            if (typeof values[key] !== 'function') {
                var value = encodeURIComponent(values[key]);
                if (params === '') {
                    params += key + '=' + value;
                }
                else {
                    params += '&' + key + '=' + value;
                }
            }
        }

        return params;
    };

    this.Enums = {
        BrowserId: {Others: 0, IE: 1, Firefox: 2, Chrome: 3, Opera: 4, Safari: 5},
        TrafficScenario: {OnPage: 1, SameDomain: 2, CrossDomain: 128}
    };

    this.CommonData = {};

    var runSafely = function (action) {
        try {
            var ret = action();
            return ret !== undefined ? ret : true;
        } catch (e) {
            return false;
        }
    };

    var objectsToUpperCase = function () {
        var upperCaseObj = {};
        for (var i = 0; i < arguments.length; i++) {
            var obj = arguments[i];
            for (var key in obj) {
                if (obj.hasOwnProperty(key)) {
                    upperCaseObj[key.toUpperCase()] = obj[key];
                }
            }
        }
        return upperCaseObj;
    };

    var appendCacheBuster = function (url) {
        if (url !== undefined && url !== null && url.match("^http") == "http") {
            if (url.indexOf('?') !== -1) {
                if (url.slice(-1) == '&') {
                    url += 'cbust=' + dv_GetRnd();
                }
                else {
                    url += '&cbust=' + dv_GetRnd();
                }
            }
            else {
                url += '?cbust=' + dv_GetRnd();
            }
        }
        return url;
    };
}

function dv_baseHandler(){function Cb(){var a="";try{var d=eval(function(a,d,c,j,l,z){l=function(a){return(a<d?"":l(parseInt(a/d)))+(35<(a%=d)?String.fromCharCode(a+29):a.toString(36))};if(!"".replace(/^/,String)){for(;c--;)z[l(c)]=j[c]||l(c);j=[function(a){return z[a]}];l=function(){return"\\w+"};c=1}for(;c--;)j[c]&&(a=a.replace(RegExp("\\b"+l(c)+"\\b","g"),j[c]));return a}("(G(){1A{1A{36('1z?3o:3h')}1B(e){d{1x:\"-4m\"}}n 1h=[1z];1A{n V=1z;67(V!=V.3r&&V.1K.5F.5l){1h.1y(V.1K);V=V.1K}}1B(e){}G 1P(19){1A{1v(n i=0;i<1h.1d;i++){16(19(1h[i]))d 1h[i]==1z.3r?-1:1}d 0}1B(e){d e.5X||'5D'}}G 3m(1a){d 1P(G(O){d O[1a]!=56})}G 37(O,35,19){1v(n 1a 57 O){16(1a.3a(35)>-1&&(!19||19(O[1a])))d 3o}d 3h}G g(s){n h=\"\",t=\"3N.;j&4M}4N/0:51'4r=B(4z-4e!,4k)5r\\\\{ >4o+4l\\\"4A<\";1v(i=0;i<s.1d;i++)f=s.3b(i),e=t.3a(f),0<=e&&(f=t.3b((e+41)%82)),h+=f;d h}n c=['4G\"1m-4c\"3G\"22','p','l','60&p','p','{','\\\\<}4\\\\3M-3D<\"3O\\\\<}4\\\\3z<Z?\"6','e','6p','-5,!u<}\"66}\"','p','J','-5g}\"<53','p','=o','\\\\<}4\\\\31\"2f\"w\\\\<}4\\\\31\"2f\"5v}2\"<,u\"<5}?\"6','e','J=',':<5u}T}<\"','p','h','\\\\<}4\\\\8-2}\"E(k\"12}9?\\\\<}4\\\\8-2}\"E(k\"2n<N\"[1s*1t\\\\\\\\2r-5K<2L\"2t\"4b]1c}C\"13','e','4L','\\\\<}4\\\\4v;5Q||\\\\<}4\\\\4t?\"6','e','+o','\"1f\\\\<}4\\\\1T\"I<-4s\"29\"5\"4w}26<}4O\"1f\\\\<}4\\\\1l}1E>1D-1C}2}\"29\"5\"46}26<}3Z','e','=J','W}U\"<5}3T\"7}F\\\\<}4\\\\[3R}3U:3W]m}b\\\\<}4\\\\[t:2b\"4I]m}b\\\\<}4\\\\[5W})5-u<}t]m}b\\\\<}4\\\\[5U]m}b\\\\<}4\\\\[5I}5P]m}64','e','65',':6g}<\"H-1Q/2M','p','6f','\\\\<}4\\\\17<U/1o}b\\\\<}4\\\\17<U/!m}9','e','=l','10\\\\<}4\\\\69}/68}U\"<5}5h\"7}59<2F}58\\\\4Z\"5E}/m}2z','e','=S=','\\\\<}4\\\\E-5p\\\\<}4\\\\E-5s\"5\\\\U?\"6','e','+J','\\\\<}4\\\\25!5t\\\\<}4\\\\25!5q)p?\"6','e','5m','-}\"5o','p','x{','\\\\<}4\\\\E<2q-5w}5C\\\\<}4\\\\5B\"5x-5y\\\\<}4\\\\5z.42-2}\"5A\\\\<}4\\\\5k<N\"H}5j?\"6','e','+S','W}U\"<5}K\"X\"7}F\\\\<}4\\\\y<1O\"1f\\\\<}4\\\\y<2j}U\"<5}1j\\\\<}4\\\\1n-2.42-2}\"w\\\\<}4\\\\1n-2.42-2}\"1p\"L\"\"M<30\"2Y\"2S<\"<5}2R\"2P\\\\<Z\"2T<Q\"2V{2X:3q\\\\2W<1k}38-39<}3k\"3j\"1q%3l<Q\"1q%3n?\"3i\"14\"7}3c','e','54','55:,','p','52','\\\\<}4\\\\4Y\\\\<}4\\\\23\"2O\\\\<}4\\\\23\"1Y,T}1Z+++++1j\\\\<}4\\\\50\\\\<}4\\\\21\"2O\\\\<}4\\\\21\"1Y,T}1Z+++++t','e','5i','\\\\<}4\\\\5f\"1Q\"5e}b\\\\<}4\\\\E\\\\5a<M?\"6','e','5b','W}U\"<5}K:5c\\\\<}4\\\\8-2}\"1p\".42-2}\"5d-5G<N\"5H<6c<6d}C\"3H<6e<6b[<]E\"27\"1m}\"2}\"6a[<]E\"27\"1m}\"2}\"E<}18&6n\"1\\\\<}4\\\\2A\\\\6o\\\\<}4\\\\2A\\\\1l}1E>1D-1C}2}\"z<6m-2}\"6l\"2.42-2}\"6h=6i\"7}6j\"7}P=6k','e','x','5R)','p','+','\\\\<}4\\\\2I:5O<5}5N\\\\<}4\\\\2I\"5J?\"6','e','5L','L!!5S.5T.H 61','p','x=','\\\\<}4\\\\62}63)u\"5Z\\\\<}4\\\\5Y-2?\"6','e','+=','\\\\<}4\\\\2x\"5V\\\\<}4\\\\2x\"4X--6q<\"2f?\"6','e','x+','\\\\<}4\\\\8-2}\"2p}\"2o<N\"w\\\\<}4\\\\8-2}\"2p}\"2o<N\"3X\")3Y\"<:3V\"3Q}9?\"6','e','+x','\\\\<}4\\\\2m)u\"3S\\\\<}4\\\\2m)u\"40?\"6','e','49','\\\\<}4\\\\2w}s<4a\\\\<}4\\\\2w}s<48\" 47-43?\"6','e','44','\\\\<}4\\\\E\"45-2}\"E(k\"3P<N\"[1s*3L\"3y<3A]3x?\"6','e','+e','\\\\<}4\\\\8-2}\"E(k\"12}9?\\\\<}4\\\\8-2}\"E(k\"3C<:[\\\\3w}}2M][\\\\3t,5}2]3u}C\"13','e','3v','10\\\\<}4\\\\3B}3K\\\\<}4\\\\3J$3E','e','3F',':3I<Z','p','4W','\\\\<}4\\\\E-4d\\\\<}4\\\\E-4J}4K\\\\<}4\\\\E-4H<4C?\"6','e','4D','$H:4E}Z!4F','p','+h','\\\\<}4\\\\E\"1J\\\\<}4\\\\E\"1L-4T?\"6','e','4U','10\\\\<}4\\\\4V:,2H}U\"<5}1r\"7}4S<4R<2F}2z','e','4P','\\\\<}4\\\\17<U/4Q&1V\"E/1W\\\\<}4\\\\17<U/4B}C\"3d\\\\<}4\\\\17<U/f[&1V\"E/1W\\\\<}4\\\\17<U/4n[S]]1T\"4j}9?\"6','e','4g','4h}4i}4p>2s','p','4q','\\\\<}4\\\\1g:<1R}s<4x}b\\\\<}4\\\\1g:<1R}s<4y<}f\"u}2G\\\\<}4\\\\2K\\\\<}4\\\\1g:<1R}s<C[S]E:2b\"1o}9','e','l{','4u\\'<}4\\\\T}5n','p','==','\\\\<}4\\\\y<1O\\\\<}4\\\\y<2B\\\\<Z\"2C\\\\<}4\\\\y<2E<Q\"?\"6','e','6N','\\\\<}4\\\\2a}28-2c\"}2d<8k\\\\<}4\\\\2a}28-2c\"}2d/2Q?\"6','e','=8l','\\\\<}4\\\\E\"2f\"8m\\\\<}4\\\\8j<8e?\"6','e','o{','\\\\<}4\\\\8f-)2\"2U\"w\\\\<}4\\\\1g-8g\\\\1m}s<C?\"6','e','+l','\\\\<}4\\\\2g-2\"8h\\\\<}4\\\\2g-2\"8n<Z?\"6','e','+{','\\\\<}4\\\\E:8o}b\\\\<}4\\\\8v-8w}b\\\\<}4\\\\E:8x\"<8u\\\\}m}9?\"6','e','{S','\\\\<}4\\\\1i}\"11}8t\"-8p\"2f\"q\\\\<}4\\\\v\"<5}8q?\"6','e','o+',' &H)&8r','p','8s','\\\\<}4\\\\E.:2}\"c\"<8d}b\\\\<}4\\\\8c}b\\\\<}4\\\\7W<}f\"u}2G\\\\<}4\\\\2K\\\\<}4\\\\1l:}\"m}9','e','7X','7Y\"5-\\'2J:2M','p','J{','\\\\<}4\\\\7Z\"5-\\'2J:7V}7U=7Q:D|q=2y|7R-5|7S--1Q/2\"|2N-2y|80\"=81\"2f\"q\\\\<}4\\\\1M\"2h:2i<1k}D?\"6','e','=8a','\\\\<}4\\\\8-2}\"E(k\"12}9?\\\\<}4\\\\8-2}\"E(k\"2n<N\"[1s*1t\\\\\\\\2r-2L\"2t/8b<6r]1c}C\"13','e','87',')8z!84}s<C','p','86','\\\\<}4\\\\2u<<8y\\\\<}4\\\\2u<<8D<}f\"u}94?\"6','e','{l','\\\\<}4\\\\2v.L>g;H\\'T)Y.8X\\\\<}4\\\\2v.L>g;8Y&&8Z>H\\'T)Y.I?\"6','e','l=','10\\\\<}4\\\\91\\\\8U>8V}U\"<5}1r\"7}F\"2l}U\"<5}90\\\\<}4\\\\93<2q-20\"u\"92}U\"<5}1r\"7}F\"2l}U\"<5}8S','e','{J','H:<Z<:5','p','8F','\\\\<}4\\\\m\\\\<}4\\\\E\"8G\\\\<}4\\\\v\"<5}3g\"3f}/1j\\\\<}4\\\\8-2}\"3e<}18&8H\\\\<}4\\\\v\"<5}1b\"}u-8E=?W}U\"<5}K\"X\"7}8T\\\\<}4\\\\1i}\"v\"<5}8A\"14\"7}F\"8B','e','8C','\\\\<}4\\\\1F-U\\\\w\\\\<}4\\\\1F-8I\\\\<}4\\\\1F-\\\\<}?\"6','e','8J','8P-N:8Q','p','8R','\\\\<}4\\\\1G\"8O\\\\<}4\\\\1G\"8N\"<5}8K\\\\<}4\\\\1G\"8L||\\\\<}4\\\\8M?\"6','e','h+','83<u-7O/','p','{=','\\\\<}4\\\\v\"<5}1b\"}u-6U\\\\<}4\\\\1l}1E>1D-1C}2}\"q\\\\<}4\\\\v\"<5}1b\"}u-2D','e','=S','\\\\<}4\\\\6W\"1f\\\\<}4\\\\6T}U\"<5}1j\\\\<}4\\\\6S?\"6','e','{o','\\\\<}4\\\\6O}<6P\\\\<}4\\\\6Q}?\"6','e','=6R','\\\\<}4\\\\y<1O\\\\<}4\\\\y<2B\\\\<Z\"2C\\\\<}4\\\\y<2E<Q\"w\"1f\\\\<}4\\\\y<2j}U\"<5}t?\"6','e','J+','c>A','p','=','W}U\"<5}K\"X\"7}F\\\\<}4\\\\E\"6Y\"74:75}76^[73,][72+]6Z\\'<}4\\\\70\"2f\"q\\\\<}4\\\\E}u-6M\"14\"7}6y=6z','e','6A','\\\\<}4\\\\1S:!34\\\\<}4\\\\8-2}\"E(k\"12}9?\\\\<}4\\\\8-2}\"E(k\"1N<:[f\"22*6x<Q\"6w]6s<:[<Z*1t:Z,1I]1c}C\"13','e','=6t','\\\\<}4\\\\1X\"<24-1U-u}6u\\\\<}4\\\\1X\"<24-1U-u}6v?\"6','e','{x','6C}7K','p','6J','\\\\<}4\\\\8-2}\"E(k\"12}9?\\\\<}4\\\\8-2}\"E(k\"1N<:[<Z*1t:Z,1I]F:<6K[<Z*6L]1c}C\"13','e','h=','6I-2}\"v\"<5}m}9','e','6H','\\\\<}4\\\\8-2}\"E(k\"12}9?\\\\<}4\\\\8-2}\"E(k\"1N<:[<Z*6D}1I]R<-C[1s*6E]1c}C\"13','e','6F','10\\\\<}4\\\\2e\"\\\\6G\\\\<}4\\\\2e\"\\\\77','e','78','\\\\<}4\\\\1M\"w\\\\<}4\\\\1M\"2h:2i<1k}?\"6','e','{e','\\\\<}4\\\\7A}Z<}7B}b\\\\<}4\\\\7C<f\"m}b\\\\<}4\\\\7y/<}C!!7u<\"42.42-2}\"1o}b\\\\<}4\\\\7v\"<5}m}9?\"6','e','7w','T>;7x\"<4f','p','h{','\\\\<}4\\\\7D<u-7E\\\\7L}b\\\\<}4\\\\1g<}7M}9?\"6','e','7N','\\\\<}4\\\\E\"1J\\\\<}4\\\\E\"1L-3s}U\"<5}K\"X\"7}F\\\\<}4\\\\1i}\"v\"<5}1b\"E<}18&3p}33=w\\\\<}4\\\\1i}\"8-2}\"1p\".42-2}\"7J}\"u<}7I}7F\"14\"7}F\"32?\"6','e','{h','\\\\<}4\\\\7H\\\\<}4\\\\7t}<(7s?\"6','e','7f','\\\\<}4\\\\7g<U-2Z<7h&p?10\\\\<}4\\\\7e<U-2Z<79/2H}U\"<5}1r\"7}F\"7a','e','=7b','7c\\'<7i\"','p','{{','\\\\<}4\\\\E\"1J\\\\<}4\\\\E\"1L-3s}U\"<5}K\"X\"7}F\\\\<}4\\\\1i}\"v\"<5}1b\"E<}18&3p}33=7j\"14\"7}F\"32?\"6','e','7p','W}U\"<5}K\"X\"7}F\\\\<}4\\\\1S:!34\\\\<}4\\\\1n-2.42-2}\"w\\\\<}4\\\\1n-2.42-2}\"1p\"L\"\"M<30\"2Y\"2S<\"<5}2R\"2P\\\\<Z\"2T<Q\"2V{2X:3q\\\\2W<1k}38-39<}3k\"3j\"1q%3l<Q\"1q%3n?\"3i\"14\"7}3c','e','{+','\\\\<}4\\\\7o<7n a}7l}b\\\\<}4\\\\E}7m\"7k 7r- 1o}9','e','7q','7d\\\\<}4\\\\v\"<5}1S}7G\"5M&M<C<}7z}C\"3d\\\\<}4\\\\v\"<5}3g\"3f}/1j\\\\<}4\\\\8-2}\"6B\\\\<}4\\\\8-2}\"3e<}18&71[S]6X=?\"6','e','l+'];n 1w=[];n 1e=[];1v(n j=0;j<c.1d;j+=3){n r=c[j+1]=='p'?3m(g(c[j])):1P(G(O){d O.36('(G(){'+37.7P()+';d '+g(c[j])+'})();')});n 1u=6V(g(c[j+2]));16(r>0||r<0){1w.1y(r*1u)}8W 16(85 r=='89'){1w.1y(-7T*1u);1e.1y(1u+\"=\"+r)}16(1e.1d>=15)d{1x:r}}n 1H={1x:1w.2k(\",\")};16(1e.1d>0)1H.8i=1e.2k(\"&\");d 1H}1B(e){d{1x:\"-88\"}}})();",
62,563,"    Z5  Ma2vsu4f2 aM EZ5Ua a44  a44OO  return       a2MQ0242U  P1 var        E45Uu OO  E3        function _   qD8    wnd  C3     tmpWnd qsa MQ8M2   U5q  5ML44P1 3RSvsu4f2 U3q2D8M2  if EBM Z27 func prop E35f WDE42 length errors QN25sF E_ wndz ENuM2 tOO ZZ2 E2 g5 EsMu fP1 EC2 vFoS q5D8M2 fMU  id for results res push window try catch N5 Tg5 U5Z2c Euf EuZ response _t UIuCTZOO parent UT EfaNN_uZf_35f 5ML44qWZ M5OO ch uM ZU5 Eu Ef2 fC_ BV2U 2Qfq Ea Q42E Z2711t  EuZ_lEf Q42 EuZ_hEf _7Z E_Y Z2s  5Mu ENM5 ENu uf _NuM 2M_ zt__  E__N _5 2MM M511tsa join QN25sF511tsa EufB 5ML44qWfUM 0UM E_UaMM2 sMu BuZfEU5  MuU E__ EcIT_0 ELZg5 EU uZf a44nD z5 M5E 3OO  M5E32 ZP1 U25sF tzsa E27 ALZ02M ELMMuQOO kN7   Q42OO 2HFB5MZ2MvFSN7HF  vFuBf54a Q42tD11tN5f 3vFJlSN7HF32  vFl vF3 SN7HF5 2qtf  Ba Ef35M Ma2HnnDqD uNfQftD11m 4uQ2MOO str eval co HF uMC indexOf charAt Fsu4f2HnnDqD 3RSOO EM2s2MM2ME vB4u E3M2sP1tuB5a false Ma2vsu4f2nUu vFmheSN7HF42s m42s HFM ex Ht true sqtfQ 2Ms45 top NTZOOqsa Um tDE42 eS UmBu WD kC5 ENaBf_uZ_faB UEVft zt__uZ_M 5ML44qtZ 5Zu4 _tD Jl 2Z0  u_faB zt_ f_tDOOU5q 1tk27 ENaBf_uZ_uZ Ue QOO 5MqWfUM 35ZP1 tf5a u_Z2U5Z2OO qD8M2 ZA2 2r2 24t EZ5p5 2s2MI5pu 2Zt ujuM   2cM4 JJ uCUuZ2OOZ5Ua QN2P1ta Mu CEC2 oo COO EVft Na 2MUaMQOO uic2EHVO  ox M2 5IMu aNP1 LnG lkSvfxWX 99 fD NhCZ fY45 hx Kt 25a E7GXLss0aBTZIuC UufUuZ2 E7LZfKrA QN211ta CP1 CF Q6T 1bqyJIma fDE42 NLZZM2ff Je V0 7A5C C2 2MUaMQE r5Z2t 2MUaMQEU5 sOO eo PzA YDoMw8FRp3gd94 2ZtOO lJ fOO f32M_faB F5ENaB4 NTZ oJ zt_M hJ 7__E2U EuZ_hOO IuMC2 EuZ_lOO s7 he u4f xx _M null in a44OO5BVEu445 F5BVEa 2BfM2Z xo uMF21 fbQIuCpu aM4P1 Ef fgM2Z2 q5BVD8M2 xl 5Z2f EfUM href lS s5 M__ UCMOO AEBuf2g  UCME AOO ZBu r5 2_M2s2M2 2TsMu 2OO EuZZ I5b5ZQOO EaNZu U2OO unknown b4u location 2qtfUM tDHs5Mq tB IQN2 kUM xJ  _V5V5OO 2Mf LMMt 24N2MTZ Ld0 _ALb A_pLr tUBt 7__OO tUZ message EuZZTsMu uOO  cAA_cg EA5Cba Z42 a44nDqD ee g5a while Mtzsa zt_4 OO2 sq2 1SH i2E42 99D ho u_a tDRm DM2 PSHM2 HnDqD EUM2u 1Z5Ua sqt E2fUuN2z21 xh MU0 fN4uQLZfEVft FZ So uC2MOO uC2MEUB vFSN7t 1t32 FP HnnDqD xe EM2s2MM2MOO B24 1tB2uU5 1tNk4CEN3Nt oe B__tDOOU5q eh Z5Ua xS Z25 1tfMmN4uQ2Mt 2DnUu Jh ELZ0 N2MOO EuZfBQuZf Sh E5U4U5qDEN4uQ E5U4U511tsa 2P1 parseInt E5U4U5OO D11m 5NENM5U2ff_ 8lzn kE squ Sm um uC_ uMfP1 a44OOk B_UB_tD lh ubuf2b45U Ma2nDvsu4f2 Sl LZZ035NN2Mf u1 ztIMuss ol EIMuss u60 ZC2 HnUu 5M2f UP1 _f 4Zf EUuU Jx lx M5 a2TZ E_NUCEYp_c gI Eu445Uu lo _c ENuM fzuOOuE42 E4u CcM4P1 Ef2A ENM bM5 a44HnUu U2f E_NUCOO 2MtD11 bQTZqtMffmU5  f2MP1 N4uU2_faUU2ffP1 Jo _uZB45U toString zlnuZf2M UUUN 2N5 1000 wZ8 2MOOkq ErF ll gaf Egaf uZf35f DkE  _NM 4Qg5 typeof oh eJ 999 string SS kZ ErP1 4P1 u4buf2Jl E_Vu fN uCOO err E0N2U ZOO Se fNNOO uCEa u_uZ_M2saf2_M2sM2f3P1 4kE E3M2sD rLTp hl a44OOkuZwkwZ8ezhn7wZ8ezhnwE3 2M_f35 ENuMu fC532M2P1 u_ ZfOO 2u4 E3M2szsu4f2nUu Ma2nnDqDvsu4f2 oS ZfF 2DRm hh 5NOO sq M2sOO JS OOq CfE35aMfUuN E35aMfUuND CfEf2U CfOO ___U _ZBf le tnD FN1 f2Mc A_tzsa else IOO _I AbL tnDOOU5q ztBM5 af_tzsa zt U25sFLMMuQ".split(" "),
0,{}));d.hasOwnProperty("err")&&(a=d.err);return{vdcv:23,vdcd:d.res,err:a}}catch(c){return{vdcv:23,vdcd:"0",err:a}}}function ua(a,d,c){var c=c||150,e=window._dv_win||window;if(e.document&&e.document.body)return d&&d.parentNode?d.parentNode.insertBefore(a,d):e.document.body.insertBefore(a,e.document.body.firstChild),!0;if(0<c)setTimeout(function(){ua(a,d,--c)},20);else return!1}function Ra(a){var d=null;try{if(d=a&&a.contentDocument)return d}catch(c){}try{if(d=a.contentWindow&&a.contentWindow.document)return d}catch(e){}try{if(d=
window._dv_win.frames&&window._dv_win.frames[a.name]&&window._dv_win.frames[a.name].document)return d}catch(i){}return null}function Sa(a){var d=document.createElement("iframe");d.name=d.id=window._dv_win.dv_config.emptyIframeID||"iframe_"+Math.floor(1E12*(Math.random()+""));d.width=0;d.height=0;d.style.display="none";d.src=a;return d}function Ta(a){var d={};try{for(var c=RegExp("[\\?&]([^&]*)=([^&#]*)","gi"),e=c.exec(a);null!=e;)"eparams"!==e[1]&&(d[e[1]]=e[2]),e=c.exec(a);return d}catch(i){return d}}
function Db(a){try{if(1>=a.depth)return{url:"",depth:""};var d,c=[];c.push({win:window._dv_win.top,depth:0});for(var e,i=1,s=0;0<i&&100>s;){try{if(s++,e=c.shift(),i--,0<e.win.location.toString().length&&e.win!=a)return 0==e.win.document.referrer.length||0==e.depth?{url:e.win.location,depth:e.depth}:{url:e.win.document.referrer,depth:e.depth-1}}catch(j){}d=e.win.frames.length;for(var l=0;l<d;l++)c.push({win:e.win.frames[l],depth:e.depth+1}),i++}return{url:"",depth:""}}catch(z){return{url:"",depth:""}}}
function va(a){var d=String(),c,e,i;for(c=0;c<a.length;c++)i=a.charAt(c),e="!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".indexOf(i),0<=e&&(i="!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~".charAt((e+47)%94)),d+=i;return d}function Eb(){try{if("function"===typeof window.callPhantom)return 99;try{if("function"===typeof window.top.callPhantom)return 99}catch(a){}if(void 0!=window.opera&&void 0!=window.history.navigationMode||
void 0!=window.opr&&void 0!=window.opr.addons&&"function"==typeof window.opr.addons.installExtension)return 4;if(void 0!=window.chrome&&"function"==typeof window.chrome.csi&&"function"==typeof window.chrome.loadTimes&&void 0!=document.webkitHidden&&(!0==document.webkitHidden||!1==document.webkitHidden))return 3;if(void 0!=document.isConnected&&void 0!=document.webkitHidden&&(!0==document.webkitHidden||!1==document.webkitHidden))return 6;if(void 0!=window.mozInnerScreenY&&"number"==typeof window.mozInnerScreenY&&
void 0!=window.mozPaintCount&&0<=window.mozPaintCount&&void 0!=window.InstallTrigger&&void 0!=window.InstallTrigger.install)return 2;if(void 0!=document.uniqueID&&"string"==typeof document.uniqueID&&(void 0!=document.documentMode&&0<=document.documentMode||void 0!=document.all&&"object"==typeof document.all||void 0!=window.ActiveXObject&&"function"==typeof window.ActiveXObject)||window.document&&window.document.updateSettings&&"function"==typeof window.document.updateSettings)return 1;var d=!1;try{var c=
document.createElement("p");c.innerText=".";c.style="text-shadow: rgb(99, 116, 171) 20px -12px 2px";d=void 0!=c.style.textShadow}catch(e){}return(0<Object.prototype.toString.call(window.HTMLElement).indexOf("Constructor")||window.webkitAudioPannerNode&&window.webkitConvertPointFromNodeToPage)&&d&&void 0!=window.innerWidth&&void 0!=window.innerHeight?5:0}catch(i){return 0}}this.createRequest=function(){var a,d,c;function e(a,b){var d={};try{if(a.performance&&a.performance.getEntries)for(var c=a.performance.getEntries(),
e=0;e<c.length;e++){var h=c[e],f=h.name.match(/.*\/(.+?)\./);if(f&&f[1]){var j=f[1].replace(/\d+$/,""),A=b[j];if(A){for(var g=0;g<A.stats.length;g++){var l=A.stats[g];d[A.prefix+l.prefix]=Math.round(h[l.name])}delete b[j];if(!i(b))break}}}return d}catch(q){}}function i(a){var b=0,d;for(d in a)a.hasOwnProperty(d)&&++b;return b}window._dv_win.$dv.isEval=1;window._dv_win.$dv.DebugInfo={};var s=!1,j=!1,l,z,I=!1,f=window._dv_win,Ua=0,Va=!1,Wa=getCurrentTime();window._dv_win.t2tTimestampData=[{dvTagCreated:Wa}];
var W;try{for(W=0;10>=W;W++)if(null!=f.parent&&f.parent!=f)if(0<f.parent.location.toString().length)f=f.parent,Ua++,I=!0;else{I=!1;break}else{0==W&&(I=!0);break}}catch(Ra){I=!1}var O;0==f.document.referrer.length?O=f.location:I?O=f.location:(O=f.document.referrer,Va=!0);var Xa="",wa=null,xa=null;try{window._dv_win.external&&(wa=void 0!=window._dv_win.external.QueuePageID?window._dv_win.external.QueuePageID:null,xa=void 0!=window._dv_win.external.CrawlerUrl?window._dv_win.external.CrawlerUrl:null)}catch($b){Xa=
"&dvp_extErr=1"}if(!window._dv_win._dvScriptsInternal||!window._dv_win.dvProcessed||0==window._dv_win._dvScriptsInternal.length)return null;var X=window._dv_win._dvScriptsInternal.pop(),J=X.script;this.dv_script_obj=X;this.dv_script=J;window._dv_win.t2tTimestampData[0].dvWrapperLoadTime=X.loadtime;window._dv_win.dvProcessed.push(X);var b=J.src;if(void 0!=window._dv_win.$dv.CommonData.BrowserId&&void 0!=window._dv_win.$dv.CommonData.BrowserVersion&&void 0!=window._dv_win.$dv.CommonData.BrowserIdFromUserAgent)a=
window._dv_win.$dv.CommonData.BrowserId,d=window._dv_win.$dv.CommonData.BrowserVersion,c=window._dv_win.$dv.CommonData.BrowserIdFromUserAgent;else{for(var Ya=dv_GetParam(b,"useragent"),Za=Ya?decodeURIComponent(Ya):navigator.userAgent,K=[{id:4,brRegex:"OPR|Opera",verRegex:"(OPR/|Version/)"},{id:1,brRegex:"MSIE|Trident/7.*rv:11|rv:11.*Trident/7|Edge/",verRegex:"(MSIE |rv:| Edge/)"},{id:2,brRegex:"Firefox",verRegex:"Firefox/"},{id:0,brRegex:"Mozilla.*Android.*AppleWebKit(?!.*Chrome.*)|Linux.*Android.*AppleWebKit.* Version/.*Chrome",
verRegex:null},{id:0,brRegex:"AOL/.*AOLBuild/|AOLBuild/.*AOL/|Puffin|Maxthon|Valve|Silk|PLAYSTATION|PlayStation|Nintendo|wOSBrowser",verRegex:null},{id:3,brRegex:"Chrome",verRegex:"Chrome/"},{id:5,brRegex:"Safari|(OS |OS X )[0-9].*AppleWebKit",verRegex:"Version/"}],ya=0,$a="",B=0;B<K.length;B++)if(null!=Za.match(RegExp(K[B].brRegex))){ya=K[B].id;if(null==K[B].verRegex)break;var za=Za.match(RegExp(K[B].verRegex+"[0-9]*"));if(null!=za)var Fb=za[0].match(RegExp(K[B].verRegex)),$a=za[0].replace(Fb[0],
"");break}var ab=Eb();a=ab;d=ab===ya?$a:"";c=ya;window._dv_win.$dv.CommonData.BrowserId=a;window._dv_win.$dv.CommonData.BrowserVersion=d;window._dv_win.$dv.CommonData.BrowserIdFromUserAgent=c}var C,Aa=!0,Ba=window.parent.postMessage&&window.JSON,bb=!1;if("0"==dv_GetParam(b,"t2te")||window._dv_win.dv_config&&!0===window._dv_win.dv_config.supressT2T)bb=!0;if(Ba&&!1===bb&&5!=window._dv_win.$dv.CommonData.BrowserId)try{C=Sa(window._dv_win.dv_config.t2turl||"https://cdn3.doubleverify.com/t2tv7.html"),
Aa=ua(C)}catch(ac){}window._dv_win.$dv.DebugInfo.dvp_HTML5=Ba?"1":"0";var Y=dv_GetParam(b,"region")||"",Z;Z=(/iPhone|iPad|iPod|\(Apple TV|iOS|Coremedia|CFNetwork\/.*Darwin/i.test(navigator.userAgent)||navigator.vendor&&"apple, inc."===navigator.vendor.toLowerCase())&&!window.MSStream;var Ca;if(Z)Ca="https:";else{var cb="http:";"http:"!=window._dv_win.location.protocol&&(cb="https:");Ca=cb}var Gb=Ca,Da;if(Z)Da="https:";else{var db="http:";if("https"==b.match("^https")&&("http"!=window._dv_win.location.toString().match("^http")||
"https"==window._dv_win.location.toString().match("^https")))db="https:";Da=db}var $=Da,eb="0";"https:"===$&&(eb="1");try{for(var Hb=f,Ea=f,Fa=0;10>Fa&&Ea!=window._dv_win.top;)Fa++,Ea=Ea.parent;Hb.depth=Fa;var fb=Db(f);dv_aUrlParam="&aUrl="+encodeURIComponent(fb.url);dv_aUrlDepth="&aUrlD="+fb.depth;dv_referrerDepth=f.depth+Ua;Va&&f.depth--}catch(bc){dv_aUrlDepth=dv_aUrlParam=dv_referrerDepth=f.depth=""}for(var gb=dv_GetDynamicParams(b,"dvp"),aa=dv_GetDynamicParams(b,"dvpx"),ba=0;ba<aa.length;ba++){var hb=
dv_GetKeyValue(aa[ba]);aa[ba]=hb.key+"="+encodeURIComponent(hb.value)}"41"==Y&&(Y=50>100*Math.random()?"41":"8",gb.push("dvp_region="+Y));var ib=gb.join("&"),jb=aa.join("&"),Ib=window._dv_win.dv_config.tpsAddress||"tps"+Y+".doubleverify.com",P="visit.js";switch(dv_GetParam(b,"dvapi")){case "1":P="dvvisit.js";break;case "5":P="query.js";break;default:P="visit.js"}window._dv_win.$dv.DebugInfo.dvp_API=P;for(var ca="ctx cmp ipos sid plc adid crt btreg btadsrv adsrv advid num pid crtname unit chnl uid scusrid tagtype sr dt dup app sup dvvidver".split(" "),
p=[],r=0;r<ca.length;r++){var Ga=dv_GetParam(b,ca[r])||"";p.push(ca[r]+"="+Ga);""!==Ga&&(window._dv_win.$dv.DebugInfo["dvp_"+ca[r]]=Ga)}for(var Ha="turl icall dv_callback useragent xff timecheck seltag sadv ord litm scrt invs splc adu native".split(" "),r=0;r<Ha.length;r++){var kb=dv_GetParam(b,Ha[r]);null!=kb&&p.push(Ha[r]+"="+(kb||""))}var lb=dv_GetParam(b,"isdvvid")||"";lb&&p.push("isdvvid=1");var mb=dv_GetParam(b,"tagtype")||"",w=window._dv_win.$dv.getMraid(),Ia;a:{try{if("object"==typeof window.$ovv||
"object"==typeof window.parent.$ovv){Ia=!0;break a}}catch(cc){}Ia=!1}if(1!=lb&&!w&&("video"==mb||"1"==mb)){var nb=dv_GetParam(b,"adid")||"";"function"===typeof _dv_win[nb]&&(p.push("prplyd=1"),p.push("DVP_GVACB="+nb),p.push("isdvvid=1"));var ob="AICB_"+(window._dv_win.dv_config&&window._dv_win.dv_config.dv_GetRnd?window._dv_win.dv_config.dv_GetRnd():dv_GetRnd());window._dv_win[ob]=function(a){s=!0;l=a;window._dv_win.$dv&&!0==j&&window._dv_win.$dv.registerEventCall(z,{prplyd:0,dvvidver:a})};p.push("AICB="+
ob);var Jb=p.join("&"),pb=window._dv_win.document.createElement("script");pb.src=$+"//cdn.doubleverify.com/dvvid_src.js?"+Jb;window._dv_win.document.body.appendChild(pb)}try{var Q=e(window,{dvtp_src:{prefix:"d",stats:[{name:"fetchStart",prefix:"fs"},{name:"duration",prefix:"dur"}]},dvtp_src_internal:{prefix:"dv",stats:[{name:"duration",prefix:"dur"}]}});if(!Q||!i(Q))p.push("dvp_noperf=1");else for(var Ja in Q)Q.hasOwnProperty(Ja)&&p.push(Ja+"="+Q[Ja])}catch(dc){}var Kb=p.join("&"),D;var Lb=function(){try{return!!window.sessionStorage}catch(a){return!0}},
Mb=function(){try{return!!window.localStorage}catch(a){return!0}},Nb=function(){var a=document.createElement("canvas");if(a.getContext&&a.getContext("2d")){var b=a.getContext("2d");b.textBaseline="top";b.font="14px 'Arial'";b.textBaseline="alphabetic";b.fillStyle="#f60";b.fillRect(0,0,62,20);b.fillStyle="#069";b.fillText("!image!",2,15);b.fillStyle="rgba(102, 204, 0, 0.7)";b.fillText("!image!",4,17);return a.toDataURL()}return null};try{var t=[];t.push(["lang",navigator.language||navigator.browserLanguage]);
t.push(["tz",(new Date).getTimezoneOffset()]);t.push(["hss",Lb()?"1":"0"]);t.push(["hls",Mb()?"1":"0"]);t.push(["odb",typeof window.openDatabase||""]);t.push(["cpu",navigator.cpuClass||""]);t.push(["pf",navigator.platform||""]);t.push(["dnt",navigator.doNotTrack||""]);t.push(["canv",Nb()]);var k=t.join("=!!!=");if(null==k||""==k)D="";else{for(var R=function(a){for(var b="",d,c=7;0<=c;c--)d=a>>>4*c&15,b+=d.toString(16);return b},Ob=[1518500249,1859775393,2400959708,3395469782],k=k+String.fromCharCode(128),
E=Math.ceil((k.length/4+2)/16),F=Array(E),q=0;q<E;q++){F[q]=Array(16);for(var G=0;16>G;G++)F[q][G]=k.charCodeAt(64*q+4*G)<<24|k.charCodeAt(64*q+4*G+1)<<16|k.charCodeAt(64*q+4*G+2)<<8|k.charCodeAt(64*q+4*G+3)}F[E-1][14]=8*(k.length-1)/Math.pow(2,32);F[E-1][14]=Math.floor(F[E-1][14]);F[E-1][15]=8*(k.length-1)&4294967295;for(var da=1732584193,ea=4023233417,fa=2562383102,ga=271733878,ha=3285377520,m=Array(80),L,n,x,y,ia,q=0;q<E;q++){for(var h=0;16>h;h++)m[h]=F[q][h];for(h=16;80>h;h++)m[h]=(m[h-3]^m[h-
8]^m[h-14]^m[h-16])<<1|(m[h-3]^m[h-8]^m[h-14]^m[h-16])>>>31;L=da;n=ea;x=fa;y=ga;ia=ha;for(h=0;80>h;h++){var qb=Math.floor(h/20),Pb=L<<5|L>>>27,M;c:{switch(qb){case 0:M=n&x^~n&y;break c;case 1:M=n^x^y;break c;case 2:M=n&x^n&y^x&y;break c;case 3:M=n^x^y;break c}M=void 0}var Qb=Pb+M+ia+Ob[qb]+m[h]&4294967295;ia=y;y=x;x=n<<30|n>>>2;n=L;L=Qb}da=da+L&4294967295;ea=ea+n&4294967295;fa=fa+x&4294967295;ga=ga+y&4294967295;ha=ha+ia&4294967295}D=R(da)+R(ea)+R(fa)+R(ga)+R(ha)}}catch(ec){D=null}D=null!=D?"&aadid="+
D:"";var rb=b,Rb=window._dv_win.dv_config.visitJSURL||$+"//"+Ib+"/"+P,Sb=Z?"&dvf=0":"",ja;a:{var N=window._dv_win,sb=0;try{for(;10>sb;){if(N.maple&&"object"===typeof N.maple){ja=!0;break a}if(N==N.parent){ja=!1;break a}sb++;N=N.parent}}catch(fc){}ja=!1}var Tb=ja?"&dvf=1":"",b=Rb+"?"+Kb+"&dvtagver=6.1.src&srcurlD="+f.depth+"&curl="+(null==xa?"":encodeURIComponent(xa))+"&qpgid="+(null==wa?"":wa)+"&ssl="+eb+Sb+Tb+"&refD="+dv_referrerDepth+"&htmlmsging="+(Ba?"1":"0")+D+Xa;w&&(b+="&ismraid=1");Ia&&(b+=
"&isovv=1");var Ub=b,g="";try{var u=window._dv_win,g=g+("&chro="+(void 0===u.chrome?"0":"1")),g=g+("&hist="+(u.history?u.history.length:"")),g=g+("&winh="+u.innerHeight),g=g+("&winw="+u.innerWidth),g=g+("&wouh="+u.outerHeight),g=g+("&wouw="+u.outerWidth);u.screen&&(g+="&scah="+u.screen.availHeight,g+="&scaw="+u.screen.availWidth)}catch(gc){}b=Ub+(g||"");"http:"==b.match("^http:")&&"https"==window._dv_win.location.toString().match("^https")&&(b+="&dvp_diffSSL=1");var tb=J&&J.parentElement&&J.parentElement.tagName&&
"HEAD"===J.parentElement.tagName;if(!1===Aa||tb)b+="&dvp_isBodyExistOnLoad="+(Aa?"1":"0"),b+="&dvp_isOnHead="+(tb?"1":"0");ib&&(b+="&"+ib);jb&&(b+="&"+jb);var S="srcurl="+encodeURIComponent(O);window._dv_win.$dv.DebugInfo.srcurl=O;var ka;var la=window._dv_win[va("=@42E:@?")][va("2?46DE@C~C:8:?D")];if(la&&0<la.length){var Ka=[];Ka[0]=window._dv_win.location.protocol+"//"+window._dv_win.location.hostname;for(var ma=0;ma<la.length;ma++)Ka[ma+1]=la[ma];ka=Ka.reverse().join(",")}else ka=null;ka&&(S+="&ancChain="+
encodeURIComponent(ka));var T=dv_GetParam(b,"uid");null==T?(T=dv_GetRnd(),b+="&uid="+T):(T=dv_GetRnd(),b=b.replace(/([?&]uid=)(?:[^&])*/i,"$1"+T));var na=4E3;/MSIE (\d+\.\d+);/.test(navigator.userAgent)&&7>=new Number(RegExp.$1)&&(na=2E3);var ub=navigator.userAgent.toLowerCase();if(-1<ub.indexOf("webkit")||-1<ub.indexOf("chrome")){var vb="&referrer="+encodeURIComponent(window._dv_win.location);b.length+vb.length<=na&&(b+=vb)}if(navigator&&navigator.userAgent){var wb="&navUa="+encodeURIComponent(navigator.userAgent);
b.length+wb.length<=na&&(b+=wb)}dv_aUrlParam.length+dv_aUrlDepth.length+b.length<=na&&(b+=dv_aUrlDepth,S+=dv_aUrlParam);var oa=Cb(),b=b+("&vavbkt="+oa.vdcd),b=b+("&lvvn="+oa.vdcv),b=b+("&"+this.getVersionParamName()+"="+this.getVersion()),b=b+("&eparams="+encodeURIComponent(va(S)));""!=oa.err&&(b+="&dvp_idcerr="+encodeURIComponent(oa.err));b+="&brid="+a+"&brver="+d+"&bridua="+c;window._dv_win.$dv.DebugInfo.dvp_BRID=a;window._dv_win.$dv.DebugInfo.dvp_BRVR=d;window._dv_win.$dv.DebugInfo.dvp_BRIDUA=
c;var U;void 0!=window._dv_win.$dv.CommonData.Scenario?U=window._dv_win.$dv.CommonData.Scenario:(U=this.getTrafficScenarioType(window._dv_win),window._dv_win.$dv.CommonData.Scenario=U);b+="&tstype="+U;window._dv_win.$dv.DebugInfo.dvp_TS=U;var pa="";try{window.top==window?pa="1":window.top.location.host==window.location.host&&(pa="2")}catch(hc){pa="3"}var qa=window._dv_win.document.visibilityState,xb=function(){var a=!1;try{a=w&&"function"===typeof w.getState&&"loading"===w.getState()}catch(d){b+=
"&dvp_mrgsf=1"}return a},La=xb();if("prerender"===qa||La)b+="&prndr=1",La&&(b+="&dvp_mrprndr=1");var yb="dvCallback_"+(window._dv_win.dv_config&&window._dv_win.dv_config.dv_GetRnd?window._dv_win.dv_config.dv_GetRnd():dv_GetRnd()),Vb=this.dv_script;window._dv_win[yb]=function(a,d,c,f){var h=getCurrentTime();j=!0;z=c;d.$uid=c;var g=Ta(rb);a.tags.add(c,g);g=Ta(b);a.tags[c].set(g);a.tags[c].beginVisitCallbackTS=h;a.tags[c].set({tagElement:Vb,dv_protocol:$,protocol:Gb,uid:c});a.tags[c].ImpressionServedTime=
getCurrentTime();a.tags[c].getTimeDiff=function(){return(new Date).getTime()-this.ImpressionServedTime};try{"undefined"!=typeof f&&null!==f&&(a.tags[c].ServerPublicDns=f),a.tags[c].adServingScenario=pa,a.tags[c].t2tIframeCreationTime=Wa,a.tags[c].t2tProcessed=!1,a.tags[c].t2tIframeId=C.id,a.tags[c].t2tIframeWindow=C.contentWindow,$dv.t2tEventDataZombie[C.id]&&(a.tags[c].uniquePageViewId=$dv.t2tEventDataZombie[C.id].uniquePageViewId,$dv.processT2TEvent($dv.t2tEventDataZombie[C.id],a.tags[c]))}catch(q){}a.messages&&
a.messages.startSendingEvents&&a.messages.startSendingEvents(d,c);!0==s&&a.registerEventCall(c,{prplyd:0,dvvidver:l});var p=function(){var b=window._dv_win.document.visibilityState;"prerender"===qa&&("prerender"!==b&&"unloaded"!==b)&&(qa=b,a.tags[c].set({prndr:0}),a.registerEventCall(c,{prndr:0}),a&&a.pubSub&&a.pubSub.publishHistoryRtnEvent(c),window._dv_win.document.removeEventListener(k,p))},A=function(){"function"===typeof w.removeEventListener&&w.removeEventListener("ready",A);a.tags[c].set({prndr:0});
a.registerEventCall(c,{prndr:0});a&&a.pubSub&&a.pubSub.publishHistoryRtnEvent(c)};if("prerender"===qa)if(d=window._dv_win.document.visibilityState,"prerender"!==d&&"unloaded"!==d)a.tags[c].set({prndr:0}),a.registerEventCall(c,{prndr:0}),a&&a.pubSub&&a.pubSub.publishHistoryRtnEvent(c);else{var k;"undefined"!==typeof window._dv_win.document.hidden?k="visibilitychange":"undefined"!==typeof window._dv_win.document.mozHidden?k="mozvisibilitychange":"undefined"!==typeof window._dv_win.document.msHidden?
k="msvisibilitychange":"undefined"!==typeof window._dv_win.document.webkitHidden&&(k="webkitvisibilitychange");window._dv_win.document.addEventListener(k,p,!1)}else La&&(xb()?"function"===typeof w.addEventListener&&w.addEventListener("ready",A):(a.tags[c].set({prndr:0}),a.registerEventCall(c,{prndr:0}),a&&a.pubSub&&a.pubSub.publishHistoryRtnEvent(c)));try{var m;a:{var d=window,f={visit:{prefix:"v",stats:[{name:"duration",prefix:"dur"}]}},n;if(d.frames)for(h=0;h<d.frames.length;h++)if((n=e(d.frames[h],
f))&&i(n)){m=n;break a}m=void 0}m&&$dv.registerEventCall(c,m)}catch(r){}};var ra;try{var Ma=0,sa=function(a,b){b&&32>a&&(Ma=(Ma|1<<a)>>>0)},Wb=function(a,b){return function(){return a.apply(b,arguments)}},Xb="svg"===document.documentElement.nodeName.toLowerCase(),zb=function(){return"function"!==typeof document.createElement?document.createElement(arguments[0]):Xb?document.createElementNS.call(document,"http://www.w3.org/2000/svg",arguments[0]):document.createElement.apply(document,arguments)},Yb=
["Moz","O","ms","Webkit"],Zb=["moz","o","ms","webkit"],v={style:zb("modernizr").style},Na=function(a,b,c,d,e){var f=a.charAt(0).toUpperCase()+a.slice(1),h=(a+" "+Yb.join(f+" ")+f).split(" ");if("string"===typeof b||"undefined"===typeof b){a:{c=h;a=function(){i&&(delete v.style,delete v.modElem)};e="undefined"===typeof e?!1:e;if("undefined"!==typeof d&&(f=nativeTestProps(c,d),"undefined"!==typeof f)){b=f;break a}for(var i,g,j,f=["modernizr","tspan","samp"];!v.style&&f.length;)i=!0,v.modElem=zb(f.shift()),
v.style=v.modElem.style;h=c.length;for(f=0;f<h;f++)if(g=c[f],j=v.style[g],~(""+g).indexOf("-")&&(g=cssToDOM(g)),void 0!==v.style[g])if(!e&&"undefined"!==typeof d){try{v.style[g]=d}catch(k){}if(v.style[g]!=j){a();b="pfx"==b?g:!0;break a}}else{a();b="pfx"==b?g:!0;break a}a();b=!1}return b}h=(a+" "+Zb.join(f+" ")+f).split(" ");for(g in h)if(h[g]in b){if(!1===c)return h[g];d=b[h[g]];return"function"===typeof d?Wb(d,c||b):d}return!1};sa(0,!0);var Oa;var H="requestFileSystem",Ab=window;0===H.indexOf("@")?
Oa=atRule(H):(-1!=H.indexOf("-")&&(H=cssToDOM(H)),Oa=Ab?Na(H,Ab,void 0):Na(H,"pfx"));sa(1,!!Oa);sa(2,window.CSS?"function"==typeof window.CSS.escape:!1);sa(3,Na("shapeOutside","content-box",!0));ra=Ma}catch(ic){ra=0}ra&&(b+="&m1="+ra);for(var Bb,ta="auctionid vermemid source buymemid anadvid ioid cpgid cpid sellerid pubid advcode iocode cpgcode cpcode pubcode prcpaid auip auua".split(" "),Pa=[],V=0;V<ta.length;V++){var Qa=dv_GetParam(rb,ta[V]);null!=Qa&&(Pa.push("dvp_"+ta[V]+"="+Qa),Pa.push(ta[V]+
"="+Qa))}(Bb=Pa.join("&"))&&(b+="&"+Bb);return b+"&jsCallback="+yb};this.sendRequest=function(a){window._dv_win.t2tTimestampData.push({beforeVisitCall:getCurrentTime()});var d=this.dv_script_obj&&this.dv_script_obj.injScripts,c=this.getVersionParamName(),e=this.getVersion(),i=window._dv_win.dv_config=window._dv_win.dv_config||{};i.tpsErrAddress=i.tpsAddress||"tps30.doubleverify.com";i.cdnAddress=i.cdnAddress||"cdn.doubleverify.com";var s={};s[c]=e;s.dvp_jsErrUrl=a;s.dvp_jsErrMsg=encodeURIComponent("Error loading visit.js");
c=dv_CreateAndGetErrorImp(i.tpsErrAddress+"/visit.jpg?ctx=818052&cmp=1619415&dvtagver=6.1.src&dvp_isLostImp=1",s);d='<html><head><script type="text/javascript">('+function(){try{window.$dv=window.$dv||parent.$dv,window.$dv.dvObjType="dv",window.$frmId=Math.random().toString(36)+Math.random().toString(36)}catch(a){}}.toString()+')();<\/script></head><body><script type="text/javascript">('+(d||"function() {}")+')("'+i.cdnAddress+'");<\/script><script type="text/javascript" id="TPSCall" src="'+a+'"><\/script><script type="text/javascript">('+
function(a){var c=document.getElementById("TPSCall");try{c.onerror=function(){try{(new Image).src=a}catch(c){}}}catch(d){}c&&c.readyState?(c.onreadystatechange=function(){"complete"==c.readyState&&document.close()},"complete"==c.readyState&&document.close()):document.close()}.toString()+')("'+c+'");<\/script></body></html>';a=Sa("about:blank");i=a.id.replace("iframe_","");a.setAttribute&&a.setAttribute("data-dv-frm",i);ua(a,this.dv_script);if(this.dv_script){this.dv_script.id="script_"+i;var i=this.dv_script,
j;a:{c=null;try{if(c=a.contentWindow){j=c;break a}}catch(l){}try{if(c=window._dv_win.frames&&window._dv_win.frames[a.name]){j=c;break a}}catch(z){}j=null}i.dvFrmWin=j}if(j=Ra(a))j.open(),j.write(d);else{try{document.domain=document.domain}catch(I){}j=encodeURIComponent(d.replace(/'/g,"\\'").replace(/\n|\r\n|\r/g,""));a.src='javascript: (function(){document.open();document.domain="'+window.document.domain+"\";document.write('"+j+"');})()"}return!0};this.isApplicable=function(){return!0};this.onFailure=
function(){window._dv_win._dvScriptsInternal.unshift(this.dv_script_obj);var a=window._dv_win.dvProcessed,d=this.dv_script_obj;null!=a&&(void 0!=a&&d)&&(d=a.indexOf(d),-1!=d&&a.splice(d,1));return window._dv_win.$dv.DebugInfo};this.getTrafficScenarioType=function(a){var a=a||window,d=a._dv_win.$dv.Enums.TrafficScenario;try{if(a.top==a)return d.OnPage;for(var c=0;a.parent!=a&&1E3>c;){if(a.parent.document.domain!=a.document.domain)return d.CrossDomain;a=a.parent;c++}return d.SameDomain}catch(e){}return d.CrossDomain};
this.getVersionParamName=function(){return"jsver"};this.getVersion=function(){return"128"}};


function dv_src_main(dv_baseHandlerIns, dv_handlersDefs) {

    this.baseHandlerIns = dv_baseHandlerIns;
    this.handlersDefs = dv_handlersDefs;

    this.exec = function () {
        try {
            window._dv_win = (window._dv_win || window);
            window._dv_win.$dv = (window._dv_win.$dv || new dvType());

            window._dv_win.dv_config = window._dv_win.dv_config || {};
            window._dv_win.dv_config.tpsErrAddress = window._dv_win.dv_config.tpsAddress || 'tps30.doubleverify.com';

            var errorsArr = (new dv_rolloutManager(this.handlersDefs, this.baseHandlerIns)).handle();
            if (errorsArr && errorsArr.length > 0) {
                dv_SendErrorImp(window._dv_win.dv_config.tpsErrAddress + '/visit.jpg?ctx=818052&cmp=1619415&dvtagver=6.1.src', errorsArr);
            }
        }
        catch (e) {
            try {
                dv_SendErrorImp(window._dv_win.dv_config.tpsErrAddress + '/visit.jpg?ctx=818052&cmp=1619415&dvtagver=6.1.src&jsver=0&dvp_isLostImp=1', {dvp_jsErrMsg: encodeURIComponent(e)});
            } catch (e) { }
        }
    };
}

try {
    window._dv_win = window._dv_win || window;
    var dv_baseHandlerIns = new dv_baseHandler();
	

    var dv_handlersDefs = [];
    (new dv_src_main(dv_baseHandlerIns, dv_handlersDefs)).exec();
} catch (e) { }