<html>
<body>
<?php
$host = getenv('MYSQL_HOST');
$user = getenv('MYSQL_USER');
$pass = getenv('MYSQL_PASSWORD');
$db   = getenv('MYSQL_DATABASE');

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "✅ Connected to MySQL server successfully!";
}

echo "<br><br><br>";

$sql = "CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    PRIMARY KEY (id)
)";

if ($conn->query($sql) === TRUE) {
    echo "Table 'users' is ready.";
} else {
    echo "Error creating table: " . $conn->error;
}

echo "<br><br><br>";
?>

<form action="insert.php" method="post">
    ID: <input type="number" name="id" /><br><br>
    Username: <input type="text" name="fname" /><br><br>
    Password: <input type="text" name="lname" /><br><br>
    <input type="submit" value="Insert Data" />
</form>

</body>
</html>

