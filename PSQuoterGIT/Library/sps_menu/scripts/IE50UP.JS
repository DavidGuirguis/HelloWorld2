// _lcid="1033" _version="11.0.5510"
// _localBinding
// Version: "11.0.5510"
// Copyright (c) Microsoft Corporation.  All rights reserved.
	var StrNewNamespace = "http://schemas.microsoft.com/WebPart/v2";
	function SplitIndex(Index)
	{
		var sPropURN = "";
		var sPropName = "";
		var pos = Index.lastIndexOf("#");
		if( -1 == pos )
		{
			pos = Index.lastIndexOf(":");
		}
		if( -1 == pos )
		{
			sPropName = Index;
		}
		else
		{
			sPropName = Index.substring(pos+1, Index.length);
			sPropURN = Index.substring(0, pos);
		}
		var Splitted = {PropURN : sPropURN, PropName : sPropName};
		return Splitted;
	}
	function String2XML(Value)
	{
			var XMLString = "";
			var re = /&/g;
			XMLString = Value.replace(re,"&amp;");
			re = /</g;
			XMLString = XMLString.replace(re,"&lt;");
			re = />/g;
			XMLString = XMLString.replace(re,"&gt;");
			re = /"/g;
			XMLString = XMLString.replace(re,"&quot;");
			re = /'/g;
			XMLString = XMLString.replace(re,"&apos;");
			return XMLString;
	}
	function URL2Unicode(strURL)
	{
		return Utf8ToUnicode(unescape(strURL));
	}
	function Unicode2URL(strUnicode)
	{
		return URLEncode(strUnicode);
	}
	function URLEncode(strURL)
	{
		var strSpecialUrl = " <>\"#%{}|^~[]`'&?+=";
		var strEncode="";
		var i;
		var chUrl;
		var iCode;
		strURL+="";
		for (i=0; i<strURL.length; i++)
		{
			chUrl = strURL.charAt(i);
			iCode = chUrl.charCodeAt(0);
			if (iCode<=parseInt(0x7F))
			{
				if (strSpecialUrl.indexOf(chUrl) != -1)
				{
					strEncode+="%"+iCode.toString(16).toUpperCase();
				}
				else
				{
					strEncode+=chUrl;
				}
			}
			else
			{
				strEncode += GetUTFCode(iCode);
			}
		}
		return strEncode;
	}
	function GetUTFCode(UniCode)
	{
		var BitLen = 11;
		var ByteLen = 2;
		var UTFCode = "";
		var FirstByte = 0xC0;	
		var i;
		while(UniCode >= (1<<BitLen))
		{
			FirstByte = FirstByte>>1;
			BitLen+=5;
			ByteLen++;
		}
		for( i = 0; i < ByteLen; i++ )
		{
			var Code = 0x80 | (UniCode & 0x3f);
			UniCode = UniCode >>> 6;
			if( i == ByteLen-1 )
			{
				Code |= FirstByte;
			}
			UTFCode = "%"+Code.toString(16).toUpperCase() + UTFCode;
		}
		return UTFCode;
	}
	function Utf8ToUnicode(strUtf8)
	{
		if(strUtf8 == null)
		{
			return "";
		}
		var bstr = "";
		var nTotalChars = strUtf8.length;	
		var nOffset = 0;					
		var nRemainingBytes = nTotalChars;	
		var nOutputPosition = 0;
		var iCode, iCode1, iCode2;			
		while (nOffset < nTotalChars)
		{
			iCode = strUtf8.charCodeAt(nOffset);
			if ((iCode & 0x80) == 0)			
			{
				if ( nRemainingBytes < 1 )
				{	
					break;
				}
				bstr += String.fromCharCode(iCode & 0x7F);
				nOffset ++;
				nRemainingBytes -= 1;
			}
			else if ((iCode & 0xE0) == 0xC0)	
			{
				iCode1 =  strUtf8.charCodeAt(nOffset + 1);
				if ( nRemainingBytes < 2 ||			
				   (iCode1 & 0xC0) != 0x80 )		
				{
					break;
				}
				bstr += String.fromCharCode(((iCode & 0x3F) << 6) | (iCode1 & 0x3F));
				nOffset += 2;
				nRemainingBytes -= 2;
			}
			else if ((iCode & 0xF0) == 0xE0)	
			{
				iCode1 =  strUtf8.charCodeAt(nOffset + 1);
				iCode2 =  strUtf8.charCodeAt(nOffset + 2);
				if ( nRemainingBytes < 3   ||		
				   (iCode1 & 0xC0) != 0x80 ||		
			  	   (iCode2 & 0xC0) != 0x80 )
				{
					break;
				}
				bstr += String.fromCharCode(((iCode & 0x0F) << 12) | 
						((iCode1 & 0x3F) <<  6) |
						(iCode2 & 0x3F));
				nOffset += 3;
				nRemainingBytes -= 3;
			}
			else
			{
				break;
			}
		}
		if (0 != nRemainingBytes)
		{
			bstr = "";
		}
		return bstr;
	}
	function SPSoapRequestBuilder(functionName)
	{
		var object = new Object();
		function AddParameter(parameterName, parameterValue)
		{
			var index = this.parameterNameList.length;
			this.parameterNameList[index] = parameterName;
			this.parameterValueList[index] = parameterValue;
		}
		function SendSOAPMessage(xmlhttp)
		{
			var funcName = this.functionName;
			var paramNames = this.parameterNameList;
			var paramValues = this.parameterValueList;
			xmlhttp.setRequestHeader("Content-Type", "text/xml; charset=utf-8");
			xmlhttp.setRequestHeader("SOAPAction", "http://microsoft.com/sharepoint/webpartpages/" + funcName);
			var soapData = 	'<?xml version="1.0" encoding="utf-8"?>' +
							'<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
							'<soap:Body>' +
							'<' + funcName + ' xmlns="http://microsoft.com/sharepoint/webpartpages">';
			for(var i=0; i < paramNames.length; i++)
			{
				var soapParam = (typeof(paramValues[i]) == "string") ? String2XML(paramValues[i]) : paramValues[i];
				soapData += 	'<' + paramNames[i] + '>' + soapParam + '</' + paramNames[i] + '>';
			}
			soapData +=		'</' + funcName + '>' +
							'</soap:Body>' +
							'</soap:Envelope>'
			xmlhttp.Send(soapData);
			return xmlhttp;
		}
		object.functionName = functionName;
		object.parameterNameList = new Array();
		object.parameterValueList = new Array();
		object.AddParameter = AddParameter;
		object.SendSOAPMessage = SendSOAPMessage;
		return object;
	}
	function Collection()
	{
		function Item(Index)
		{
			var Obj = null;
			if(Index != null)
			{
				var realIndex = parseInt(Index);
				if (!isNaN(realIndex) && realIndex >= 0 && realIndex < this.length)
					Obj = this[realIndex];
			}
			return Obj;
		}
		function Find(Object)
		{
			var i;
			var obj = null;
			for (i=0; i<this.length; i++)
			{
				if (this[i] == Object)
				{
					obj = this[i];
					break;
				}
			}
			return obj;
		}
		function FindByName(Name, Qualifier)
		{
			var i;
			var obj = null;
			for (i=0; i<this.length; i++)
			{
				if (this[i].Name == Name && this[i].Qualifier == Qualifier)
				{
					obj = this[i];
					break;
				}
			}
			return obj;
		}
		function Add(Object)
		{
			var ArraySize = this.length;
			this[ArraySize] = Object;
			return this[ArraySize];
		}
		function Remove(Index)
		{
			var i;
			var realIndex = parseInt(Index);
			if (isFinite(realIndex) && realIndex >= 0 && realIndex < this.length)
			{
				for (i=realIndex; i<this.length-1; i++)
					this[i] = this[i+1];
				this.length--;
			}
		}
		function RemoveObject(Object)
		{
			var i;
			for (i=0; i<this.length; i++)
			{
				if (this[i] == Object)
				{
					this.Remove(i);
					break;
				}
			}
		}
		function Count()
		{
			return this.length;
		}
		var obj = Array();
		obj.Item = Item;
		obj.Count = Count;
		obj.Add = Add;
		obj.Remove = Remove;
		obj.Find = Find;
		obj.FindByName = FindByName;
		obj.RemoveObject = RemoveObject;
		return obj;
	}
	function PartDef(WebPartQualifier, StorageKey, DOMObject)
	{
		function GetPropertyXmlString(propertyNode)
		{
			var differentNameSpace = (propertyNode.NamespaceURN.toLowerCase() != StrNewNamespace.toLowerCase());
			return currentXML = "<" + propertyNode.SchemaElement + ((differentNameSpace) ? " xmlns='" + String2XML(propertyNode.NamespaceURN) + "'": " ") +  ">" + String2XML(propertyNode.Value.toString()) + "</" + propertyNode.SchemaElement + ">";
		}
		function Save(async, callBack)
		{
			if(!this.Properties.PropertiesLoaded)
			{
				return;
			}
			var partDWP = "<WebPart xmlns= '" + StrNewNamespace + "'>" + 
							GetPropertyXmlString(this.Properties.AssemblyInfo) + 
							GetPropertyXmlString(this.Properties.TypeNameInfo);
			for(var index=0; index < this.Properties.length; index++)
			{
				partDWP += GetPropertyXmlString(this.Properties[index]);
			}
			partDWP += "</WebPart>";
			try
			{
				var varPart = eval('varPart' + this.WebPartQualifier);
				var xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
				this.xmlhttp = xmlhttp;
				varPart.callBackUsed = false;
				xmlhttp.Open('POST', WPSC.WebPartPage.WebURL + '/_vti_bin/WebPartPages.asmx',(async != true) ? false : true);
				if (callBack != null)
				{
					this.callBackFunction = callBack;
					xmlhttp.onreadystatechange= new Function("varPart" + this.WebPartQualifier + ".SaveHandler()");
				}
				var soapBuilder = SPSoapRequestBuilder("SaveWebPart");
				soapBuilder.AddParameter("pageUrl", document.location.href);
				soapBuilder.AddParameter("storageKey", this.StorageKey);
				soapBuilder.AddParameter("webPartXml", partDWP);
				soapBuilder.SendSOAPMessage(xmlhttp);
			}
			catch(exception) 
			{
				var varPart = eval('varPart' + this.WebPartQualifier);
				if(callBack != null && varPart.callBackUsed != true)
				{
					callBack(false, "");
					varPart.callBackUsed = true;
				}
			}
		}
		function SaveHandler()
		{
			var varPart = eval('varPart' + this.WebPartQualifier);
			if(this.xmlhttp.readyState == 4 && this.callBackFunction != null && varPart.callBackUsed != true)
			{
				var saveSucceeded = (this.xmlhttp.responseXML.getElementsByTagName("SaveWebPartResponse")[0] != null);
				var soapStatus = this.xmlhttp.status;
				var soapExceptionText = "";
				if(!saveSucceeded)
				{
					var soapException = this.xmlhttp.responseXML.getElementsByTagName("soap:Fault")[0];
					if(soapException != null)
					{
						var soapExceptionTextXml = soapException.getElementsByTagName("detail")[0];
						if(soapExceptionTextXml != null)
						{
							soapExceptionText = soapExceptionTextXml.text;
						}
					}
				}
				varPart.callBackUsed = true;
				this.callBackFunction(saveSucceeded, soapExceptionText, soapStatus);
			}
		}
		this.SaveHandler = SaveHandler;
		this.DOMObject = DOMObject;
		this.WebPartQualifier = WebPartQualifier;
		this.StorageKey = StorageKey;
		this.Properties = new PropColDef();
		this.Properties.Owner = this;
		this.Save = Save;
	}
	function PropertyDef(URN, SchemaElement, Value)
	{
		this.OriginalValue = Value;
		this.NamespaceURN = URN;
		this.SchemaElement = SchemaElement;
		this.Value = Value;
	}
	function PropColDef()
	{
		var PropCol = new Collection();
		function GetPropCol(ItemID, bGlobal)
		{
			var returnValues = new Array();
			try
			{
				var xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
				if (xmlhttp == null) return;
				xmlhttp.Open('POST', WPSC.WebPartPage.WebURL + '/_vti_bin/WebPartPages.asmx', false);
				var soapBuilder = SPSoapRequestBuilder("GetWebPart");
				soapBuilder.AddParameter("pageurl", document.location.href);
				soapBuilder.AddParameter("storageKey", ItemID);
				soapBuilder.AddParameter("storage", 'None');
				soapBuilder.SendSOAPMessage(xmlhttp);			
				xmlhttp.responseXML.loadXML(xmlhttp.responseXML.text);
				var webPartXML = xmlhttp.responseXML.getElementsByTagName("WebPart")[0];
				if(webPartXML)
				{
					var propertiesListXML = webPartXML.childNodes;
					for(var index = 0; index < propertiesListXML.length; index++)
					{
						var node = propertiesListXML.item(index);
						var prop = new PropertyDef(node.namespaceURI, node.baseName, node.nodeTypedValue);
						returnValues[returnValues.length] = prop;
					}
				}
				else
				{
					alert(MSOStrings.GetPropertiesFailure);
				}
			}
			catch (e)
			{
				alert(MSOStrings.GetPropertiesFailure);
			}
			return returnValues;
		}
		function FindProp(Index)
		{
			var nIndex = -1;
			var property = null;
			if (isNaN(Index))
			{
				var Splitted = SplitIndex(Index);
				var PropURN = Splitted.PropURN;
				var PropName = Splitted.PropName;
				var i;
				for (i=0; i<PropCol.Count(); i++)
				{
					var Item = PropCol[i];
					var itemNamespace = new String(Item.NamespaceURN);
					var schemaMatch = (Item.SchemaElement.toLowerCase() == PropName.toLowerCase());
					var namespaceMatch = (itemNamespace.toLowerCase() == PropURN.toLowerCase());
					if(schemaMatch && namespaceMatch)
					{
						nIndex = i;
						property = Item;
						break;
					}
				}
			}
			else
			{
				if (Index < 0 || Index >= PropCol.Count())
				{
					nIndex = -1;
					property = null;
				}
				else
				{
					nIndex = Index;
					property = PropCol[Index]
				}
			}
			return property;
		}
		function Item(Index)
		{	
			var Property = null;
			if(Index != null)
			{
				if(!(this.PropertiesLoaded))
				{
					this.LoadProperties();
				}
				Property = FindProp(Index);
			}
			return Property;
		}
		function Init(Properties, Owner)
		{
			this.Owner = Owner;
			for(var i = 0; i < Properties.length; i++)
			{
				var node = Properties[i];
				if(node.SchemaElement ==  "Assembly")
				{
					this.AssemblyInfo = node;
				}
				else if(node.SchemaElement == "TypeName")
				{
					this.TypeNameInfo = node;
				}
				else
				{
					this[this.length] = node;
				}
			}
		}
		function Count()
		{
			if(!(this.PropertiesLoaded))
			{
				this.LoadProperties();
			}
			return this.length;
		}
		function LoadProperties()
		{
			this.Init(GetPropCol(this.Owner.StorageKey, false), this.Owner);
			this.PropertiesLoaded = true;
		}
		PropCol.Owner = null;				
		PropCol.Item = Item;
		PropCol.Init = Init;
		PropCol.Count = Count;
		PropCol.LoadProperties = LoadProperties;
		PropCol.PropertiesLoaded = false;
		PropCol.AssemblyInfo = null;
		PropCol.TypeNameInfo = null;
		return PropCol;
	}
	function PartColDef()
	{
		var ThisPartCol = new Collection();
		function FindPart(Index)
		{
			var nIndex = -1;
			if (isNaN(Index))
			{
				var i;
				for (i=0; i<ThisPartCol.Count(); i++)
				{
					if (ThisPartCol.Item(i).WebPartQualifier == Index)
					{
						nIndex = i;
						break;
					}
				}
			}
			else
			{
				if (Index < 0 || Index >= ThisPartCol.Count())
					nIndex = -1;
				else
					nIndex = Index;
			}
			return nIndex;
		}
		function Item(Index)
		{
			var Part = null;
			if(Index != null)
			{
				var PartIndex = FindPart(Index);
				if (PartIndex >= 0)
					Part = ThisPartCol.Item(PartIndex);
			}
			return Part;
		}
		function Register(WebPartQualifier, StorageKey, DOMPart)
		{
			var NewPart;
			var PartIndex = FindPart(WebPartQualifier);
			if (PartIndex >= 0)
			{
				NewPart = ThisPartCol.Item(PartIndex);
			}
			else
			{
				NewPart = new PartDef(WebPartQualifier, StorageKey, DOMPart);
				ThisPartCol.Add(NewPart);
				this.Count = ThisPartCol.Count();
			}
			return NewPart;
		}
		function UnRegister(Index)
		{
			ThisPartCol.Remove(FindPart(Index));
			this.Count = ThisPartCol.Count();
		}
		this.Item = Item;
		this.Register = Register;
		this.UnRegister = UnRegister;
		this.Count = ThisPartCol.Count();
	}
	function WebPartPageDef(DOMObj)
	{
		this.Parts = new PartColDef();
		this.DOMObject = DOMObj;
		this.Properties = new PropColDef();
	}
	function EventDef(EventName)
	{
		var EventHandlers = new Collection();
		function FindEventHandler(CallbackFunction)
		{
			return EventHandlers.Find(CallbackFunction);
		}
		function AddHandler(CallbackFunction)
		{
			return EventHandlers.Add(CallbackFunction);
		}
		function RemoveHandler(CallbackFunction)
		{
			EventHandlers.RemoveObject(CallbackFunction);
		}
		function Raise(Param)
		{
			var i;
			for (i=0; i<EventHandlers.Count(); i++)
				EventHandlers.Item(i)(Param);
		}
		this.Name = EventName;
		this.FindEventHandler = FindEventHandler;
		this.AddHandler = AddHandler;
		this.RemoveHandler = RemoveHandler;
		this.Raise = Raise;
	}
	function NotificationServiceDef()
	{
		var Events = new Collection();
		function RegisterSupportedBrowserEvent(eventName, eventFunction)
		{
			switch(eventName)
			{
				case "onafterprint":
				case "onbeforeprint":
				case "onbeforeunload":
				case "onblur":
				case "onclose":
				case "onload":
				case "onresize":
				case "onfocus":
					window.attachEvent(eventName, eventFunction);
					break;
				case "onclick":
				case "onhelp":
					window.document.attachEvent(eventName, eventFunction);
					break;
				default:
					break;
			}
		}
		function UnRegisterSupportedBrowserEvent(eventName, eventFunction)
		{
			switch(eventName)
			{
				case "onafterprint":
				case "onbeforeprint":
				case "onbeforeunload":
				case "onblur":
				case "onclose":
				case "onload":
				case "onresize":
				case "onfocus":
					window.detachEvent(eventName, eventFunction);
					break;
				case "onclick":
				case "onhelp":
					window.document.detachEvent(eventName, eventFunction);
					break;
				default:
					break;
			}
		}
		function RaiseEvent(Namespace, Event, Data)  
		{
			var Event;
			var EventName;
			EventName = Namespace + "::" + Event;
			Event = Events.FindByName(EventName);
			if (null != Event)
				Event.Raise(Data);
		}
		function RegisterForEvent(Namespace, Event, CallbackFunction, Qualifier)
		{
			var EventObject;
			var EventName;
			EventName = Namespace + "::" + Event;
			EventObject = Events.FindByName(EventName, Qualifier);
			if (EventObject == null)
			{
				EventObject = new EventDef(EventName);
				EventObject.Qualifier = Qualifier;
				Events.Add(EventObject);
			}
			if (EventObject.FindEventHandler(CallbackFunction) == null)
			{
				if(Namespace == "urn:schemas-microsoft-com:dhtml")
				{
					RegisterSupportedBrowserEvent(Event, CallbackFunction);
				}
				EventObject.AddHandler(CallbackFunction);
			}
		}
		function UnRegisterForEvent(Namespace, Event, CallbackFunction, Qualifier)
		{
			var EventObject;
			var EventName;
			EventName = Namespace + "::" + Event;
			EventObject = Events.FindByName(EventName, Qualifier);
			if ((EventObject != null) && (EventObject.FindEventHandler(CallbackFunction) != null))
			{
				if(Namespace == "urn:schemas-microsoft-com:dhtml")
				{
					UnRegisterSupportedBrowserEvent(Event, CallbackFunction);
				}
				EventObject.RemoveHandler(CallbackFunction);
			}
		}
		this.RegisterForEvent = RegisterForEvent;
		this.RaiseEvent = RaiseEvent;
		this.UnRegisterForEvent = UnRegisterForEvent;
	}
	function MessageDef(MessageName)
	{
		this.Name = MessageName;
		this.Value = "";
	}
	function StateServiceDef()
	{
		var SaveCallbacks = new Array();
		function IsScriptHREF()
		{
			var returnValue = false;
			if(event != null)
			{
				var srcElement = event.srcElement;
				while(srcElement != null && srcElement.tagName != 'A' && srcElement.tagName != 'BODY')
				{
					srcElement = srcElement.parentElement;
				}
				if(srcElement != null && srcElement.tagName == 'A')
				{
					var href = srcElement.href.toLowerCase( );
					returnValue = (href.indexOf('javascript:') == 0 || href.indexOf('vbscript:') == 0)
				}
			}
			return returnValue;
		}
		function BeforeUnloading()
		{
			if(!MSOWebPartPage_hideNextBeforeUnload)
			{
				try
					{
					if (WPSCinpreview == true)
						{
						}				
					}
				catch (e)
					{
					WPSC.RaiseEvent("urn:schemas-microsoft-com:dhtml","onunload",null);
					}
				ProcessDirtyParts();
			}
			MSOWebPartPage_hideNextBeforeUnload = false;
		}
		function ProcessDirtyParts()
		{
			if (MSOWPSC_SavePerformed == false && SaveCallbacks.length > 0)
			{
				var i;
				var prompt = false;
				for (i=0;i<SaveCallbacks.length;i++)
				{
					SaveCallbacks[i].Dirty = SaveCallbacks[i].IsDirtyCallbackFunction(SaveCallbacks[i].Param);
					prompt = prompt || SaveCallbacks[i].Dirty;
				}
				if (prompt == true && window.confirm(MSOStrings.SaveDirtyPartsDialogText))
				{
					for (i=0;i<SaveCallbacks.length;i++)
					{
						if (SaveCallbacks[i].Dirty == true)
						{
							SaveCallbacks[i].SaveCallbackFunction(SaveCallbacks[i].Param);
							SaveCallbacks[i].Dirty = false;
						}
					}
				}
			}
			if(typeof(event.returnValue) == "undefined")
			{
				MSOWPSC_SavePerformed = true;
			}
		}
		function RegisterForPromptedSave(IsDirtyCallbackFunction, SaveCallbackFunction, Param)
		{
			var Callback = new CallbackParamDef(IsDirtyCallbackFunction, SaveCallbackFunction, Param);
			SaveCallbacks[SaveCallbacks.length++] = Callback;
		}
		this.BeforeUnloading = BeforeUnloading;
		this.IsScriptHREF = IsScriptHREF;
		this.RegisterForPromptedSave = RegisterForPromptedSave;
		this.ProcessDirtyParts = ProcessDirtyParts;
	}
	function CallbackParamDef(IsDirtyCallbackFunction, SaveCallbackFunction, Param)
	{
		this.IsDirtyCallbackFunction = IsDirtyCallbackFunction;
		this.SaveCallbackFunction = SaveCallbackFunction;
		this.Param = Param;
		this.Dirty = false;
	}
	function WPSCDef() 
	{
		var InternalWebPartPage;
		var NotificationService = new NotificationServiceDef();
		function FirePartCommunicationEvents(connectedParts, isInit)
		{		
			var interfaceObject;
			for (var i = 0; i < connectedParts.length; i++)
			{
				interfaceObject = eval(connectedParts[i]);
				if (interfaceObject != null)
				{
					if (isInit)
					{
						try
						{
							interfaceObject.PartCommunicationInit(WPSC);
						}
						catch (e)
						{
						}
					}
					else
					{
						try
						{
							interfaceObject.PartCommunicationMain();
						}
						catch (e)
						{
						}	
					}
				}
			}
		}
		function InitPartCommunication()
		{
			var xmlNodes;
			if (MSOConnections == null)
				return;
			xmlNodes = MSOConnections.selectNodes("Connections/Connection");
			if (xmlNodes == null)
				return;
			var connectedParts = new Array();
			var isProviderInList = false;
			var isConsumerInList = false;
			var xmlProviderRef = null;
			var xmlConsumerRef = null;
			for (var i = 0; i < xmlNodes.length; i++)
			{
				xmlProviderRef = xmlNodes.item(i).selectSingleNode("@ProviderObject"); 
				xmlConsumerRef = xmlNodes.item(i).selectSingleNode("@ConsumerObject");			
				isProviderInList = false;
				isConsumerInList = false;
				if (xmlProviderRef != null && xmlConsumerRef != null)
				{			
					for (var j =0; j < connectedParts.length; j++)
					{
						if (connectedParts[j] == xmlProviderRef.text)
						{
							isProviderInList = true;
						}
						if (connectedParts[j] == xmlConsumerRef.text)
						{
							isConsumerInList = true;
						}
					}
					if (!isProviderInList)
					{
						connectedParts[connectedParts.length] = xmlProviderRef.text;
					}		
					if (!isConsumerInList)
					{
						connectedParts[connectedParts.length] = xmlConsumerRef.text;
					}
				}
			}
			FirePartCommunicationEvents(connectedParts, true); 
			FirePartCommunicationEvents(connectedParts, false); 
		}
		function RaiseConnectionEventSpecial(InterfaceName, EventName, EventArgsNames, EventArgsValues)
		{
			var eventArgs = new Object();
			var tempNames = ConvertVBArrayIfNecessary(EventArgsNames);
			var tempValues = ConvertVBArrayIfNecessary(EventArgsValues);
			if (tempNames.length == tempValues.length)
			{
				for (var i = 0; i < tempNames.length; i++)
				{
					eval("eventArgs." + tempNames[i] + " = ConvertVBArrayIfNecessary(tempValues[i])");
				}
				RaiseConnectionEvent(InterfaceName, EventName, eventArgs);
			}
		}
		function ConvertVBArrayIfNecessary(vbarray)
		{
			try
			{
				var a = new VBArray(vbarray);
				return a.toArray();
			}
			catch(e)
			{
				return vbarray;
			}
		}
		function RaiseConnectionEvent(InterfaceName, EventName, EventParams)
		{
		   	var fProvider = false;
 			var xmlNodes;
 			var xmlSourceRef;
			var xmlTargetRef;
 			var strEval;
		   	if (MSOConnections.selectSingleNode("Connections/Connection[@ProviderIntName = '" + InterfaceName + "']") != null)
		   	{
				fProvider = true;
		   	}
			if (fProvider)
			{
			   	xmlNodes = MSOConnections.selectNodes("Connections/Connection[@ProviderIntName ='" + InterfaceName + "']");
			}
			else
			{
				xmlNodes = MSOConnections.selectNodes("Connections/Connection[@ConsumerIntName ='" + InterfaceName + "']");
			}
			if (xmlNodes != null)
			{
				for (var i = 0; i < xmlNodes.length; i++)
				{
					if (fProvider)
					{
						xmlSourceRef =xmlNodes.item(i).selectSingleNode("@ProviderObject"); 
						xmlTargetRef = xmlNodes.item(i).selectSingleNode("@ConsumerObject");
					}
					else
					{
						xmlSourceRef =xmlNodes.item(i).selectSingleNode("@ConsumerObject"); 
						xmlTargetRef = xmlNodes.item(i).selectSingleNode("@ProviderObject");
					}
					if (xmlSourceRef != null && xmlTargetRef != null)
					{
						strEval = xmlTargetRef.text;
						strEval += "." + EventName;
						strEval += "(" + xmlSourceRef.text + ", EventParams)";
						eval (strEval);
					}			
				}
			}			
		}
		function RegisterForPromptedSave(IsDirtyCallbackFunction, SaveCallbackFunction, Param)
		{
			StateService.RegisterForPromptedSave(IsDirtyCallbackFunction, SaveCallbackFunction, Param);
		}
		function Init(DOMObj)
		{
			window.attachEvent("onbeforeunload", StateService.BeforeUnloading);
			document.body.attachEvent("onclick", new Function("if(StateService.IsScriptHREF()) {MSOWebPartPage_hideNextBeforeUnload = true;}"));
			this.WebPartPage = new WebPartPageDef(DOMObj);
			return this.WebPartPage;
		}
		function Convert(InputString, InputType, OutputType)
		{
			var Converted = InputString;
			if( "URL" == InputType )
			{
				if( "UNICODE" == OutputType )
					Converted = URL2Unicode(InputString);
			}
			else if( "UNICODE" == InputType )
			{
				if( "URL" == OutputType )
					Converted = Unicode2URL(InputString);
			}
			return Converted;
		}
		function MSOMenu_GetMenuItem(MenuClientID, MenuOptionID)
		{
			var menuItem = null;
			var menu = document.all.item(MenuClientID);
			if(menu != null)
			{
				menuItem = menu.all.item(MenuOptionID);
			}
			return menuItem;
		}
		function MSOMenu_SetChecked(MenuClientID, MenuOptionID, SetValue)
		{
			var menuItem = MSOMenu_GetMenuItem(MenuClientID, MenuOptionID);
			if(menuItem != null)
			{
				menuItem.checked = (SetValue) ? 'true' : 'false';
			}
		}
		function MSOMenu_SetVisible(MenuClientID, MenuOptionID, SetValue)
		{
			var menuItem = MSOMenu_GetMenuItem(MenuClientID, MenuOptionID);
			if(menuItem != null)
			{
				menuItem.style.display = (SetValue) ? '' : 'none';
			}
		}
		function MSOMenu_SetEnabled(MenuClientID, MenuOptionID, SetValue)
		{
			var menuItem = MSOMenu_GetMenuItem(MenuClientID, MenuOptionID);
			if(menuItem != null)
			{
				menuItem.disabled = !(SetValue == true);
			}
		}
		function MSOMenu_GetChecked(MenuClientID, MenuOptionID)
		{
			var menuItem = MSOMenu_GetMenuItem(MenuClientID, MenuOptionID);
			if(menuItem != null)
			{
				return (menuItem.checked == 'true') ? true : false;
			}
			return null;
		}
		function MSOMenu_GetVisible(MenuClientID, MenuOptionID)
		{
			var menuItem = MSOMenu_GetMenuItem(MenuClientID, MenuOptionID);
			if(menuItem != null)
			{
				return (menuItem.style.display != 'none') ? true : false;
			}
			return null;
		}
		function MSOMenu_GetEnabled(MenuClientID, MenuOptionID)
		{
			var menuItem = MSOMenu_GetMenuItem(MenuClientID, MenuOptionID);
			if(menuItem != null)
			{
				return (menuItem.disabled != true) ? true : false;
			}
			return null;
		}
		this.RaiseConnectionEvent = RaiseConnectionEvent;
		this.RaiseConnectionEventSpecial = RaiseConnectionEventSpecial;
		this.InitPartCommunication = InitPartCommunication;
		this.RaiseEvent = NotificationService.RaiseEvent;   
		this.RegisterForEvent = NotificationService.RegisterForEvent;
		this.UnRegisterForEvent = NotificationService.UnRegisterForEvent;
		this.RegisterForPromptedSave = RegisterForPromptedSave;
		this.Init = Init;
		this.WebPartPage = InternalWebPartPage;
		this.Convert = Convert;
		this.MSOMenu_SetChecked = MSOMenu_SetChecked;
		this.MSOMenu_SetVisible = MSOMenu_SetVisible;
		this.MSOMenu_SetEnabled = MSOMenu_SetEnabled;
		this.MSOMenu_GetChecked = MSOMenu_GetChecked;
		this.MSOMenu_GetVisible = MSOMenu_GetVisible;
		this.MSOMenu_GetEnabled = MSOMenu_GetEnabled;
	}
