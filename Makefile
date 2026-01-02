# Makefile for LaTeX Resume

# Main document name (without .tex extension)
MAIN = resume
TEX_FILE = $(MAIN).tex

# Output directory for all generated files
OUTPUT_DIR = output

# Get git branch name and construct PDF filename
GIT_BRANCH = $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "default")
PDF_FILE = $(OUTPUT_DIR)/$(MAIN)-$(GIT_BRANCH).pdf

# LaTeX compiler
LATEX = pdflatex
LATEX_FLAGS = -interaction=nonstopmode

# Personal information from environment variables (optional)
# If personal.tex exists, it takes precedence over these
RESUME_NAME ?=
RESUME_TITLE ?=
RESUME_EMAIL ?=
RESUME_WEBSITE ?=
RESUME_LOCATION ?=
RESUME_PHONE ?=

# Build LaTeX defines from environment variables (if set)
LATEX_DEFINES = $(if $(RESUME_NAME),\def\resumenameenv{$(RESUME_NAME)}) \
                $(if $(RESUME_TITLE),\def\resumetitleenv{$(RESUME_TITLE)}) \
                $(if $(RESUME_EMAIL),\def\resumeemailenv{$(RESUME_EMAIL)}) \
                $(if $(RESUME_WEBSITE),\def\resumewebsiteenv{$(RESUME_WEBSITE)}) \
                $(if $(RESUME_LOCATION),\def\resumelocationenv{$(RESUME_LOCATION)}) \
                $(if $(RESUME_PHONE),\def\resumephoneenv{$(RESUME_PHONE)})

