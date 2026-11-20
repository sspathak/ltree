# ltree

A pure Zsh Oh My Zsh plugin that works like `tree`, but truncates large directories by printing the first `n` files and summarizing the rest as `... m more files`.

## Installation

1. Clone this repository into your Oh My Zsh custom plugins directory:

   ```bash
   git clone https://github.com/sspathak/ltree \
     "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/ltree"
   ```

2. Add `ltree` to the `plugins` array in `~/.zshrc`:

   ```zsh
   plugins=(git ltree)
   ```

3. Reload your shell:

   ```bash
   source ~/.zshrc
   ```

## Usage

```bash
ltree [OPTIONS] [DIR]
```

| Option | Description |
| :--- | :--- |
| `-n, --limit NUM` | Max files to show per directory (default: `5`) |
| `-L, --level NUM` | Max depth to descend |
| `-a, --all` | Include hidden files |
| `-h, --help` | Show help message |

## Example

```text
$ ltree -n 3 -L 2 ./project
./project/
├── data/
│   ├── batch_001.csv
│   ├── batch_002.csv
│   ├── batch_003.csv
│   └── ... 1428 more files
├── src/
│   ├── main.py
│   └── utils.py
└── README.md
```

## License

MIT
