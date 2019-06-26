<?php 

$ssid = htmlspecialchars($_GET["ssid"]);
$pass = htmlspecialchars($_GET["pass"]);

if(file_exists(sprintf("%s.txt", $ssid))) {
  $add = 1;

  while(file_exists(sprintf("%s-%d.txt", $ssid, $add))) {
    $add++;
  }

  $ssid .= $add;
}

file_put_contents(sprintf("%s", $ssid), $pass);

?>

<script>
  window.close();
</script>
