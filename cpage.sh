#!/bin/bash
if [ -a index.html ]; then mv index.html index.html.bak; fi
cat << 'HTMLCODE' > index.html
<!DOCTYPE html>
<head><title>Under Construction</title></head>
<link href='http://fonts.googleapis.com/css?family=Noto+Sans:700' rel='stylesheet' type='text/css'>
<body style="background-image: url(data:image/jpeg;base64,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);color:rgb(40, 40, 40);font-family:'Noto Sans', 'Open Sans', sans-serif;">
<div style="margin: 15% 18% 0;padding:2em;background-color:rgba(200, 200, 200, .6);border: solid 10px rgba(2, 2, 2, 0.7);-webkit-border-radius: 15px;-moz-border-radius: 15px;border-radius: 15px;box-shadow: 2px 2px 4px #222;">
<h2 style="text-align:center;text-shadow: 2px 2px 3px #555;"><font size="6.5">This page is currently under construction</font><br></h2>
<p style="text-align:center;display:block;"><font size="4">please check in again, we hope to be online soon.</font></p>
</div></body></html>
HTMLCODE