var StateService = new StateServiceDef();
var WPSC = new WPSCDef();
var MSOWPSC_SavePerformed = false;
function MSOWPSC_OnSubmit()
{
	StateService.ProcessDirtyParts();
}
function Row2ParamsIn_GetRow(paramsInIntName,rowFields,paramsInNames)
{
	var paramsIndex = new Array(paramsInNames.length);
	var fieldsIndex = new Array(paramsInNames.length);
	for (var i = 0; i < paramsIndex; i++)
		paramsIndex[i] = -1;
	for (var i = 0; i < fieldsIndex; i++)
		fieldsIndex[i] = -1;
	var params = paramsInNames;
	var fieldNames = rowFields;
	var name = paramsInIntName;
	var paramsLength = 0;
	this.RowProviderInit = Row2ParamsIn_RowProviderInit;
	this.RowReady = Row2ParamsIn_RowReady;
	this.ParametersInConsumerInit = Row2ParamsIn_ParamsInInit;
	function Row2ParamsIn_ParamsInInit(sender,args)
	{
		var paramProps = args.ParameterInProperties;
		paramsLength = paramProps.length;
		if (paramProps != null && paramProps.length > 0)
			for (var i = 0; i < paramProps.length; i++)
				for (var j= 0; j < params.length; j++)
					if ((paramProps[i]).ParameterName == params[j])
						paramsIndex[j] = i;
	}
	function Row2ParamsIn_RowProviderInit(sender,args)
	{
		var fields = args.FieldList;
		if (fields != null && fields.length > 0)
			for (var i = 0; i < fields.length; i++)
				for (var j= 0; j < fieldNames.length; j++)
					if (fields[i] == fieldNames[j])
						fieldsIndex[j] = i;
	}
	function Row2ParamsIn_ParamsInReadyArgs(value)
	{
		this.ParameterValues = value;
	}	
	function Row2ParamsIn_RowReady(sender,args)
	{
		var rs = args.Rows;
		if (args.SelectionStatus == "Standard" || args.SelectionStatus == "New")
		{
			if (rs != null)
			{
				rs.MoveFirst();
				var paramValues = new Array(paramsLength);
				for (var i = 0; i < paramsLength; i++)
				{
					var found = false;
					try
					{
						for (var j= 0; j < paramsIndex.length; j++)
							if (paramsIndex[j] == i)
							{
								if (rs.Fields.Item(fieldsIndex[j]).Value != null)
								{
									var type = rs.Fields.Item(fieldsIndex[j]).Type;
                                    var varValue = rs.Fields.Item(fieldsIndex[j]).Value;
									paramValues[i] = String(varValue);
                                    if (type == 12)
                                    {
                                        if (typeof(varValue) == "date") 
                                        {
                                            paramValues[i] = P2P_DateToString(paramValues[i]);
                                        }
                                    }
									else if (type == 7 || type == 133 || type == 134 || type == 135)
									{
										paramValues[i] = P2P_DateToString(paramValues[i]);
									}
								}
								else
								{
									paramValues[i] = "";
								}
								found = true;
							}
					}
					catch( e )
					{
						found = false;
					}
					if (!found)
						paramValues[i] = "";
				}
				WPSC.RaiseConnectionEvent(name, "ParametersInReady", new Row2ParamsIn_ParamsInReadyArgs(paramValues));
			}
		}
		else
			WPSC.RaiseConnectionEvent(name, "NoParametersIn", null);
	}
}
function Row2Cell_GetRow(cellIntName,xform)
{
	var field = xform;
	var index = -1;
	var name = cellIntName;
	this.RowProviderInit = Row2Cell_RowProviderInit;
	this.RowReady = Row2Cell_RowReady;
	function Row2Cell_RowProviderInit(sender,args)
	{
		var fields = args.FieldList;
		var fieldDisplayList = args.FieldDisplayList;
		if (fields != null && fields.length > 0)
			for (var i = 0; i < fields.length; i++)
				if (fields[i] == field)
				{
					index = i;
					var displayField = null;
					if (fieldDisplayList != null && fieldDisplayList.length > i)
					{
						displayField = fieldDisplayList[i];
					}
					WPSC.RaiseConnectionEvent(name, "CellProviderInit", new Row2Cell_CellInitArgs(field, displayField));
				}
	}
	function Row2Cell_CellInitArgs(name, displayName)
	{
		this.FieldName = name;
		this.FieldDisplayName = displayName;
	}
	function Row2Cell_CellReadyArgs(value)
	{
		this.Cell = value;
	}
	function Row2Cell_RowReady(sender,args)
	{
		var rs = args.Rows;
		if (rs != null)
		{
			rs.MoveFirst();
			if (args.SelectionStatus && (args.SelectionStatus == "Standard" || args.SelectionStatus == "New") && index != -1 && rs.Fields != null && rs.Fields.Item(index) != null)
				WPSC.RaiseConnectionEvent(name, "CellReady", new Row2Cell_CellReadyArgs(rs.Fields.Item(index).Value));
			else
				WPSC.RaiseConnectionEvent(name, "CellReady", new Row2Cell_CellReadyArgs(null));
		}
	}
}
function Row2Cell_GetCell()
{
	this.CellConsumerInit = Row2Cell_CellInit;
	function Row2Cell_CellInit(sender,args){}
}
function Row2Filter_GetFilter()
{
	this.FilterConsumerInit = Row2Filter_FilterInit;
	function Row2Filter_FilterInit(sender,args){}
}
function Row2Filter_GetRow(filterIntName,fieldFilter,fieldRow)
{
	var field = fieldRow;
	var filter = fieldFilter;
	var index = -1;
	var name = filterIntName;
	this.RowProviderInit = Row2Filter_RowInit;
	this.RowReady = Row2Filter_RowReady;
	function Row2Filter_RowInit(sender,args)
	{
		var fields = args.FieldList;
		if (fields != null && fields.length > 0)
			for (var i = 0; i < fields.length; i++)
				if (fields[i] == field)
					index = i;
	}
	function Row2Filter_SetFilterArgs(value)
	{
		this.FilterExpression = value;
	}
	function P2P_DateToString(dateString)
	{
		function MakeNumberTwoDigits(number)
		{
			if (number < 10)
				return "0" + number;
			else
				return number;
		}
		var date = new Date(Date.parse(dateString));
		var newValue = MakeNumberTwoDigits(date.getMonth()+1) + "/";
		newValue += MakeNumberTwoDigits(date.getDate()) + "/";
		newValue += date.getFullYear() + " ";
		newValue += MakeNumberTwoDigits(date.getHours()) + ":";
		newValue += MakeNumberTwoDigits(date.getMinutes()) + ":";
		newValue += MakeNumberTwoDigits(date.getSeconds());
		return newValue;
	}
	function Row2Filter_RowReady(sender,args)
	{
		var rs = args.Rows;
		if ((args.SelectionStatus == "Standard" || args.SelectionStatus == "New") && index != -1)
		{
			if (rs != null)
			{
				rs.MoveFirst();
				var filterValue = "";
				try
				{
					if (rs.Fields.Item(index).Value != null)
					{
                        var varValue = rs.Fields.Item(index).Value;
						var type = rs.Fields.Item(index).Type;
						filterValue = String(varValue);
                        if (type == 12)
                        {
                            if (typeof(varValue) == "date") 
                            {
                                filterValue = P2P_DateToString(filterValue);
                            }
                        }
						else if (type == 7 || type == 133 || type == 134 || type == 135)
						{
							filterValue = P2P_DateToString(filterValue);
						}
					}
				}
				catch (e)
				{
				}
				WPSC.RaiseConnectionEvent(name, "SetFilter", new Row2Filter_SetFilterArgs("FilterField1=" +WPSC.Convert(filter, "UNICODE", "URL")  + "&FilterValue1=" + WPSC.Convert(filterValue, "UNICODE", "URL")));
			}
			else
			{
				WPSC.RaiseConnectionEvent(name, "SetFilter", new Row2Filter_SetFilterArgs("FilterField1=" + WPSC.Convert(filter, "UNICODE", "URL") + "&FilterValue1="));
			}
		}
		else
			WPSC.RaiseConnectionEvent(name, "NoFilter", null);
	}
}
function ParamsOut2In_GetParamsOut(paramsInIntName, paramsOutNames, paramsInNames)
{
	var paramsInIndex = new Array(paramsInNames.length);
	var paramsOutIndex = new Array(paramsInNames.length);
	var paramsIn = paramsInNames;
	var paramsOut = paramsOutNames;
	var name = paramsInIntName;
	var paramsInLength = 0;
	this.ParametersOutProviderInit = ParamsOut2In_ParamsOutProviderInit;
	this.ParametersOutReady = ParamsOut2In_ParamsOutReady;
	this.ParametersInConsumerInit = ParamsOut2In_ParamsInInit;
	this.NoParametersOut = ParametersOut2In_NoParametersOut;
	function ParametersOut2In_NoParametersOut(sender, args)
	{
		WPSC.RaiseConnectionEvent(name, "NoParametersIn", null);
	}
	function ParamsOut2In_ParamsInInit(sender, args)
	{
		var paramProps = args.ParameterInProperties;
		paramsInLength = paramProps.length		
		if (paramProps != null && paramProps.length > 0)
			for (var i = 0; i < paramProps.length; i++)
				for (var j= 0; j < paramsIn.length; j++)
					if ((paramProps[i]).ParameterName == paramsIn[j])
						paramsInIndex[j] = i;
	}
	function ParamsOut2In_ParamsOutProviderInit(sender, args)
	{
		var paramProps = args.ParameterOutProperties;
		if (paramProps != null && paramProps.length > 0)
			for (var i = 0; i < paramProps.length; i++)
				for (var j= 0; j < paramsOut.length; j++)
					if ((paramProps[i]).ParameterName == paramsOut[j])
						paramsOutIndex[j] = i;
	}
	function ParamsOut2In_ParamsInReadyArgs(value)
	{
		this.ParameterValues = value;
	}
	function ParamsOut2In_ParamsOutReady(sender, args)
	{
		var tempParams = args.ParameterValues;
		if (tempParams != null && tempParams.length > 0)
		{
			var paramValues = new Array(paramsInLength);
			for (var i = 0; i < paramsInLength; i++)
			{
				var found = false;
				for (var j= 0; j < paramsInIndex.length; j++)
				{
					if (paramsInIndex[j] == i)
					{
						paramValues[i] = tempParams[paramsOutIndex[j]];
						found = true;
					}
				}
				if (!found)
					paramValues[i] = "";
			}
			WPSC.RaiseConnectionEvent(name, "ParametersInReady", new ParamsOut2In_ParamsInReadyArgs(paramValues));
		}
	}
}
function MSOLayout_MinimizeRestoreDownLevel(webPartGUID,frameState,source)
{
	var newFrameState = (frameState == "Minimized") ? "1" : "0";
	document.forms[MSOWebPartPageFormName].MSOLayout_LayoutChanges.value = webPartGUID + ",frameState," + newFrameState;
	document.forms[MSOWebPartPageFormName].MSOWebPartPage_PostbackSource.value=source;
	document.forms[MSOWebPartPageFormName].submit();
}
function MSOLayout_RemoveWebPartDownLevel(webPartGUID, isSelected)
{
	document.forms[MSOWebPartPageFormName].MSOLayout_LayoutChanges.value = webPartGUID + ",isIncluded,False";
	document.forms[MSOWebPartPageFormName].MSOWebPartPage_PostbackSource.value=22;
	if(isSelected)
	{
		MSOTlPn_ShowToolPane(0);
	}
	else
	{
		document.forms[MSOWebPartPageFormName].submit();
	}
}
var MSOTlPn_prevBuilder=null;
var MSOTlPn_prevWidth = 0;
var MSOTlPn_prevHeight = 0;
var MSOTlPn_shownViewChangeWarning = false;
var MSOWebPartPage_hideNextBeforeUnload = false;
var MSOWebPartPage_partDeleted = "";
function MSOLayout_CheckAndSaveChanges()
{
	if(document.forms[MSOWebPartPageFormName].MSOLayout_LayoutChanges != null && document.forms[MSOWebPartPageFormName].MSOLayout_LayoutChanges.value != "")
	{
		MSOLayout_SaveChanges();
	}
}
function MSOWebPartPage_ExportCheckWarning(address, hasPersonalizations)
{
	var doexport = true;
	if (hasPersonalizations)
	{
		if (!confirm(MSOStrings.ExportPersonalizationDialogText))
		{
			doexport = false;
		}
	}
	if (doexport)
	{
		var oldSavePerformed = false;
		if(typeof(MSOWPSC_SavePerformed) == "boolean")
		{
			oldSavePerformed = MSOWPSC_SavePerformed;
		}
		MSOWebPartPage_SetWindowLocation(address);
		if(typeof(MSOWPSC_SavePerformed) == "boolean")
		{
			MSOWPSC_SavePerformed = oldSavePerformed;
			MSOWebPartPage_hideNextBeforeUnload = true;
		}	
	}
}
function MSOMode_SetMode(bAllUsers)
{
	var newUrl = MSOMode_GetNewUrl(bAllUsers);
	MSOLayout_CheckAndSaveChanges();
	if(document.forms[MSOWebPartPageFormName].MSOTlPn_View.value != 4)
	{
		document.forms[MSOWebPartPageFormName].MSOTlPn_View.value = 0;
		var toolPaneViewExpression = /[& | \?]ToolPaneView=[-0-9A-Z]*/ig;
		newUrl = MSOMode_RemoveMode(newUrl, toolPaneViewExpression);
	}
	document.forms[MSOWebPartPageFormName].MSOWebPartPage_Shared.value = bAllUsers ? "true" : "false";
	document.forms[MSOWebPartPageFormName].action = newUrl;
	document.forms[MSOWebPartPageFormName].submit();
}
function MSOMode_GetNewUrl(bAllUsers, newUrl)
{
	if (newUrl==null)
	{
		newUrl = document.location.href;
	}
	var personalViewExpression = /[& | \?]PageView=Personal/ig;
	var allUsersViewExpression = /[& | \?]PageView=Shared/ig;
	var newMode = "PageView=" + (bAllUsers ? "Shared" : "Personal");
	newUrl = MSOMode_RemoveMode(newUrl, personalViewExpression);
	newUrl = MSOMode_RemoveMode(newUrl, allUsersViewExpression);
	newUrl = MSOMode_AddMode(newUrl, allUsersViewExpression, newMode);
	return newUrl;
}
function MSOMode_RemoveMode(newUrl, regExpression)
{
	var hashMarkExpression = /\#/;
	var hashMarkIndex = newUrl.search(hashMarkExpression);
	if(hashMarkIndex != -1)
	{
		newUrl = newUrl.substring(0, hashMarkIndex);
	}
	var questionMarkExpression = /\?/;
	var questionMarkIndex = newUrl.search(questionMarkExpression);
	if(questionMarkIndex != -1)
	{
		var pathString = newUrl.substring(0, questionMarkIndex);
		var queryString = newUrl.substring(questionMarkIndex, newUrl.length);
		queryString = queryString.replace(regExpression,'');
		if(queryString.length != 0 && queryString.charAt(0) != '?')
		{
			queryString = "?" + queryString;
		}
		newUrl = pathString + queryString;
	}
	return newUrl;
}
function MSOMode_AddMode(newUrl, regExpression, stringToAdd)
{
	var hashMarkExpression = /\#/;
	var hashMarkIndex = newUrl.search(hashMarkExpression);
	if(hashMarkIndex != -1)
	{
		newUrl = newUrl.substring(0, hashMarkIndex);
	}
	var questionMarkExpression = /\?/;
	var questionMarkIndex = newUrl.search(questionMarkExpression);
	if(questionMarkIndex == -1 )
	{
		newUrl += '?' + stringToAdd; 
	}
	else
	{
		var queryString = newUrl.substring(questionMarkIndex, newUrl.length);
		if(queryString.search(regExpression) == -1)
		{
			newUrl += '&' + stringToAdd; 
		}		
	}
	return newUrl;
}
function MSOPGrid_BuilderVisible(builderID)
{
	MSOPGrid_HidePrevBuilder();
	MSOTlPn_prevBuilder=null;
	builderID.style.display='inline';
}
function MSOPGrid_HidePrevBuilder()
{
	if(MSOTlPn_prevBuilder !=null)
	{
		eval(MSOTlPn_prevBuilder).style.display='none'; 
	}
}
function MSOPGrid_doBuilder(builderUrl, editorId, dialogFeatures)
{
	var pReturnValue=showModalDialog(builderUrl,editorId,dialogFeatures);
	editorId.value=pReturnValue;
//@cc_on
//@if (@_jscript_version >= 5)
//@		try { editorId.focus(); } catch (exception) {}
//@else
//@end
}
function MSOWebPartPage_RestorePageDefault()
{
	if(confirm(MSOStrings.ResetPagePersonalizationDialogText))
	{
		var newInput = document.createElement('INPUT');
		//@cc_on
		//@if (@_jscript_version >= 5)
		//@		try
		//@else
		//@end
		{
			newInput.type='hidden';
		}
		//@cc_on
		//@if (@_jscript_version >= 5)
		//@		catch(e){newInput.style.display = 'none';}
		//@else
		//@end
		newInput.name = 'MSOWebPartPage_RestorePageDefault';
		newInput.value = 'true';
		document.forms[MSOWebPartPageFormName].appendChild(newInput);
		if(document.forms[MSOWebPartPageFormName].MSOLayout_LayoutChanges != null)
		{
			document.forms[MSOWebPartPageFormName].MSOLayout_LayoutChanges.value = ""
		}
		MSOMode_SetMode(false);
	}
}
function MSOWebPartPage_RestorePartDefaults(webPartID)
{
	if(confirm(MSOStrings.ResetPartPersonalizationDialogText))
	{
		var newInput = document.createElement('INPUT');
		//@cc_on
		//@if (@_jscript_version >= 5)
		//@		try
		//@else
		//@end
		{
			newInput.type='hidden';
		}
		//@cc_on
		//@if (@_jscript_version >= 5)
		//@		catch(e){newInput.style.display = 'none';}
		//@else
		//@end
		newInput.name = 'MSO_RestoreSettings';
		newInput.value = webPartID;
		document.forms[MSOWebPartPageFormName].appendChild(newInput);
		MSOMode_SetMode(false);
	}
}
function MSOWebPartPage_MenuDoPostBack(eventTarget, eventArgument) 
{
	var theform = document.forms[MSOWebPartPageFormName];
	var eventTargetField = theform.__EVENTTARGET;
	var eventArgumentField = theform.__EVENTARGUMENT;
	if(eventTargetField == null)
	{
		eventTargetField = document.createElement('INPUT');
		eventTargetField.style.display = 'none';
		eventTargetField.name = '__EVENTTARGET';
		document.forms[MSOWebPartPageFormName].appendChild(eventTargetField);
	}
	if(eventArgumentField == null)
	{
		eventArgumentField = document.createElement('INPUT');
		eventArgumentField.style.display = 'none';
		eventArgumentField.name = '__EVENTARGUMENT';
		document.forms[MSOWebPartPageFormName].appendChild(eventArgumentField);
	}
	eventTargetField.value = eventTarget;
	eventArgumentField.value = eventArgument;
	theform.submit();
}
function MSOWebPartPage_SignIn()
{
	var newInput = document.createElement('INPUT');
	//@cc_on
	//@if (@_jscript_version >= 5)
	//@		try
	//@else
	//@end
	{
		newInput.type='hidden';
	}
	//@cc_on
	//@if (@_jscript_version >= 5)
	//@		catch(e){newInput.style.display = 'none';}
	//@else
	//@end
	newInput.name = 'MSOWebPartPage_AnonymousAccessLogIn';
	newInput.value = "1";
	document.forms[MSOWebPartPageFormName].appendChild(newInput);
	document.forms[MSOWebPartPageFormName].submit();
}
function MSOWebPartPage_SetWindowLocation(newLocation)
{
	var newLocationLowerCase = newLocation.toLowerCase();
	if(newLocationLowerCase.indexOf('javascript:') == 0 || newLocationLowerCase.indexOf('vbscript:') == 0)
	{
		MSOWebPartPage_hideNextBeforeUnload = true;
	}
	window.location = newLocation;
}
function MSOWebPartPage_SetNewWindowLocation(newLocation)
{
	window.open(newLocation);
}
function MSOTlPn_onToolPaneCloseClick()
{
	var ToolPaneViewClosed = '0';
	var PostbackSourceSettingsHide = '49';
	MSOTlPn_ShowToolPaneWrapper(ToolPaneViewClosed, PostbackSourceSettingsHide);
}
function MSOPGrid_InvokeFPBuilder(type,arguments,editorCtrl)
{
	editorCtrl.value=window.external.InvokeBuilder(type,arguments,editorCtrl.id);
	editorCtrl.focus();
}
function MSOMenu_KeyboardClick(widget)
{
	for(var index=1; index < arguments.length; index++)
	{
		if(event.keyCode == arguments[index])
		{
			widget.click();
			event.returnValue = false;
			return;
		}
	}
}
function MSOTlPn_ToggleDisplay(strID,strImgName,strAnchorName,strAltExpandText,strAltCollapseText, strImageAnchorName)
{
	var fieldID= strID+'_STATEFIELD';
	var stateFieldValue;
	if( document.all.item(strID).style.display == 'none' )
	{
		document.all.item(strID).style.display = '';
		document.images[strImgName].src = '/_layouts/images/TPMin2.gif';
		document.images[strImgName].alt = strAltCollapseText;
		document.all.item(strImageAnchorName).title = strAltCollapseText;
		document.all.item(strAnchorName).title = strAltCollapseText;
		stateFieldValue = "1";
	}
	else
	{
		document.all.item(strID).style.display = 'none';
		document.images[strImgName].src = '/_layouts/images/TPMax2.gif';
		document.images[strImgName].alt = strAltExpandText;
		document.all.item(strImageAnchorName).title = strAltExpandText;
		document.all.item(strAnchorName).title= strAltExpandText;
		stateFieldValue = "0";
	}
	if(document.all[fieldID] != null)
	{
		document.all[fieldID].value = stateFieldValue;
	}
}			
var MSOTlPn_originalToolPaneWidth;
function MSOTlPn_onToolPaneMaxClick()
{
	var mod = 1;
	var minMaxIcon = document.all['MSOTlPn_minMaxIcon'];
	var newSrc = minMaxIcon.src.substring(0, minMaxIcon.src.lastIndexOf('/')+1);
	if (document.all['MSOTlPn_Tbl'].toolpaneWide == null)
	{
		MSOTlPn_originalToolPaneWidth = document.all['MSOTlPn_Tbl'].style.width;
		document.all['MSOTlPn_Tbl'].style.width = (parseInt(document.all['MSOTlPn_Tbl'].offsetWidth)+100).toString()+"px";
		newSrc += ((document.dir == "rtl") ? "tpmax.gif" : "tpmin.gif"); 
		minMaxIcon.title = MSOStrings.ToolPaneShrinkToolTip;
		minMaxIcon.alt = MSOStrings.ToolPaneShrinkToolTip;
		minMaxIcon.parentElement.title = MSOStrings.ToolPaneShrinkToolTip;
		document.all['MSOTlPn_Tbl'].toolpaneWide = "1";
	}
	else
	{
		document.all['MSOTlPn_Tbl'].style.width = MSOTlPn_originalToolPaneWidth;
		newSrc += ((document.dir == "rtl") ? "tpmin.gif" : "tpmax.gif"); 
		minMaxIcon.title = MSOStrings.ToolPaneWidenToolTip;
		minMaxIcon.alt = MSOStrings.ToolPaneWidenToolTip;
		minMaxIcon.parentElement.title = MSOStrings.ToolPaneWidenToolTip;
		document.all['MSOTlPn_Tbl'].toolpaneWide = null;
		mod = -1;
	}
	minMaxIcon.src = newSrc;
	var x = document.all['MSOTlPn_Tbl'];
	for(var i = 0; i < x.all.length; i++)
	{
//@cc_on
//@if (@_jscript_version >= 5)
//@		try
//@else
//@end
		{
			if (x.all(i).getAttribute('ms-TlPnWiden')=="true")
			{			
			   x.all(i).style.pixelWidth += mod*120;
			}
		}
//@cc_on
//@if (@_jscript_version >= 5)
//@		catch (e)
//@else
//@end
		{
		}
	}
	MSOTlPn_WindowResize();
}
function MSOTlPn_WindowResize()
{	
	var objToolPane = document.all['MSOTlPn_MainTD'];
	if (objToolPane == null || objToolPane.offsetWidth == 0) return;
	var widthToolPane = objToolPane.offsetWidth;
	var docFrame = (document.body.offsetWidth - document.body.clientWidth);
	var spDiv = document.all['MSOTlPn_WebPartPageDiv'];
	if ((spDiv.offsetWidth + objToolPane.offsetWidth) == document.body.clientWidth)
	{
		return;
	}
	var widthAncestors = 0;
	var next = spDiv.offsetParent;
	var elementWidth = 0;
	while (next != null)
	{
	    if (document.dir != "rtl")
	    {
		    elementWidth = next.offsetLeft + (next.offsetWidth - (next.clientLeft + next.clientWidth));
		    if (next.offsetParent != null)
		    {
		        elementWidth += next.offsetParent.clientLeft;
		    }
	    }
	    else
	    {
		    elementWidth = (next.offsetParent != null) ? (next.offsetParent.offsetWidth - (next.offsetLeft + next.offsetWidth)) : 0;
	    }
		widthAncestors += elementWidth;
		next = next.offsetParent;	
	}
	widthAncestors -= docFrame;
	var widthCenter = document.body.clientWidth - (widthAncestors + widthToolPane);
	if (widthCenter < 250) 
		widthCenter = 250;
	document.all['MSO_tblPageBody'].style.pixelWidth = widthCenter +widthToolPane;
	spDiv.style.pixelWidth = widthCenter;	
	if (window.event.type == "load" && document.all.MSOTlPn_TlPnCaptionSpan!= null)
		document.all.MSOTlPn_TlPnCaptionSpan.scrollIntoView(false);
}
function MSOTlPn_CheckUrl()
{
	var toolPaneViewExpression = /[& | \?]ToolPaneView=[-0-9A-Z]*/ig;
	var formAction = document.forms[MSOWebPartPageFormName].action;
	var newUrl;
	newUrl = MSOMode_RemoveMode(document.forms[MSOWebPartPageFormName].action, toolPaneViewExpression);
	document.forms[MSOWebPartPageFormName].action = newUrl;
}
function MSOTlPn_Resize(obj)
{
	if (MSOTlPn_prevWidth != obj.clientWidth)
	{
		MSOTlPn_prevWidth = obj.clientWidth;
		MSOTlPn_WindowResize();
	}
	if (MSOTlPn_prevHeight != document.body.clientHeight)
	{
		MSOTlPn_prevHeight = document.body.clientHeight;
		var spDiv = document.all['MSOTlPn_WebPartPageDiv'];
		spDiv.style.height = "100%";
		spDiv.style.height = spDiv.offsetHeight;
	}
}
function MSOWebPartPage_SetupFixedWidthWebParts()
{
	var fixedWidthTitles = document.all['MSOFixedWidthTitle'];
	if(fixedWidthTitles != null)
	{
		if(fixedWidthTitles.length > 0)
		{
			for(var elementIndex = 0; elementIndex < fixedWidthTitles.length; elementIndex++)
			{
				fixedWidthTitles[elementIndex].style.width = MSOWebPartPage_AllocateSpaceForFirstTD(fixedWidthTitles[elementIndex]);
			}
		}
		else
		{
			fixedWidthTitles.style.width = MSOWebPartPage_AllocateSpaceForFirstTD(fixedWidthTitles);
		}
	}
}
function MSOWebPartPage_AllocateSpaceForFirstTD(titleDiv)
{
	var tempElement = document.createElement("DIV");
	tempElement.style.width = titleDiv.fixedWidth;
	document.body.appendChild(tempElement);
	var pixelSize = tempElement.offsetWidth;
	document.body.removeChild(tempElement);
	var tempTable = MSOLayout_GetParentTable(titleDiv).cloneNode(true); 
	if(tempTable != 0) 
	{
		document.body.appendChild(tempTable);
		var tempTableRow = tempTable.rows(0);
		for(var index = 1; index < tempTableRow.cells.length; index++)
		{
			pixelSize -= tempTableRow.cells(index).offsetWidth;
		}
		document.body.removeChild(tempTable);
	}
	return (pixelSize < 1) ? 1 : pixelSize;
}
function MSOWebPartPage_FindControlName(name)
{
   var labelcollection = document.all.tags("label");
   if (labelcollection != null)
   {
	   for (i = 0; i < labelcollection.length; i++)
	   {
			var label = labelcollection[i];
			if (label.innerText == name)
			{
				if (label.htmlFor.indexOf("_EDITOR") != -1)
				{
					return(label.htmlFor);
				}
			}
	   }
   }
   return null;
}
function MSOTlPn_ListViewChange(strWarningText)
{
    if (MSOTlPn_shownViewChangeWarning)
        return;
    alert(strWarningText);
    MSOTlPn_shownViewChangeWarning = true;
}
function MSOTlPn_CustomWindowResize()
{
	var objToolPane = document.all['MSOTlPn_Tbl'];
	if (objToolPane == null || objToolPane.offsetWidth == 0) return;
	objToolPane.style.pixelWidth = document.body.clientWidth;
}
function MSOTlPn_ShowListFilter()
{
	if (document.all['WebPartListFilter'].style.display == 'none')
	{
		document.all['WebPartListFilter'].style.display = 'block'; 
		document.forms[MSOWebPartPageFormName].MSOGallery_FilterVisible.value = "true";
	}
	else
	{
		document.all['WebPartListFilter'].style.display = 'none';
		document.forms[MSOWebPartPageFormName].MSOGallery_FilterVisible.value = "false";
	}
}
function MSOGallery_GetCookie(name) 
{
	var prefix = name + "=";
	var cookieStartIndex = document.cookie.indexOf(prefix);
	if (cookieStartIndex == -1)
	{
		return null;
	}
	var cookieEndIndex = document.cookie.indexOf(";", cookieStartIndex + prefix.length);
	if (cookieEndIndex == -1)
	{
		cookieEndIndex = document.cookie.length;
	}
	return unescape(document.cookie.substring(cookieStartIndex + prefix.length, cookieEndIndex));
} 
function MSOTlPn_ShowAllUsersToolPane(view, source, storageKey)
{
	MSOLayout_CheckAndSaveChanges();
	document.forms[MSOWebPartPageFormName].action = MSOMode_GetNewUrl(true);
	MSOTlPn_ShowToolPaneWrapper(view, source, storageKey);
}
function MSOLayout_MakeInvisibleIfEmpty()
{
	var allElements = document.getElementsByName("_invisibleIfEmpty"); 
	var agt = navigator.userAgent.toLowerCase();
	var isNav = ((agt.indexOf('mozilla')!=-1)&&((agt.indexOf('spoofer')==-1) && (agt.indexOf('compatible')==-1)));
	var isIE = (agt.indexOf("msie")!=-1);
	for (var curElement = 0; curElement < allElements.length; curElement++) 
	{
		if ((isIE && allElements[curElement].childNodes.length == 0)
			|| (isNav && allElements[curElement].childNodes.length <= 1))
		{
			allElements[curElement].style.display = "none";
		}
	}
}
function MSOLayout_GetParentRow(tableCell)
{
	var parentRow = tableCell.parentElement;
	while(parentRow.tagName != "TR" && parentRow.tagName != "BODY") parentRow = parentRow.parentElement;
	if(parentRow.tagName != "TR")
	{
		return null;
	}
	else
	{
		return parentRow;
	}
}
function MSOLayout_GetParentTable(TableCell)
{
	for (var currentObject = TableCell; currentObject.tagName != 'TABLE'; currentObject = currentObject.parentElement)
	{
		if(currentObject == document.body) return 0;
	}
	return currentObject;
}

