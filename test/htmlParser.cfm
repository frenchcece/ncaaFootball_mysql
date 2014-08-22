 <cfsavecontent variable="dirtyHTML">
<!DOCTYPE html>
<html>
<head>
<title>My Dirty Document!</title>
<meta name="description" content="This is a dirty Document! It will have nasty bits in it!">
<meta name="keywords" content="dirty, html, nasty!">
</head>
<body>
      <h1>This is a dirty document</h1>
      <p>This is a dirty document that has nasty things in it, <br>like this break for example</p>
      <hr>
      <p>It could also have a nice break too! <br/> But that is by the by</p>      

      <ul>
         <li><a href="http://www.getrailo.com/">Railo Technologies</a></li>
         <li><a href="http://www.getrailo.org/">Railo Server</a></li>
         <li><a href="http://www.google.co.uk/">Google</a></li>         
         <li><a href="http://www.markdrew.co.uk/blog/" >Mark Drew's website</a></li>
      </ul>

</body>
</html>
</cfsavecontent>

<cfhttp url="http://espn.go.com/college-football/rankings/_/year/2014/week/1" result="bar">

<cfset htmlParsedItem = HTMLParse(bar.fileContent)>

<cfdump var="#htmlParsedItem#">