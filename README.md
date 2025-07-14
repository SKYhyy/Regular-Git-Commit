# Regular-Git-Commit
**Regular-Git-Commit** is a simple shell script helping with git commit process.

## Files
`fancy_echo.sh` is only responsible for fancy text effects for `echo()`. And `git.sh` is the main script for practical functionalities.

## Functionalities
- Conventional Commit Message Generation
- Non-ASCII Hook
- Atomic Commit Hook
- Global Configuration

## Installation
- Clone this repository
```shell
git clone
```
- Change the `.sh` files to executable mode
```shell
cd Regular-Git-Commit
chmod +x fancy_echo.sh
chmod +x git.sh
```
- Adjust `.rc` file
for `bash`:
add `alias rgc='./your/path/to/Regular-Git-Commit/git.sh'` to `.bashrc`
run `source ~/.bashrc`
for `zsh`:
add `alias rgc="./your/path/to/Regular-Git-Commit/git.sh"` to `.zshrc`
run `source ~/.zshrc`

## Usage

### Regular Git Commit
run
```shell
rgc
```
to commit and push all your changes

run
```shell
rgc your_file
```
to commit and push your changes in certain files

### Global Configuration
run
```shell
rgc --ascii-lock on/off
```
to turn on/off non-ASCII hook

run
```shell
rgc --atomic-lock on/off
```
to turn on/off atomic commit hook

run
```shell
rgc --atomic-ceil 70
```
to set the atomic commit hook ceil, default is 70 lines

## Contributor
Sky Ceilux