// SIG // Begin signature block
// SIG // MIIaJgYJKoZIhvcNAQcCoIIaFzCCGhMCAQExCzAJBgUr
// SIG // DgMCGgUAMGcGCisGAQQBgjcCAQSgWTBXMDIGCisGAQQB
// SIG // gjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIBAAIB
// SIG // AAIBAAIBAAIBADAhMAkGBSsOAwIaBQAEFG/IxT9cCsU8
// SIG // NCjHltBTIKqNxqlOoIIUvDCCArwwggIlAhBKGdI4jIJZ
// SIG // HKVdc18VXdyjMA0GCSqGSIb3DQEBBAUAMIGeMR8wHQYD
// SIG // VQQKExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMRcwFQYD
// SIG // VQQLEw5WZXJpU2lnbiwgSW5jLjEsMCoGA1UECxMjVmVy
// SIG // aVNpZ24gVGltZSBTdGFtcGluZyBTZXJ2aWNlIFJvb3Qx
// SIG // NDAyBgNVBAsTK05PIExJQUJJTElUWSBBQ0NFUFRFRCwg
// SIG // KGMpOTcgVmVyaVNpZ24sIEluYy4wHhcNOTcwNTEyMDAw
// SIG // MDAwWhcNMDQwMTA3MjM1OTU5WjCBnjEfMB0GA1UEChMW
// SIG // VmVyaVNpZ24gVHJ1c3QgTmV0d29yazEXMBUGA1UECxMO
// SIG // VmVyaVNpZ24sIEluYy4xLDAqBgNVBAsTI1ZlcmlTaWdu
// SIG // IFRpbWUgU3RhbXBpbmcgU2VydmljZSBSb290MTQwMgYD
// SIG // VQQLEytOTyBMSUFCSUxJVFkgQUNDRVBURUQsIChjKTk3
// SIG // IFZlcmlTaWduLCBJbmMuMIGfMA0GCSqGSIb3DQEBAQUA
// SIG // A4GNADCBiQKBgQDTLiDwaHwsLS6BHLEGsqcLtxENV9pT
// SIG // 2HXjyTMqstT2CVs08+mQ/gkM0NsbWrnN5/aIsZ3AhyXr
// SIG // fVgQc2p4y3EV/cZY9imrWF6WBP0tYhFYgRzKcZTVIlgv
// SIG // 1cwUBYQ2upSqtE1K6e47Iq1WmX4hnGyGwEpHl2q0pjbV
// SIG // /Akt07Q5mwIDAQABMA0GCSqGSIb3DQEBBAUAA4GBAGFV
// SIG // Dj57x5ISfhEQjiLM1LMTK1voROQLeJ6kfvOnB3Ie4lnv
// SIG // zITjiZRM205h77Ok+0Y9UDQLn3BW9o4qfxfO5WO/eWkH
// SIG // cy6wlSiK9e2qqdJdzQrKEAmPzrOvKJbEeSmEktz/umdC
// SIG // SKaQEOS/YficU+WT0XM/+P2dT4SsVdH9EWNjMIIEAjCC
// SIG // A2ugAwIBAgIQCHptXG9ik0+6xP1D4RQYnTANBgkqhkiG
// SIG // 9w0BAQQFADCBnjEfMB0GA1UEChMWVmVyaVNpZ24gVHJ1
// SIG // c3QgTmV0d29yazEXMBUGA1UECxMOVmVyaVNpZ24sIElu
// SIG // Yy4xLDAqBgNVBAsTI1ZlcmlTaWduIFRpbWUgU3RhbXBp
// SIG // bmcgU2VydmljZSBSb290MTQwMgYDVQQLEytOTyBMSUFC
// SIG // SUxJVFkgQUNDRVBURUQsIChjKTk3IFZlcmlTaWduLCBJ
// SIG // bmMuMB4XDTAxMDIyODAwMDAwMFoXDTA0MDEwNjIzNTk1
// SIG // OVowgaAxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8w
// SIG // HQYDVQQLExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMTsw
// SIG // OQYDVQQLEzJUZXJtcyBvZiB1c2UgYXQgaHR0cHM6Ly93
// SIG // d3cudmVyaXNpZ24uY29tL3JwYSAoYykwMTEnMCUGA1UE
// SIG // AxMeVmVyaVNpZ24gVGltZSBTdGFtcGluZyBTZXJ2aWNl
// SIG // MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
// SIG // wHphh+uypwNjGysaYd6AtxUdoIuQPbsnkoQUOeuFzimS
// SIG // BmZIpANPjehPp/CvXtEvGceR8bWee5Ehzun/407w/K+V
// SIG // WLhjLeaO9ikYzXCOUMPtlrtA274l6EJV1vaF8gbni5kc
// SIG // MfMDD9RMnCQq3Bsbj4LzsO+nTeMUp+CP1sdowmFYqXLU
// SIG // +DBIT9kvb2Mg2YnKgnvCS7woxYFo5+aCQKxGOqD5PzbN
// SIG // TLtUQlp6ZXv+hOTHR1SsuT3sgMca98QzgYHJKpX7f146
// SIG // h5AU28wudfLva+Y9qWC+QgGqT6pbqD8iMZ8SFflzoR6C
// SIG // iwQr6kYCTG2PH1AulUsqeAaEdD2RjyxHMQIDAQABo4G4
// SIG // MIG1MEAGCCsGAQUFBwEBBDQwMjAwBggrBgEFBQcwAYYk
// SIG // aHR0cDovL29jc3AudmVyaXNpZ24uY29tL29jc3Avc3Rh
// SIG // dHVzMAkGA1UdEwQCMAAwRAYDVR0gBD0wOzA5BgtghkgB
// SIG // hvhFAQcBATAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3
// SIG // dy52ZXJpc2lnbi5jb20vcnBhMBMGA1UdJQQMMAoGCCsG
// SIG // AQUFBwMIMAsGA1UdDwQEAwIGwDANBgkqhkiG9w0BAQQF
// SIG // AAOBgQAt809jYCwY2vUkD1KzDOuzvGeFwiPtj0YNzxpN
// SIG // vvN8eiAwMhhoi5K7Mpnwk7g7FQYnez4CBgCkIZKEEwrF
// SIG // mOVAV8UFJeivrxFqqeU7y+kj9pQpXUBV86VTncg2Ojll
// SIG // CHNzpDLSr6y/xwU8/0Xsw+jaJNHOY64Jp/viG+P9QQpq
// SIG // ljCCBBIwggL6oAMCAQICDwDBAIs8PIgR0T72Y+zfQDAN
// SIG // BgkqhkiG9w0BAQQFADBwMSswKQYDVQQLEyJDb3B5cmln
// SIG // aHQgKGMpIDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYD
// SIG // VQQLExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNV
// SIG // BAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eTAeFw05
// SIG // NzAxMTAwNzAwMDBaFw0yMDEyMzEwNzAwMDBaMHAxKzAp
// SIG // BgNVBAsTIkNvcHlyaWdodCAoYykgMTk5NyBNaWNyb3Nv
// SIG // ZnQgQ29ycC4xHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jw
// SIG // b3JhdGlvbjEhMB8GA1UEAxMYTWljcm9zb2Z0IFJvb3Qg
// SIG // QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
// SIG // MIIBCgKCAQEAqQK9wXDmO/JOGyifl3heMOqiqY0lX/j+
// SIG // lUyjt/6doiA+fFGim6KPYDJr0UJkee6sdslU2vLrnIYc
// SIG // j5+EZrPFa3piI9YdPN4PAZLolsS/LWaammgmmdA6LL8M
// SIG // tVgmwUbnCj44liypKDmo7EmDQuOED7uabFVhrIJ8oWAt
// SIG // d0zpmbRkO5pQHDEIJBSfqeeRKxjmPZhjFGBYBWWfHTdS
// SIG // h/en75QCxhvTv1VFs4mAvzrsVJROrv2nem10Tq8YzJYJ
// SIG // KCEAV5BgaTe7SxIHPFb/W/ukZgoIptKBVlfvtjteFoF3
// SIG // BNr2vq6Alf6wzX/WpxpyXDzKvPAIoyIwswaFybMgdxOF
// SIG // 3wIDAQABo4GoMIGlMIGiBgNVHQEEgZowgZeAEFvQcO9p
// SIG // cp4jUX4Usk2O/8uhcjBwMSswKQYDVQQLEyJDb3B5cmln
// SIG // aHQgKGMpIDE5OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYD
// SIG // VQQLExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNV
// SIG // BAMTGE1pY3Jvc29mdCBSb290IEF1dGhvcml0eYIPAMEA
// SIG // izw8iBHRPvZj7N9AMA0GCSqGSIb3DQEBBAUAA4IBAQCV
// SIG // 6AvAjfOXGDXtuAEk2HcR81xgMp+eC8s+BZGIj8k65iHy
// SIG // 8FeTLLWgR8hi7/zXzDs7Wqk2VGn+JG0/ycyq3gV83TGN
// SIG // PZ8QcGq7/hJPGGnA/NBD4xFaIE/qYnuvqhnIKzclLb5l
// SIG // oRKKJQ9jo/dUHPkhydYV81KsbkMyB/2CF/jlZ2wNUfa9
// SIG // 8VLHvefEMPwgMQmIHZUpGk3VHQKl8YDgA7Rb9LHdyFfu
// SIG // ZUnHUlS2tAMoEv+Q1vAIj364l8WrNyzkeuSod+N2oADQ
// SIG // aj/B0jaK4EESqDVqG2rbNeHUHATkqEUEyFozOG5NHA1i
// SIG // twqijNPVVD9GzRxVpnDbEjqHk3Wfp9KgMIIEyTCCA7Gg
// SIG // AwIBAgIQaguZT8AA3qoR1NhAmqi+5jANBgkqhkiG9w0B
// SIG // AQQFADBwMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMpIDE5
// SIG // OTcgTWljcm9zb2Z0IENvcnAuMR4wHAYDVQQLExVNaWNy
// SIG // b3NvZnQgQ29ycG9yYXRpb24xITAfBgNVBAMTGE1pY3Jv
// SIG // c29mdCBSb290IEF1dGhvcml0eTAeFw0wMDEyMTAwODAw
// SIG // MDBaFw0wNTExMTIwODAwMDBaMIGmMQswCQYDVQQGEwJV
// SIG // UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
// SIG // UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
// SIG // cmF0aW9uMSswKQYDVQQLEyJDb3B5cmlnaHQgKGMpIDIw
// SIG // MDAgTWljcm9zb2Z0IENvcnAuMSMwIQYDVQQDExpNaWNy
// SIG // b3NvZnQgQ29kZSBTaWduaW5nIFBDQTCCASAwDQYJKoZI
// SIG // hvcNAQEBBQADggENADCCAQgCggEBAKKEFVPYCzAONJX/
// SIG // OhvC8y97bTcjTfPSjOX9r/3FAjQfJMflodxU7H4CdEer
// SIG // 2zJYFhRRKTjxfrK0jDpHtTlOblTCMQw6bfvNzctQnBuu
// SIG // p9jZSiY/tcXLj5biSfJt2OmWPt4Fz/CmVTetL2DNgGFC
// SIG // oUlUSg8Yt0vZk5kwWkd1ZLTTu922qwydT7hzOxg6qrSH
// SIG // jLCIsE1PH04RtTOA3w06ZG9ExzS9SpObvKYd+QUjTmAp
// SIG // j8wq8oSama2o2wpwe9Y0QZClt2bHXBsdozMOm1QDGj+Y
// SIG // kLjM5z0EdEMcj/c55rOsSHprKg5iAWE5dm79PpgHSxTx
// SIG // AUb9FQDgR9pP5AXkgCUCAQOjggEoMIIBJDATBgNVHSUE
// SIG // DDAKBggrBgEFBQcDAzCBogYDVR0BBIGaMIGXgBBb0HDv
// SIG // aXKeI1F+FLJNjv/LoXIwcDErMCkGA1UECxMiQ29weXJp
// SIG // Z2h0IChjKSAxOTk3IE1pY3Jvc29mdCBDb3JwLjEeMBwG
// SIG // A1UECxMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYD
// SIG // VQQDExhNaWNyb3NvZnQgUm9vdCBBdXRob3JpdHmCDwDB
// SIG // AIs8PIgR0T72Y+zfQDAQBgkrBgEEAYI3FQEEAwIBADAd
// SIG // BgNVHQ4EFgQUKVy5G7bNM+67nll99+XKLsQNNCgwGQYJ
// SIG // KwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQD
// SIG // AgFGMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQEE
// SIG // BQADggEBAEVY4ppBf/ydv0h3d66M2eYZxVe0Gr20uV8C
// SIG // oUVqOVn5uSecLU2e/KLkOIo4ZCJC37kvKs+31gbK6yq/
// SIG // 4BqFfNtRCD30ItPUwG2IgRVEX2SDZMSplCyK25A3Sg+3
// SIG // 6NRhj3Z24dkl/ySElY0EVlSUoRw6PoK87qWHjByMS3lf
// SIG // tUn6XjJpOh9UrXVN32TnMDzbZElE+/vEHEJx5qA9Re5r
// SIG // AJ+sQr26EbNW5PvVoiqB2B9OolW+J49wpqJsG/9UioK8
// SIG // gUumobFmeqkXp8sGwEfrprPpMRVTPSoEv/9zSNyLJ0P8
// SIG // Y+juJIdbvjbR6DH1Mtle33l6ujCsaYZK+4wRvxuNVFkw
// SIG // ggUPMIID96ADAgECAgphBxFDAAAAAAA0MA0GCSqGSIb3
// SIG // DQEBBQUAMIGmMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
// SIG // V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
// SIG // A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSswKQYD
// SIG // VQQLEyJDb3B5cmlnaHQgKGMpIDIwMDAgTWljcm9zb2Z0
// SIG // IENvcnAuMSMwIQYDVQQDExpNaWNyb3NvZnQgQ29kZSBT
// SIG // aWduaW5nIFBDQTAeFw0wMjA1MjUwMDU1NDhaFw0wMzEx
// SIG // MjUwMTA1NDhaMIGhMQswCQYDVQQGEwJVUzETMBEGA1UE
// SIG // CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
// SIG // MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSsw
// SIG // KQYDVQQLEyJDb3B5cmlnaHQgKGMpIDIwMDIgTWljcm9z
// SIG // b2Z0IENvcnAuMR4wHAYDVQQDExVNaWNyb3NvZnQgQ29y
// SIG // cG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
// SIG // ggEKAoIBAQCqmb05qBgn9Cs9C0w/fHcup8u10YwNwjp0
// SIG // 15O14KBLP1lezkVPmnkp8UnMGkfuVcIIPhIg+FXy7l/T
// SIG // 4MqWvDDe/ljIJzLQhVTo8JEQu/MrvhnlA5sLhh3zsDmM
// SIG // uP0LHTxzJqxXK8opohWQghXid6NAUgOLncJwuh/pNPbz
// SIG // NZJOVYP42jC2IN5XBrVaQgbeWcvy36a9FUdxGSUj0stv
// SIG // mxl532pb8XYFeSn8w1bKj0QIhVWKy8gPRktVy4yWd0qH
// SIG // 6KlBBsf/DeloV2Nyw2lXtEPPMjow3Bvp1UMmKnn+ldsi
// SIG // ZyTJL9A04+b7UUmGuDzQJV/W7J4DYYepaEDH+OID5s8F
// SIG // AgMBAAGjggFAMIIBPDAOBgNVHQ8BAf8EBAMCBsAwEwYD
// SIG // VR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFGvIxlEg
// SIG // 8LQv06C2rn9eJrK4h1IpMIGpBgNVHSMEgaEwgZ6AFClc
// SIG // uRu2zTPuu55Zffflyi7EDTQooXSkcjBwMSswKQYDVQQL
// SIG // EyJDb3B5cmlnaHQgKGMpIDE5OTcgTWljcm9zb2Z0IENv
// SIG // cnAuMR4wHAYDVQQLExVNaWNyb3NvZnQgQ29ycG9yYXRp
// SIG // b24xITAfBgNVBAMTGE1pY3Jvc29mdCBSb290IEF1dGhv
// SIG // cml0eYIQaguZT8AA3qoR1NhAmqi+5jBKBgNVHR8EQzBB
// SIG // MD+gPaA7hjlodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
// SIG // cGtpL2NybC9wcm9kdWN0cy9Db2RlU2lnblBDQS5jcmww
// SIG // DQYJKoZIhvcNAQEFBQADggEBADUj/RNU/Onc8N0MFHr6
// SIG // p7PO/ac6yLrl5/YD+1Pbp5mpoJs2nAPrgkccIb0Uy+dn
// SIG // QAnHFpECVc5DQrTNG12w8zIEPRLlHacHp4+jfkVVdhuW
// SIG // lZFp8N0480iJ73BAt9u1VYDAA8QutijcCoIOx0Pjekhd
// SIG // uAaJkkBsbsXc+JrvC74hCowvOrXtp85xh2gj4bPkGH24
// SIG // RwGlK8RYy7KJbF/90yzEb7gjsg3/PPIRRXTyCQaZGN1v
// SIG // wIYBGBIdKxavVu9lM6HqZ070S4Kr6Q/cAfrfYH9mR13L
// SIG // LHDMe07ZBrhujAz+Yh5C+ZN8oqsKntAjEK5NeyeRbya+
// SIG // aPqmP58j68idu4cxggTWMIIE0gIBATCBtTCBpjELMAkG
// SIG // A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
// SIG // BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
// SIG // dCBDb3Jwb3JhdGlvbjErMCkGA1UECxMiQ29weXJpZ2h0
// SIG // IChjKSAyMDAwIE1pY3Jvc29mdCBDb3JwLjEjMCEGA1UE
// SIG // AxMaTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0ECCmEH
// SIG // EUMAAAAAADQwCQYFKw4DAhoFAKCBpjAZBgkqhkiG9w0B
// SIG // CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
// SIG // DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUaBGL
// SIG // /bT+4k7Jbegs82pWYirlU40wRgYKKwYBBAGCNwIBDDE4
// SIG // MDagFIASAGkAZQA1ADAAdQBwAC4AagBzoR6AHGh0dHA6
// SIG // Ly9vZmZpY2UubWljcm9zb2Z0LmNvbSAwDQYJKoZIhvcN
// SIG // AQEBBQAEggEAFNHbA5Pz+uudQa7r8NKL6htj7Yls1prc
// SIG // 5SBBFMC3VRr3utv7d11ihYchIr/2KJt86iNbDlT1uALn
// SIG // i6Rwk/XVfkUEQCMahKtKjDP5qGFEfTBCS6cWJ3iNwM2W
// SIG // 04FHF6cpLHPKhxzC6FtKi0gkm9R7Ne4uwtXyamfQC0CQ
// SIG // CLfB1H+0TaNMTD25Y+Zi53H7o6wNzJqdwvqRzWpbU6gd
// SIG // BddN+D+9CYfkRBrFglOf3CnMROjtG0vId+quEiDpUztn
// SIG // vUZ/L80UOtVskIdCjz6rcxsvabyMz55WgCLsHoOlhbV5
// SIG // +jyx9dsUTeIdjsA8T2IVgFGfVun2s/EcctnYA6Y83NhC
// SIG // YqGCAkwwggJIBgkqhkiG9w0BCQYxggI5MIICNQIBATCB
// SIG // szCBnjEfMB0GA1UEChMWVmVyaVNpZ24gVHJ1c3QgTmV0
// SIG // d29yazEXMBUGA1UECxMOVmVyaVNpZ24sIEluYy4xLDAq
// SIG // BgNVBAsTI1ZlcmlTaWduIFRpbWUgU3RhbXBpbmcgU2Vy
// SIG // dmljZSBSb290MTQwMgYDVQQLEytOTyBMSUFCSUxJVFkg
// SIG // QUNDRVBURUQsIChjKTk3IFZlcmlTaWduLCBJbmMuAhAI
// SIG // em1cb2KTT7rE/UPhFBidMAwGCCqGSIb3DQIFBQCgWTAY
// SIG // BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
// SIG // DQEJBTEPFw0wMzA3MTUwNjA1MzVaMB8GCSqGSIb3DQEJ
// SIG // BDESBBDTc5xkqtMWUWmT/AhpD8LHMA0GCSqGSIb3DQEB
// SIG // AQUABIIBAD4V1uZosLYTUe32hDRQoEiHMxu+53SQAf61
// SIG // B2m3IHEzyokbFBxGOWrVUICqVCQ2L95dhFvczsSOFpgU
// SIG // 2s5ptO7EulwHhkPFpUnL0+cSrPaSe3QRAWzLEhz4INnV
// SIG // a6GHjWrJjn1XnMbVoQa+0aLN3xF4cpbhq0E8NQ/1gw+U
// SIG // hXzGdfQTDgmyLX4//0hftAarRaUQHn1ATZsfmuAsQQTi
// SIG // LBucry0ww4JvoiVvZT4j1M5Rl1pObPr/CGUjZYDnrqpF
// SIG // TxaUVGytJt5QmqnpPSNTODas2ykv0tCYjE7gfk9Puiq2
// SIG // CL+TYvGSs0Nvw0mGjKA9c6n2MsTJU80YjTL4419NvBo=
// SIG // End signature block
