# Monitor Folder Updates Zsh Script
 Shell script to make the updates on the server once you update/rename/delete any file in the folder on local machine.
`rclone` and `fswatch` are required for script to work.

## Dependencies
### rclone
To install rclone on Linux/macOS/BSD systems, run:
```bash
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

macOS installation with Homebrew
```
brew install rclone
```

On macOS, rclone can also be installed via MacPorts:
```
sudo port install rclone
```

### fswatch
macOS installation with HomeBrew
```
brew install fswatch
```
macOS installation with MacPorts
```
brew install fswatch
```

## Source and Destination Setup
In rclone you have to setup directory you want to sync as `server`.
```
rclone config
```
`source_path` is directory from where you run the script.
`destination_path` is the one you selected as `server` in `rclone`