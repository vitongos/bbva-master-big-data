<!doctype HTML>
<html
<head>
    <title>
        Restaurant 
    </title>
</head>
<body>
<p>
<a href="/">Dónde comer</a> |
<a href="/locations">Por barrios</a> |
<a href="/cuisines">Por tipo de cocina</a>
</p>

<h2>${restaurant["name"]}</h2>
    
    <p>Barrio: <a href="/location/${restaurant["borough"]}">${restaurant["borough"]}<a/></p>
    
    <p>Cocina: ${restaurant["cuisine"]}</p>
    
    <#if restaurant["grades"]??>
        <#assign grades = restaurant["grades"]?size>
            <#else>
                <#assign grades = 0>
    </#if>

<#if (grades > 0)>
Valoraciones
<ul>
<#list 0 .. (grades -1) as i>
	<li>
    	Valorado el <em>${restaurant["grades"][i]["date"]?datetime}</em> como: ${restaurant["grades"][i]["score"]}<br>
    </li>
</#list>
</ul>
</#if>

</body>
</html>