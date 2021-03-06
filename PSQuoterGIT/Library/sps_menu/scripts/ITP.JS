// _lcid="1033" _version="11.0.5510"
// _localBinding
// Version: "11.0.5510"
// Copyright (c) Microsoft Corporation.  All rights reserved.
function MsoImageToolpartBackgroundColorBuilder(url)
{
	document.forms[MSOWebPartPageFormName].MsoImageToolpartBackgroundColorValue.caption = MSOStrings.WebPartBackgroundColor;
	document.forms[MSOWebPartPageFormName].MsoImageToolpartBackgroundColorValue.transparentTooltip = MSOStrings.TransparentTooltip;
	var sColor;
	if (url == null)
	{
		sColor=window.external.InvokeBuilder("color", "", "MsoImageToolpartBackgroundColorValue");
	}
	else
	{
		sColor=showModalDialog(url, document.forms[MSOWebPartPageFormName].MsoImageToolpartBackgroundColorValue, "dialogWidth:26em;dialogHeight:25em;help:no;status:no");
	}
	if (typeof(sColor) != "undefined")
	{
		try
		{
			document.all.MsoImageToolpartbackgroundColorDisplay.style.backgroundColor=sColor;
			if (sColor.toLowerCase() == "transparent")
			{
				document.all.MsoImageToolpartbackgroundColorDisplay.innerText = MSOStrings.TransparentLiteral;
			}
			else
			{
				document.all.MsoImageToolpartbackgroundColorDisplay.innerText = "";
			}
			document.all.MsoImageToolpartBackgroundColorValue.value=sColor;
		}
		catch (e)
		{		
		}
	}
}
function MsoFrameworkToolpartPreview(url,errorMessage,validTypes)
{
	url = url.replace(/(^\s*)|(\s*$)/g,"");	
	if (url.match(/^\s*(https?:\/\/)?\s*$/i)) return;	
	if ((MsoFrameworkToolpartCheckPath(url,validTypes) & validTypes) != 0 )
	{
		window.open(url);
	}
	else
	{
		alert(errorMessage);
	}
}
function MsoFrameworkToolpartCheckPath(url,validTypes)
{
	var testMask=0;
	if (validTypes & 1 || validTypes & 2)
	{
		testMask += 3;	
	}
	if (validTypes & 4 || validTypes & 8)
	{
		testMask += 4;	
	}
	var patterns = [/^(file:\/\/(\\\\|\/\/)?|\\\\)([^\\\/]+[\\\/]?)*$/i, /^(file:\/\/)?[a-zA-Z]:([\\\/][^\\\/]+)*[\\\/]?$/, /^(https?:\/\/|[\\\/])?([^\\\/]+[\\\/]?)*$/i];
	var lastDelimeter;
	var parsedUrl=null;
	for (i=0; i<patterns.length; i++)
	{
		if (testMask & (1 << i))
		{
			parsedUrl = url.match(patterns[i]);
			if (parsedUrl != null)	
			{
				if (i==0 || i==1)
				{
					lastDelimeter = url.lastIndexOf('\\');
					if (lastDelimeter==-1) lastDelimeter = url.lastIndexOf('/');
					if (lastDelimeter == url.length-1)
					{
						return 2;	
					}
					else
					{
						return 3;	
					}
				}
				else	
				{
					return 12;	
				}
			}
		}
	}
	return 0;
}
function MsoFrameworkToolpartHelp(url)
{
	window.open(url);
}

