# Installation

1. Boot raspberry with ssd card containing nixOS.
2. Create fileswap
    1. `sudo fallocate -l 4G /swapfile`
    2. `sudo chmod 600 /swapfile`
    3. `sudo mkswap /swapfile`
    4. `sudo swapon /swapfile`
