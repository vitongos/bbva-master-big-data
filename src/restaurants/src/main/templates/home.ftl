<!DOCTYPE html>
<html>
<head>
    <title>Comer bien</title>
</head>
<body>

<p>
<a href="/">Dónde comer</a> |
<a href="/locations">Por barrios</a> |
<a href="/cuisines">Por tipo de cocina</a>
</p>

<h1>Bienvenidos a Comer bien</h1>

<#list restaurants as restaurant>
    <h2><a href="/restaurant/${restaurant["permalink"]}">
    ${restaurant["name"]}
    </a></h2>
    
    Barrio: ${restaurant["borough"]}<br>
    
    Cocina: ${restaurant["cuisine"]}<br>
    
    <#if restaurant["grades"]??>
        <#assign grades = restaurant["grades"]?size>
            <#else>
                <#assign grades = 0>
    </#if>

    <a href="/restaurant/${restaurant["permalink"]}">${grades} valoraciones</a>
    <hr>
    
</#list>

<p>
<a href="/new">Nuevo restaurante</a>
</p>

</body>
</html>