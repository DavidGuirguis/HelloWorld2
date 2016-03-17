// _lcid="1033" _version="11.0.5510"
// _localBinding
// Version: "11.0.5510"
// Copyright (c) Microsoft Corporation.  All rights reserved.
var L_ContainIllegalChar_Text   = "^1 contains illegal character \'^2\'."; 
var L_ContainIllegalString_Text = "^1 contains illegal characters or substring."; 
var LegalUrlChars = new Array
(
    false, false, false, false, false, false, false, false,     false, false, false, false, false, false, false, false, 
    false, false, false, false, false, false, false, false,     false, false, false, false, false, false, false, false, 
    true,  true, false, false, true, false,  false, true,      true,  true, false, true,  true,  true,  true,  true, 
    true,  true,  true,  true,  true,  true,  true,  true,      true,  true, false,  true, false,  true, false, false, 
    true,  true,  true,  true,  true,  true,  true,  true,      true,  true,  true,  true,  true,  true,  true,  true, 
    true,  true,  true,  true,  true,  true,  true,  true,      true,  true,  true, true, false, true,  true,  true, 
    true,  true,  true,  true,  true,  true,  true,  true,      true,  true,  true,  true,  true,  true,  true,  true, 
    true,  true,  true,  true,  true,  true,  true,  true,      true,  true,  true,  false, false, false, false, false
);
function AdmBuildParam(stPattern)
{
    var re;
    var i;
    for (i = 1; i < AdmBuildParam.arguments.length; i++)
        {
        re = new RegExp("\\^" + i);
        stPattern = stPattern.replace(re, AdmBuildParam.arguments[i]);
        }
    return stPattern;
}
function IndexOfIllegalCharInUrlLeafName(strLeafName)
{
    for(var i=0; i<strLeafName.length; i++)
    {
        var ch = strLeafName.charCodeAt(i);
        if(ch < 128 && ( strLeafName.charAt(i) == '/' || !LegalUrlChars[ch]) )
            return i;
    }
    return -1;
}
function IndexOfIllegalCharInUrlPath(strPath)
{
    for(var i=0; i<strPath.length; i++)
    {
        var ch = strPath.charCodeAt(i);
        if( ch < 128 && !LegalUrlChars[ch])
            return i;
    }
    return -1;
}
function UrlContainsIllegalStrings(strPath)
{
    if(strPath.indexOf("..") >=0 
        || strPath.indexOf("//") >=0
        || strPath.indexOf("./") >= 0
        || strPath.indexOf("/.") >=0
        || strPath.indexOf(".") == 0
        || strPath.lastIndexOf(".") == (strPath.length-1)
        )
    {
        return true;
    }
    return false;
}
function UrlLeafNameValidate(source, args)
{
    var strMessagePrefix = "";
    if( typeof(source.MessagePrefix) == "string" )
    {
        strMessagePrefix = source.MessagePrefix;
    }
    else
    {
        strMessagePrefix = source.id;
    }
    var i = IndexOfIllegalCharInUrlLeafName(args.Value);
    if( i >=0 )
    {
        if(typeof(source.errormessage) == "string")
        {
            source.errormessage = AdmBuildParam(L_ContainIllegalChar_Text, strMessagePrefix, args.Value.charAt(i));
        }
        args.IsValid = false;
    }
    else if( UrlContainsIllegalStrings(args.Value) )
    {
        if(typeof(source.errormessage) == "string" )
        {
            source.errormessage = AdmBuildParam(L_ContainIllegalString_Text, strMessagePrefix);
        }
        args.IsValid = false;
    }    
    else
    {
        args.IsValid = true;
    }
}
function UrlPathValidate(source, args)
{
    var strMessagePrefix = "";
    if( typeof(source.MessagePrefix) == "string" )
    {
        strMessagePrefix = source.MessagePrefix;
    }
    else
    {
        strMessagePrefix = source.id;
    }
    var i = IndexOfIllegalCharInUrlPath(args.Value);
    if( i >= 0)
    {
        if(typeof(source.errormessage) == "string")
        {        
            source.errormessage = AdmBuildParam(L_ContainIllegalChar_Text, strMessagePrefix, args.Value.charAt(i));
        }
        args.IsValid = false;
    }
    else if( UrlContainsIllegalStrings(args.Value) )
    {
        if(typeof(source.errormessage) == "string" )
        {
            source.errormessage = AdmBuildParam(L_ContainIllegalString_Text, strMessagePrefix);
        }
        args.IsValid = false;
    }    
    else
    {
        args.IsValid = true;
    }    
}
function IsCheckBoxListSelected(checkboxlist)
{
    if(checkboxlist == null )
        return false;
    var len = checkboxlist.length ;
    if (len == null) 
    {   
        return checkboxlist.checked;
    }
    else
    {
        for (var i=0; i < len ; i++)
        {
            if (checkboxlist[i].checked)
            {
                return true;
            }
        }
    }
    return false;
}
function STSValidatorEnable(val, bEnable, bSilent)
{
    var objVal = document.getElementById(val);
    if (objVal == null)
        return;
    if (bSilent == true)
    {
        objVal.enabled = (bEnable == true);
    }
    else
    {
        ValidatorEnable(objVal, bEnable);
    }
}

