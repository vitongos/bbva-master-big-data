<!doctype HTML>
<html>
<head>
    <title>Crear un nuevo restaurante</title>
</head>
<body>
<form action="/new" method="POST">
    ${errors!""}
    <h2>Nombre</h2>
    <input type="text" name="name" size="40" value="${name!""}"><br>

    <h2>Barrio</h2>
    <input type="text" name="borough" size="40" value="${borough!""}"><br>

    <h2>Tipo de cocina</h2>
    <input type="text" name="cuisine" size="120" value="${cuisine!""}"><br>

    <p>
    <input type="submit" value="Submit">
    <a href="/">Back</a>
    </p>

</body>
</html>