// SIG // Begin signature block
// SIG // MIIaIAYJKoZIhvcNAQcCoIIaETCCGg0CAQExCzAJBgUr
// SIG // DgMCGgUAMGcGCisGAQQBgjcCAQSgWTBXMDIGCisGAQQB
// SIG // gjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIBAAIB
// SIG // AAIBAAIBAAIBADAhMAkGBSsOAwIaBQAEFE+BnmD2nBwH
// SIG // 4Ok2+D/PumhwDX9XoIIUvDCCArwwggIlAhBKGdI4jIJZ
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
// SIG // aPqmP58j68idu4cxggTQMIIEzAIBATCBtTCBpjELMAkG
// SIG // A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
// SIG // BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
// SIG // dCBDb3Jwb3JhdGlvbjErMCkGA1UECxMiQ29weXJpZ2h0
// SIG // IChjKSAyMDAwIE1pY3Jvc29mdCBDb3JwLjEjMCEGA1UE
// SIG // AxMaTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0ECCmEH
// SIG // EUMAAAAAADQwCQYFKw4DAhoFAKCBoDAZBgkqhkiG9w0B
// SIG // CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
// SIG // DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUvu9j
// SIG // 1yyKtaPfsW8SfP8h8hGQBbcwQAYKKwYBBAGCNwIBDDEy
// SIG // MDCgDoAMAGkAdABwAC4AagBzoR6AHGh0dHA6Ly9vZmZp
// SIG // Y2UubWljcm9zb2Z0LmNvbSAwDQYJKoZIhvcNAQEBBQAE
// SIG // ggEASLgmEsEoakCW/hsS7putnyyWMWri0uxT5M1Awg+4
// SIG // 48hzOkLtaKl8Ug9NDi/RSn3ldzgM3GWGikSy7oPxnz0H
// SIG // 5KQa7DAMCFtQnDJwhrfXvEKVAKRNutkcULddlDFs1eP/
// SIG // Vf8i7DtN7wDYiQNh83Qw3NZUjqOljrqFgoNvgKyb2X9p
// SIG // +srxOzpYref7yw5u23GLIrXmCqqotxiK6/0gKVE5gMug
// SIG // pryusCrJGex5jhmulfZxFAbXBuHLy5Kg/mNYRK6SyQV0
// SIG // Rgh6yKQ1iEhtpEPOqJdPKHM+sg3aqN1t/D3Uavk1V04f
// SIG // AWisDplT0p+4cw5v+WkBSR8i2fRy7FgjTAHrm6GCAkww
// SIG // ggJIBgkqhkiG9w0BCQYxggI5MIICNQIBATCBszCBnjEf
// SIG // MB0GA1UEChMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazEX
// SIG // MBUGA1UECxMOVmVyaVNpZ24sIEluYy4xLDAqBgNVBAsT
// SIG // I1ZlcmlTaWduIFRpbWUgU3RhbXBpbmcgU2VydmljZSBS
// SIG // b290MTQwMgYDVQQLEytOTyBMSUFCSUxJVFkgQUNDRVBU
// SIG // RUQsIChjKTk3IFZlcmlTaWduLCBJbmMuAhAIem1cb2KT
// SIG // T7rE/UPhFBidMAwGCCqGSIb3DQIFBQCgWTAYBgkqhkiG
// SIG // 9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEP
// SIG // Fw0wMzA3MTUwNjA0MzVaMB8GCSqGSIb3DQEJBDESBBAE
// SIG // 8EwrfBr4x3NOtiBUhrobMA0GCSqGSIb3DQEBAQUABIIB
// SIG // ABM3bY3tKiYQinLa6xYr+v3Jl7O64/AVMJT1LlIwHbu5
// SIG // bZnPjeF9B5LjoG2mo6uCfH8USuZL1wlCY9c5qx6G+AT6
// SIG // xz8vRs97+lsfxBlU6UMGotD7Mc6X+oXLUM+/AzIY6e6q
// SIG // MG/mD54zqSTgjZQ/6t/de4vJU9J0g18r8w6zk0hkn1kB
// SIG // 8LeImGZfXDmFOhusg6emgPDSwYZvp55RfFNNx8AlQw6f
// SIG // Zy6RFfRoAA+vYAN7zZDUyIjKHoe4ZLBNATQYt7WAAjna
// SIG // ZJVPliesJIO9saUAm4V1seqDMRgnJRNERWsYVFswZCMO
// SIG // ApdMUtXEtbYTzpj9nKSRPEx3Lpw5mR62l70=
// SIG // End signature block