// SIG // Begin signature block
// SIG // MIIaOgYJKoZIhvcNAQcCoIIaKzCCGicCAQExCzAJBgUr
// SIG // DgMCGgUAMGcGCisGAQQBgjcCAQSgWTBXMDIGCisGAQQB
// SIG // gjcCAR4wJAIBAQQQEODJBs441BGiowAQS9NQkAIBAAIB
// SIG // AAIBAAIBAAIBADAhMAkGBSsOAwIaBQAEFEFZ4eOLjEau
// SIG // fiAe1GdXQlED4Z2zoIIUvDCCArwwggIlAhBKGdI4jIJZ
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
// SIG // aPqmP58j68idu4cxggTqMIIE5gIBATCBtTCBpjELMAkG
// SIG // A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
// SIG // BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
// SIG // dCBDb3Jwb3JhdGlvbjErMCkGA1UECxMiQ29weXJpZ2h0
// SIG // IChjKSAyMDAwIE1pY3Jvc29mdCBDb3JwLjEjMCEGA1UE
// SIG // AxMaTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0ECCmEH
// SIG // EUMAAAAAADQwCQYFKw4DAhoFAKCBujAZBgkqhkiG9w0B
// SIG // CQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
// SIG // DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU6RXr
// SIG // QmLsUmazzFWAba963DqfePgwWgYKKwYBBAGCNwIBDDFM
// SIG // MEqgKIAmAGMAbwBtAG0AbwBuAHYAYQBsAGkAZABhAHQA
// SIG // aQBvAG4ALgBqAHOhHoAcaHR0cDovL29mZmljZS5taWNy
// SIG // b3NvZnQuY29tIDANBgkqhkiG9w0BAQEFAASCAQCiB9RT
// SIG // E33EoNikWGvTzsHn5o346/MUvwcElL/HR/XPncm9uEen
// SIG // kWYj3lK3R4NlQ1/t0oM3FoRAx1+TdRGIzxTosD+N0EX5
// SIG // leO0QuKCpYMDiFiqZUADlxCHAW7Qntexs3hb2Y0GA17A
// SIG // V4+bnaQGBhWROgX5LDHYhPoyMLkpPpWYyfKSc/TJj2n+
// SIG // mmupDfJZP6HdczPJOVEIfJOYXxZE5RljHq5OcmxW/U7l
// SIG // s4WPOuaMGhzHDwDag52bDkdV5xG4+qyuZ572+Gbw5DWK
// SIG // ha09QoZj+t0+VzShEtyo4xp/2ONuMcnS6pa5DhrQA/9C
// SIG // R7qabbZMtdr87y1P7EXPIGmYSyGvoYICTDCCAkgGCSqG
// SIG // SIb3DQEJBjGCAjkwggI1AgEBMIGzMIGeMR8wHQYDVQQK
// SIG // ExZWZXJpU2lnbiBUcnVzdCBOZXR3b3JrMRcwFQYDVQQL
// SIG // Ew5WZXJpU2lnbiwgSW5jLjEsMCoGA1UECxMjVmVyaVNp
// SIG // Z24gVGltZSBTdGFtcGluZyBTZXJ2aWNlIFJvb3QxNDAy
// SIG // BgNVBAsTK05PIExJQUJJTElUWSBBQ0NFUFRFRCwgKGMp
// SIG // OTcgVmVyaVNpZ24sIEluYy4CEAh6bVxvYpNPusT9Q+EU
// SIG // GJ0wDAYIKoZIhvcNAgUFAKBZMBgGCSqGSIb3DQEJAzEL
// SIG // BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTAzMDcx
// SIG // NTA2MDM1NlowHwYJKoZIhvcNAQkEMRIEEFR/Axkkl6/Z
// SIG // F2gEdwJeVHMwDQYJKoZIhvcNAQEBBQAEggEAgOlPpONB
// SIG // UiBMTsXdB3Owu3OQK3L1xKFOzNP5BdvUjjx1EPURnmHA
// SIG // mVEUjhEz3G0bM8buSrI4es7bPfK76fsy9vymGRkDQgI5
// SIG // IR9OUVjOUBSJTy1+mzk4FuwuteFCPz+UabzOAOfL7MFb
// SIG // bwVMRg/OwZgqHgquZiSzy6M99FCU6susHa4K7iyDf9t8
// SIG // pBa3zTWk+wehRqgx5DtHwbSWRoBuGWWIsunyKJ/J6ZFC
// SIG // tM8LUU7j351VfYx2tZ8kpJQRBEGO+Xbg4/tkiSDS59sd
// SIG // 4CmesYQNYnVvjTsh3NgjzflXW4U6pyYZ64irYO1vOYbE
// SIG // liWvAmBI5yVXVcWOqyqyXLU+jA==
// SIG // End signature block
