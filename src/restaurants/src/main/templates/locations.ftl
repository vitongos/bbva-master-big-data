<body>

<p>
<a href="/">Dónde comer</a> |
<a href="/locations">Por barrios</a> |
<a href="/cuisines">Por tipo de cocina</a>
</p>

<h1>Barrios</h1>

<#list locations as location>
    <h2><a href="/location/${location}">${location}</a></h2>
    <hr>
</#list>

</body>
</html>