# Source files that the document depends on
SECTION_FILES = $(wildcard sections/*.tex)
SOURCE_FILES = $(TEX_FILE) preamble.tex $(SECTION_FILES)

# Auxiliary files to clean
AUX_FILES = *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk \
            *.synctex.gz *.nav *.snm *.vrb *.bbl *.blg *.bcf *.run.xml \
            *.idx *.ilg *.ind

.PHONY: all clean cleanall rebuild help watch

# Default target: build the PDF
all: $(PDF_FILE)

# Build PDF from LaTeX source
$(PDF_FILE): $(SOURCE_FILES) | $(OUTPUT_DIR)
	@echo Building $(PDF_FILE) from $(TEX_FILE)...
	@if [ -f personal.tex ]; then \
		echo "Using personal.tex for personal information..."; \
		TEXINPUTS=.:macros//:$(TEXINPUTS) $(LATEX) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) -jobname=$(MAIN)-$(GIT_BRANCH) $(TEX_FILE); \
	else \
		if [ -n "$(RESUME_NAME)" ] || [ -n "$(RESUME_EMAIL)" ]; then \
			echo "Using environment variables for personal information..."; \
			TEXINPUTS=.:macros//:$(TEXINPUTS) $(LATEX) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) -jobname=$(MAIN)-$(GIT_BRANCH) '\def\resumenameenv{$(RESUME_NAME)}\def\resumetitleenv{$(RESUME_TITLE)}\def\resumeemailenv{$(RESUME_EMAIL)}\def\resumewebsiteenv{$(RESUME_WEBSITE)}\def\resumelocationenv{$(RESUME_LOCATION)}\def\resumephoneenv{$(RESUME_PHONE)}\input{$(TEX_FILE)}'; \
		else \
			echo "Warning: personal.tex not found and no environment variables set."; \
			echo "Create personal.tex from personal.tex.example or set RESUME_* environment variables."; \
			TEXINPUTS=.:macros//:$(TEXINPUTS) $(LATEX) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) -jobname=$(MAIN)-$(GIT_BRANCH) $(TEX_FILE); \
		fi; \
	fi
	@if [ -f $(PDF_FILE) ]; then \
		echo Build successful! $(PDF_FILE) created/updated.; \
	else \
		echo Build failed! Check $(OUTPUT_DIR)/$(MAIN)-$(GIT_BRANCH).log for errors.; \
		exit 1; \
	fi

# Create output directory if it doesn't exist
$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

# Clean auxiliary files (keep PDF)
clean:
	@echo Cleaning auxiliary files...
	@if [ -d $(OUTPUT_DIR) ]; then \
		for file in $(AUX_FILES); do \
			if [ -f $(OUTPUT_DIR)/$$file ]; then rm -f $(OUTPUT_DIR)/$$file; fi \
		done; \
		rm -f $(OUTPUT_DIR)/$(MAIN)-$(GIT_BRANCH).aux $(OUTPUT_DIR)/$(MAIN)-$(GIT_BRANCH).log $(OUTPUT_DIR)/$(MAIN)-$(GIT_BRANCH).out; \
	fi
	@echo Clean complete.

# Clean everything including PDF
cleanall: clean
	@if [ -f $(PDF_FILE) ]; then \
		rm -f $(PDF_FILE); \
		echo Removed $(PDF_FILE); \
	fi
	@if [ -d $(OUTPUT_DIR) ] && [ -z "$$(ls -A $(OUTPUT_DIR) 2>/dev/null)" ]; then \
		rmdir $(OUTPUT_DIR); \
		echo Removed empty $(OUTPUT_DIR) directory; \
	fi

# Rebuild: clean auxiliary files and rebuild (keeps PDF to preserve editor tabs)
# Note: PDF is not deleted, just overwritten, so editor tabs stay open
rebuild: clean
	@echo Building $(PDF_FILE) from $(TEX_FILE)...
	@if [ -f personal.tex ]; then \
		TEXINPUTS=.:macros//:$(TEXINPUTS) $(LATEX) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) -jobname=$(MAIN)-$(GIT_BRANCH) $(TEX_FILE); \
	else \
		if [ -n "$(RESUME_NAME)" ] || [ -n "$(RESUME_EMAIL)" ]; then \
			TEXINPUTS=.:macros//:$(TEXINPUTS) $(LATEX) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) -jobname=$(MAIN)-$(GIT_BRANCH) '\def\resumenameenv{$(RESUME_NAME)}\def\resumetitleenv{$(RESUME_TITLE)}\def\resumeemailenv{$(RESUME_EMAIL)}\def\resumewebsiteenv{$(RESUME_WEBSITE)}\def\resumelocationenv{$(RESUME_LOCATION)}\def\resumephoneenv{$(RESUME_PHONE)}\input{$(TEX_FILE)}'; \
		else \
			TEXINPUTS=.:macros//:$(TEXINPUTS) $(LATEX) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) -jobname=$(MAIN)-$(GIT_BRANCH) $(TEX_FILE); \
		fi; \
	fi
	@if [ -f $(PDF_FILE) ]; then \
		echo Build successful! $(PDF_FILE) created/updated.; \
	else \
		echo Build failed! Check $(OUTPUT_DIR)/$(MAIN)-$(GIT_BRANCH).log for errors.; \
		exit 1; \
	fi

# Watch for file changes and auto-rebuild (polling mode)
watch:
	@echo "Watching for file changes (checking every 2 seconds)..."
	@echo "Press Ctrl+C to stop"
	@LAST_BUILD=0; \
	while true; do \
		CURRENT=$$(find . -type f \( -name "*.tex" -o -name "*.sty" \) ! -path "./output/*" -exec stat -c %Y {} \; 2>/dev/null | sort -n | tail -1); \
		if [ -n "$$CURRENT" ] && [ "$$CURRENT" != "$$LAST_BUILD" ]; then \
			echo "File changed, rebuilding..."; \
			$(MAKE) rebuild; \
			LAST_BUILD=$$CURRENT; \
		fi; \
		sleep 2; \
	done

# Help target
help:
	@echo "Available targets:"
	@echo "  make        - Build resume-$(GIT_BRANCH).pdf"
	@echo "  make clean  - Remove auxiliary files (keep PDF)"
	@echo "  make cleanall - Remove all generated files including PDF"
	@echo "  make rebuild - Clean auxiliary files and rebuild PDF (preserves open tabs)"
	@echo "  make watch  - Watch for file changes and auto-rebuild (polling mode)"
	@echo "  make help   - Show this help message"
	@echo ""
	@echo "Personal Information:"
	@echo "  Option 1: Create personal.tex from personal.tex.example (recommended)"
	@echo "  Option 2: Use environment variables:"
	@echo "    RESUME_NAME, RESUME_TITLE, RESUME_EMAIL, RESUME_WEBSITE,"
	@echo "    RESUME_LOCATION, RESUME_PHONE"
	@echo ""
	@echo "Current branch: $(GIT_BRANCH)"
	@echo "Output file: $(PDF_FILE)"

