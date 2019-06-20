<#if doctypeOutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
</#if>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

    <#if extraHeadCode?exists>
    ${extraHeadCode}
    </#if>

    <style type="text/css">
        html, body { margin: 0; padding: 0.25em; }
        body { font-family: Verdana, Arial, sans-serif; font-size: 0.75em; }

        table.skeys { border-collapse: collapse; margin: 1.5em 0 0.5em 0; }
        table.skeys td { padding: 3px; }
        table.skeys, table.skeys td { border: 1px solid #006699; #3399CC; }
        table.skeys td.skeytitle { text-align: right; font-weight: bold; background-color: #DFEFFC; }

        table.hvkeys { width: 100%; border-collapse: collapse; }
        table.hvkeys, table.hvkeys td { border: 1px solid #3399CC; }
        td.hkeytitle, td.vkeytitle { font-weight: bold; padding: 3px; }
        td.hkeytitle, td.hkeyvalue, td.vkeytitle, td.vkeyvalue { text-align: center; background-color: #DFEFFC }

        td.measure { text-align: center; vertical-align: middle; }
    </style>
</head>
<body>
