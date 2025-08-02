# Claude Instructions

## CLI and Terminal Commands

### Manual Pages (man)
- **ALWAYS export MANPAGER when using man commands**
  - Command: `export MANPAGER="less -X"; man command`
  - Use grep on man pages instead of dumping entire manual (more efficient, reduces cache usage)
  - Example: `man tmux | grep -A 5 -B 5 "option-name"`

### Code Quality
- Include confidence levels when identifying issues
- Comments should focus on WHY something is done, not what it does (code should be self-documenting)

## File Management
- Do what has been asked; nothing more, nothing less
- NEVER create files unless absolutely necessary for achieving your goal
- ALWAYS prefer editing an existing file to creating a new one
- NEVER proactively create documentation files (*.md) or README files unless explicitly requested

## IDE Integration
- When user references "this file" or is vague about what file they mean, check for active IDE integration first
- Use system reminders about opened files to determine the correct file instead of searching unnecessarily
- The IDE integration provides context about which files are currently open and being worked on
- **ALWAYS prioritize IDE context over git status or other file discovery methods when determining which file the user is referring to**

## Neovim

### Plugin Documentation
- For lazy.nvim managed plugins, documentation is located at `~/.local/share/nvim/lazy/[plugin-name]/doc/[plugin-name].txt`
- Example: obsidian.nvim docs at `~/.local/share/nvim/lazy/obsidian.nvim/doc/obsidian.txt`
- Use `Read` tool to access plugin help files directly instead of trying nvim help commands
