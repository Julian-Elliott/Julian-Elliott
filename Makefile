# LaTeX CV Build System Makefile
# Professional build automation with dependency management

OUTPUT_DIR := output
TEMPLATES_DIR := templates
DATA_DIR := data
MODERN_CV := modern-cv
ATS_CV := ats-friendly-cv
LATEX_ENGINE := xelatex
LATEX_FLAGS := -synctex=1 -interaction=nonstopmode -file-line-error

# Source files
DATA_FILES := $(wildcard $(DATA_DIR)/*.tex)
MODERN_SOURCE := $(TEMPLATES_DIR)/$(MODERN_CV).tex
ATS_SOURCE := $(TEMPLATES_DIR)/$(ATS_CV).tex

# Output files
MODERN_PDF := $(OUTPUT_DIR)/Modern-CV.pdf
ATS_PDF := $(OUTPUT_DIR)/ATS-Friendly-CV.pdf

.PHONY: all clean help info modern ats

all: $(MODERN_PDF) $(ATS_PDF)

$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

$(MODERN_PDF): $(MODERN_SOURCE) $(DATA_FILES) | $(OUTPUT_DIR)
	@echo "Building Modern CV..."
	@cd $(TEMPLATES_DIR) && $(LATEX_ENGINE) $(LATEX_FLAGS) -output-directory=../$(OUTPUT_DIR) $(MODERN_CV).tex
	@cd $(TEMPLATES_DIR) && $(LATEX_ENGINE) $(LATEX_FLAGS) -output-directory=../$(OUTPUT_DIR) $(MODERN_CV).tex
	@if [ -f "$(OUTPUT_DIR)/$(MODERN_CV).pdf" ]; then \
		mv "$(OUTPUT_DIR)/$(MODERN_CV).pdf" "$(MODERN_PDF)"; \
		echo "Modern CV built: $(MODERN_PDF)"; \
	fi

$(ATS_PDF): $(ATS_SOURCE) $(DATA_FILES) | $(OUTPUT_DIR)
	@echo "Building ATS CV..."
	@cd $(TEMPLATES_DIR) && $(LATEX_ENGINE) $(LATEX_FLAGS) -output-directory=../$(OUTPUT_DIR) $(ATS_CV).tex
	@cd $(TEMPLATES_DIR) && $(LATEX_ENGINE) $(LATEX_FLAGS) -output-directory=../$(OUTPUT_DIR) $(ATS_CV).tex
	@if [ -f "$(OUTPUT_DIR)/$(ATS_CV).pdf" ]; then \
		mv "$(OUTPUT_DIR)/$(ATS_CV).pdf" "$(ATS_PDF)"; \
		echo "ATS CV built: $(ATS_PDF)"; \
	fi

modern: $(MODERN_PDF)

ats: $(ATS_PDF)

clean:
	@echo "Cleaning auxiliary files..."
	@find . -name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.fdb_latexmk" \
		-o -name "*.fls" -o -name "*.synctex.gz" | xargs rm -f
	@echo "Cleaned"

info:
	@echo "CV Template Build System"
	@echo "Data files: $(DATA_FILES)"
	@echo "Output: $(MODERN_PDF) $(ATS_PDF)"

help:
	@echo "Available targets:"
	@echo "  all     - Build both CVs"
	@echo "  modern  - Build modern CV only"
	@echo "  ats     - Build ATS CV only"
	@echo "  clean   - Remove auxiliary files"
	@echo "  info    - Show build information"
