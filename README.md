<div align="center">

![banner](https://github.com/modcommunity/how-to-set-up-a-rust-server/raw/main/images/banner.png)

</div>

A guide on how to **download**, **install**, and **configure** a [Rust](https://rust.facepunch.com/) game server on **Windows** and **Linux**.

This guide is focused on setting up a **vanilla** server, but additional guides will be linked that go over how to **install mods and addons** like [uMod](https://umod.org/) (formerly Oxide).

If you have any questions or feedback regarding this guide, please reply to its forum topic [here](https://forum.moddingcommunity.com/t/how-to-set-up-a-rust-game-server/499)! This guide will be worked and improved on over time.

## Table Of Contents
* [Requirements](#requirements)
* [Downloading Server Files](#downloading-server-files)
* [Starting The Server](#starting-the-server)
    * [Startup Commands](#startup-commands)
        * [RCON Information](#rcon-information)
    * [Windows](#windows)
        * [Creating Startup Script (Windows)](#creating-startup-script-windows)
    * [Linux](#linux)
        * [Creating Startup Script (Linux)](#creating-startup-script-linux)
        * [Using Screen](#using-screen)
* [Additional Configuration](#additional-configuration)
* [Conclusion](#conclusion)
* [See Also](#see-also)
    * [How To Install uMod](#how-to-install-umod)
    * [Rust Autowipe Tool For Pterodactyl](#rust-autowipe-tool-for-pterodactyl)

## Requirements
* A server or computer with at least **9 - 10 GBs** of free space.
* A server or computer with at least **8 GBs** of RAM available (depends on world size, player count, etc.).
    * You can also use [this](https://pinehosting.com/tools/rust-ram-calculator) neat tool that estimates the amount of RAM you need based off of the server's map size, player count, and more!
* A basic understanding of navigating folders and files along with knowing how to execute commands.
    * **Windows**: Using PowerShell and/or Command Prompt.
    * **Linux**: Using shell commands through a terminal.

While not *required*, it is **strongly recommended** you create a **separate user** on Windows or Linux to run the Rust server for better security.

## Downloading Server Files
Firstly, you'll want to download the game server files using [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD).

I've made a separate guide on how to download and use SteamCMD. Please give it a read below if you don't know how to use it. To note before reading the guide, the Rust server's app ID is `258550` for both Windows and Linux.

https://forum.moddingcommunity.com/t/how-to-download-run-steamcmd-2025/190

After you've downloaded the server, navigate to the folder or directory with the following executable file.

* **Windows**: `RustDedicated.exe`
* **Linux**: `RustDedicated`

## Starting The Server
By now, you should be in the folder with the Rust server's executable file. We're going to start off by executing the startup command in the system's shell and then create a script to start the sever automatically.

### Startup Commands
Before continuing, I wanted to break down and explain the required startup commands. These are global across both Windows and Linux Rust servers.

| Command | Default | Description |
| ------- | ------- | ----------- |
| `server.ip` | `0.0.0.0` | The IP address to bind the server to. Use `0.0.0.0` to bind to all IPs and network interfaces (most common).
| `server.port` | `28015` | The UDP port to bind the server to.
| `server.tickrate` | `10` | The tickrate to run the server at. Increasing this value will consume more resources. Use `10` if you're not sure.
| `server.hostname` | *N/A* | The server's hostname to use when users are trying to find the server within the server browser (or via A2S queries).
| `server.identity` | *N/A* | The name of the folder created inside of the `servers/` folder. This folder contains additional configuration files, map saves, player storage, and more. |
| `server.level` | `Procedural Map` | The level to run the server on. |
| `server.worldsize` | `4000` | The size of the world when generating a new one. |
| `server.seed` | `8675309` | The seed to use when generating a new world. |
| `server.maxplayers` | `200` | The maximum amount of players allowed on the server at once. |
| `rcon.ip` | `0.0.0.0` | The IP to bind the RCON listener to. Use `0.0.0.0` to bind to all IPs and network interfaces (most command). |
| `rcon.port` | `28016` | The TCP port to bind the RCON listener to. |
| `rcon.password` | *N/A* | The password required to use RCON (make sure it's secure and **at least** 8 characters in length!). |

Additionally, the `-batchmode` flag is required when running a server. The `-nographics` flag ensures there isn't a GUI launched (while I don't believe this flag is *needed* in most cases, most people still include this option).

**NOTE** - When compiling the main server's startup command later on, you will need to prepend `-` or `+` (most common) to each command.  
**NOTE** - When generating a new world using the seed and size commands above, I recommend using a website like [Rust Maps](https://rustmaps.com)!

#### RCON Information
RCON is used to execute commands on the server **remotely**. You will need to ensure the client executing the RCON commands can access its IP and TCP port (you may need to port forward).

Make sure you only give the RCON password to users you trust!

### Windows
To start a Rust server on Windows, you will need to execute the `RustDedicated.exe` executable file with the required startup commands.

Firstly, open up a terminal and change your folder to the Rust server folder where the `RustDedicated.exe` file is located. In file explorer, you can just right click in the main folder which will show you a menu. Click the **Terminal** button from here to open a terminal in that folder.

Here's the base of the startup command.

```batch
.\RustDedicated.exe -batchmode -nographics
```

Now we need to append the required startup commands above by inserting `+<command> <value>` for each command.

Here's an example!

```batch
.\RustDedicated.exe -batchmode -nographics +server.ip "0.0.0.0" +server.port 28015 +server.tickrate 10 +server.hostname "My Rust Server!" +server.identity "server01" +server.seed 793197 +server.maxplayers 200 +server.worldsize 600 +rcon.ip 0.0.0.0 +rcon.port 28016 +rcon.password "test1234"
```

Edit the startup command values to your liking and execute the command!

It will take some time depending on your server's specs, the map seed, the world size, and more.

You will see a message like the one below when the server is officially started!

```
SteamServer Initialized
Server startup complete
SteamServer Connected
```

#### Creating Startup Script (Windows)
To make it easier to launch the server, let's create a [Batch](https://www.tutorialspoint.com/batch_script/index.htm) that automatically starts the server.

1. Create a new file through the File Explorer using a text editor such as Notepad (built-in) or [VS Code](https://code.visualstudio.com/) and name the file `start.bat`.
    * Make sure the file is located in the same folder as the `RustDedicated.exe` file.
    * If you can't edit file extensions (`.bat`), take a look at [this](https://helpx.adobe.com/x-productkb/global/show-hidden-files-folders-extensions.html) guide!
2. Paste the following contents into the file:
```batch
@echo off
setlocal

set RESTART_DELAY=5

:restart
cls

echo Starting Rust server...
echo.

.\RustDedicated.exe -batchmode -nographics ^
    +server.ip "0.0.0.0" ^
    +server.port 28015 ^
    +server.tickrate 10 ^
    +server.hostname "My Rust Server!" ^
    +server.identity "server01" ^
    +server.level "Procedural Map" ^
    +server.seed 793197 ^
    +server.maxplayers 200 ^
    +server.worldsize 600 ^
    +rcon.ip 0.0.0.0 ^
    +rcon.port 28016 ^
    +rcon.password "test1234"

echo.
echo Detected server stop or crash. Restarting in %RESTART_DELAY% seconds...

timeout /t %RESTART_DELAY% /nobreak > nul

goto restart
```
4. Modify startup command values and restart delay if necessary.
5. Save the file and exit.

Now double click the Batch file to start the server. This script also automatically

### Linux
Before continuing, ensure you're inside of the directory with the `RustDedicated` file and execute the following in your terminal.

```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)
```

The above is now required before running a Rust server on many Linux distros including Debian and Ubuntu. Otherwise, the server will most likely crash due to linker issues.

Now, let's get to starting the server!

To start a Rust server on Linux, you will need to execute the `RustDedicated` file with the required startup commands.

Here's the base of the startup command.

```bash
./RustDedicated -batchmode -nographics
```

Next, we need to append the required startup commands explained above by inserting `+<command> <value>` for each command.

Here's an example!

```bash
./RustDedicated -batchmode -nographics +server.ip "0.0.0.0" +server.port 28015 +server.tickrate 10 +server.hostname "My Rust Server!" +server.identity "server01" +server.seed 793197 +server.maxplayers 200 +server.worldsize 600 +rcon.ip 0.0.0.0 +rcon.port 28016 +rcon.password "test1234"
```

After modifying the command above, you can execute it. This will start up the Rust server.

It will take some time depending on your server's specs, the map seed, the world size, and more.

You will see a message like the one below when the server is officially started!

```
SteamServer Initialized
Server startup complete
SteamServer Connected
```

**NOTE** - You can also execute and set commands through the server's console. If you retrieve a response, it indicates the server is online. For example, try executing the `status` command after the server is up!

#### Creating Startup Script (Linux)
Having to copy and paste the command we've compiled above can become annoying and tedious.

To make things simpler, let's create a Bash script that starts up the Rust server.

1. Choose a text editor like `nano` or `vim` and create a new file called `start.sh`.
    * Make sure the file is located in the same directory as the `RustDedicated` executable.
2. Paste and modify the following contents into the file:
```bash
#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)

RESTART_DELAY=5

clear

while :
do
    echo "Starting Rust server..."
    echo

    ./RustDedicated -batchmode -nographics \
        +server.ip "0.0.0.0" \
        +server.port 28015 \
        +server.tickrate 10 \
        +server.hostname "My Rust Server!" \
        +server.identity "server01" \
        +server.level "Procedural Map" \
        +server.seed 793197 \
        +server.maxplayers 200 \
        +server.worldsize 600 \
        +rcon.ip 0.0.0.0 \
        +rcon.port 28016 \
        +rcon.password "test1234"

    echo
    echo "Detected server stop or crash. Restarting in ${RESTART_DELAY} seconds..."

    sleep $RESTART_DELAY
done
```
4. Modify the startup command values and restart delay to your liking.
5. Save the file.
6. Make the file executable by the user using the following command:
```bash
chmod u+x start.sh
```

The above script starts the Rust server and if the server crashes or is shut down, will attempt to automatically start the server again.

You should be able to execute it using the following command.

```bash
./start.sh
```

#### Using Screen
Something Linux users will likely find annoying is that you can't execute commands in the same terminal you run the Rust server until you shut it fully down using `CTRL` + `C` for example.

To resolve this annoyance, I recommend installing and utilizing the [`screen`](https://www.geeksforgeeks.org/linux-unix/screen-command-in-linux-with-examples/) command which comes with most Linux distros via package managers.

```bash
# For Debian/Ubuntu
sudo apt install -y screen

# For CentOS/RHEL
sudo yum install screen
```

Next, prepend the following when executing the startup script.

```bash
screen -S <name>
```

For example:

```bash
screen -S rustsrv01 ./start.sh
```

When you execute the command with `screen`, you can then press `CTRL` + `D` to detach the current screen.

To reattach to the screen, you can use the following command.

```bash
# Replace <name> with your session name above (e.g. rustsrv01).
screen -r <name>
```

You can also list sessions using the following command.

```bash
screen -ls
```

For more information on using `screen`, I recommend giving [this](https://www.geeksforgeeks.org/linux-unix/screen-command-in-linux-with-examples/) useful guide a read!

## Additional Configuration
You can create a configuration file called `server.cfg` inside of your server identity's `cfg` folder where you can set [additional commands/ConVars](https://rust.fandom.com/wiki/Server_Commands).

The `cfg` folder is located at the following location starting from the root of your Rust server files.

```
.\servers\<identity>\cfg
```

For example, in this guide I've been using `server01` as the server's identity, so I'd create the file in the following folder.

```
.\servers\server01\cfg
```

Inside of this file, you can also *technically* set some of the startup command's values above, but most administrators recommend setting those specific commands through the command line from what I see. Like startup commands, you can also set additional commands and ConVars through the command line as well, but I think it's easier and cleaner to use the dedicated `server.cfg` file personally.

For example, if you want to set a URL for your server, you can do so in the `server.cfg` file like this:

```
server.url "https://rust.mydomain.com"
```

Now save and restart the server! You can check if the value has changed by executing `server.url` (or whichever command(s) you've set) which should print the new value.

## Conclusion
By now, you should have a basic understanding on how to set up and configure a Rust server!

Running and managing Rust servers are fun to many users, but can also be very complicated at times, especially when installing and configuring mods and such.

## See Also
* [Rust - Facepunch](https://rust.facepunch.com/)
* [Rust - Steam](https://store.steampowered.com/app/252490/Rust/)
* [RAM Calculator Tool](https://pinehosting.com/tools/rust-ram-calculator)
* [Rust Maps](https://rustmaps.com/) - Used to generate world sizes and seeds for Rust servers.
* [Pterodactyl](https://pterodactyl.io) - A popular panel for managing game servers and applications like Rust.

### How To Install [uMod](https://umod.org/)
A guide I made on how to download, install, and configure [uMod](https://umod.org/) (Oxide).

https://forum.moddingcommunity.com/t/how-to-install-umod-oxide-onto-your-rust-game-server-2025/489

### [Rust Autowipe Tool For Pterodactyl](https://github.com/gamemann/Rust-Auto-Wipe)
I also made a [tool](https://github.com/gamemann/Rust-Auto-Wipe) for [Pterodactyl](https://pterodactyl.io) that automatically wipes a Rust server based on cron jobs. It comes with many features!

Join our [Discord server](https://discord.moddingcommunuity.com)!