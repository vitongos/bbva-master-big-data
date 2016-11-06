<body>

<p>
<a href="/">Dónde comer</a> |
<a href="/locations">Por barrios</a> |
<a href="/cuisines">Por tipo de cocina</a>
</p>

<h1>Tipo de cocina</h1>

<#list cuisines as cuisine>
    <h2><a href="/cuisine/${cuisine}">${cuisine}</a></h2>
    <hr>
</#list>

</body>
</html>