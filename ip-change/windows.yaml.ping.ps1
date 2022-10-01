if (-NOT (Test-Connection -ComputerName $args[0] -TimeoutSeconds 1 -Quiet)) {
    EXIT 255
} 