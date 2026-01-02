# LaTeX Resume

A modular LaTeX resume template that can be easily customized and compiled to PDF.

## Structure

The resume is organized into modular sections:

- `resume.tex` - Main document file that includes all sections
- `preamble.tex` - Document class, LaTeX packages, and formatting settings
- `sections/header.tex` - Name and contact information
- `sections/experience.tex` - Work experience section
- `sections/skills.tex` - Skills section
- `sections/education.tex` - Education section

## Building the PDF

### Using Make (Recommended)

Build the PDF:

```bash
make
```

Clean auxiliary files (keeps PDF):

```bash
make clean
```

Clean everything including PDF:

```bash
make cleanall
```

Rebuild (clean and build):

```bash
make rebuild
```

Watch for file changes and auto-rebuild:

```bash
make watch
```

This will automatically rebuild your resume whenever you save any `.tex` or `.sty` file. It uses polling mode (checks every 2 seconds). Press `Ctrl+C` to stop watching.

Show all available commands:

```bash
make help
```

**Note for Windows users**: It's recommended to use **WSL** (Windows Subsystem for Linux) to build the resume.

1. Install WSL if you haven't already: https://learn.microsoft.com/en-us/windows/wsl/install
2. Open WSL terminal and navigate to your project directory
3. Install build tools (if needed):
   ```bash
   sudo apt update
   sudo apt install build-essential
   ```
4. Install LaTeX (TeX Live):
   ```bash
   sudo apt install texlive-full
   ```
5. Now you can use `make` to build your resume!

### Manual Build

If you prefer to compile manually or don't have make:

```bash
pdflatex resume.tex
```

### Using LaTeX Distributions

- **TeX Live** (Cross-platform): https://www.tug.org/texlive/

## Personal Information Setup

Your personal information (name, title, email, etc.) is kept private and not committed to the repository. You have two options:

### Option 1: Using `private.tex` (Recommended)

1. Copy the example file:

   ```bash
   cp private.tex.example private.tex
   ```

2. Edit `private.tex` and fill in your personal information:
   ```latex
   \newcommand{\resumename}{Your Name}
   \newcommand{\resumetitle}{Your Job Title}
   \newcommand{\resumeemail}{your.email@example.com}
   \newcommand{\resumewebsite}{https://yourwebsite.com}
   \newcommand{\resumelocation}{Your City, State}
   \newcommand{\resumephone}{+1 (XXX) XXX-XXXX}
   ```

The `private.tex` file is gitignored and will not be committed to the repository.

### Option 2: Using Environment Variables

You can also set environment variables instead of using `private.tex`:

```bash
export RESUME_NAME="Your Name"
export RESUME_TITLE="Your Job Title"
export RESUME_EMAIL="your.email@example.com"
export RESUME_WEBSITE="https://yourwebsite.com"
export RESUME_LOCATION="Your City, State"
export RESUME_PHONE="+1 (XXX) XXX-XXXX"
make
```

**Note**: If `private.tex` exists, it takes precedence over environment variables.

## Customization

1. Edit `private.tex` (or set environment variables) to update your name and contact information
2. Edit `sections/experience.tex` to add/modify work experience
3. Edit `sections/skills.tex` to update your skills
4. Edit `sections/education.tex` to update education details
5. Edit `preamble.tex` to modify document class, formatting, or add LaTeX packages

## Adding New Sections

1. Create a new `.tex` file in the `sections/` directory (e.g., `sections/projects.tex`)
2. Add your content to the new file
3. Include it in `resume.tex` using `\input{sections/filename}`

Example:

```latex
% In resume.tex, after other sections:
\input{sections/projects}
```

## Formatting LaTeX Files

This project uses `tex-fmt` for automatic LaTeX formatting with the LaTeX Workshop VSCode extension.

**Note:** The [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) VSCode extension is required for formatting to work inside the IDE. Install it from the VSCode marketplace if you haven't already.

### Installation

**Prerequisites:** Install [Rust](https://www.rust-lang.org/tools/install) on your system.

**For native Windows (Default):**

1. Install Rust from https://www.rust-lang.org/tools/install
2. Open PowerShell or Command Prompt
3. Install `tex-fmt`:
   ```bash
   cargo install tex-fmt
   ```

**For Windows users using WSL:**

1. Open WSL terminal
2. Install Rust (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```
3. Install `tex-fmt`:
   ```bash
   cargo install tex-fmt
   ```

### Configuration

The project is pre-configured to use `tex-fmt` with native Windows. The configuration is in `.vscode/settings.json`:

```json
{
  "latex-workshop.formatting.latex": "tex-fmt",
  "latex-workshop.formatting.tex-fmt.path": "tex-fmt",
  "latex-workshop.formatting.tex-fmt.args": []
}
```

**For WSL installation**, update `.vscode/settings.json` to:

```json
{
  "latex-workshop.formatting.latex": "tex-fmt",
  "latex-workshop.formatting.tex-fmt.path": "wsl",
  "latex-workshop.formatting.tex-fmt.args": [
    "bash",
    "-lc",
    "tex-fmt --nowrap \"$(wslpath '%TMPFILE%')\""
  ]
}
```

**Note:** Ensure that the directory containing the `tex-fmt` executable is in your system's `PATH` environment variable.

### Usage

Once configured, you can format your LaTeX files in VSCode:

- **Format entire document**: Press `Shift+Alt+F` (or `Shift+Option+F` on macOS)
- **Format selection**: Select text, right-click, and choose `Format Selection`
- **Format on save**: Enable format on save in VSCode settings

For more information, see the [LaTeX Workshop Formatting Documentation](https://github.com/James-Yu/LaTeX-Workshop/wiki/Format).

