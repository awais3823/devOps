<html>
<body>
<?php
// Get environment variables (same as in index.php)
$host = getenv('MYSQL_HOST') ?: 'db';
$user = getenv('MYSQL_USER');
$pass = getenv('MYSQL_PASSWORD');
$db   = getenv('MYSQL_DATABASE');

// Connect to the database
$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Insert data into users table
$sql = "INSERT INTO users (id, username, password)
        VALUES ('{$_POST['id']}', '{$_POST['fname']}', '{$_POST['lname']}')";

if (!$conn->query($sql)) {
    die("Error inserting data: " . $conn->error);
} else {
    echo "✅ 1 record added successfully!<br><br>";
}

// Fetch and display data
echo "<strong>TABLE DATA:</strong><br>";
$sql = "SELECT * FROM users";

if ($result = $conn->query($sql)) {
    while ($data = $result->fetch_object()) {
        echo "{$data->id} — {$data->username} — {$data->password}<br>";
    }
}

echo "<br><a href='index.php'>Go back</a>";
?>
</body>
</html>

