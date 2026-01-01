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

## Customization

1. Edit `sections/header.tex` to update your name and contact information
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

