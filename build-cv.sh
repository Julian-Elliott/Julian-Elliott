#!/bin/bash

# Universal CV & Cover Letter Build System
# This script works for any user who has set up the template

echo "🚀 CV & Cover Letter Build System"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
OUTPUT_DIR="output"
TEMPLATES_DIR="templates"
DOCKER_IMAGE="cv-builder"

# Function to display help
show_help() {
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help          Show this help message"
    echo "  -d, --docker        Use Docker for compilation (recommended)"
    echo "  -l, --local         Use local LaTeX installation"
    echo "  -m, --modern        Build only modern CV"
    echo "  -a, --ats           Build only ATS-friendly CV"
    echo "  --cover-letter      Build cover letter template"
    echo "  --all               Build CVs and cover letter"
    echo "  -c, --clean         Clean output directory before building"
    echo "  -v, --verbose       Show detailed compilation output"
    echo ""
    echo "Examples:"
    echo "  $0                  # Build both CVs using best available method"
    echo "  $0 --docker         # Force Docker compilation"
    echo "  $0 --modern         # Build only modern CV"
    echo "  $0 --cover-letter   # Build cover letter template"
    echo "  $0 --all            # Build CVs and cover letter"
    echo "  $0 --clean --docker # Clean and build with Docker"
    echo ""
}

# Parse command line arguments
USE_DOCKER=""
USE_LOCAL=""
BUILD_MODERN=true
BUILD_ATS=true
BUILD_COVER_LETTER=false
BUILD_ALL=false
CLEAN_OUTPUT=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--docker)
            USE_DOCKER=true
            ;;
        -l|--local)
            USE_LOCAL=true
            ;;
        -m|--modern)
            BUILD_MODERN=true
            BUILD_ATS=false
            ;;
        -a|--ats)
            BUILD_MODERN=false
            BUILD_ATS=true
            ;;
        --cover-letter)
            BUILD_COVER_LETTER=true
            ;;
        --all)
            BUILD_MODERN=true
            BUILD_ATS=true
            BUILD_COVER_LETTER=true
            ;;
        -c|--clean)
            CLEAN_OUTPUT=true
            ;;
        -v|--verbose)
            VERBOSE=true
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect LaTeX installation
detect_latex() {
    # Prefer xelatex
    if command -v xelatex >/dev/null 2>&1; then
        echo "xelatex"
    elif [ -x "/Library/TeX/texbin/xelatex" ]; then
        echo "/Library/TeX/texbin/xelatex"
    # Fallback to lualatex
    elif command -v lualatex >/dev/null 2>&1; then
        echo "lualatex"
    elif [ -x "/Library/TeX/texbin/lualatex" ]; then
        echo "/Library/TeX/texbin/lualatex"
    # Fallback to pdflatex
    elif command -v pdflatex >/dev/null 2>&1; then
        echo "pdflatex"
    elif [ -x "/Library/TeX/texbin/pdflatex" ]; then
        echo "/Library/TeX/texbin/pdflatex"
    else
        echo ""
    fi
}

# Function to check Docker availability
check_docker() {
    if command_exists docker && docker info >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Function to build Docker image
build_docker_image() {
    echo -e "${BLUE}🐳 Building Docker image...${NC}"
    if docker build -t $DOCKER_IMAGE . >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Docker image built successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed to build Docker image${NC}"
        return 1
    fi
}

# Function to compile with Docker
compile_with_docker() {
    echo -e "${BLUE}🐳 Compiling CVs with Docker...${NC}"
    
    # Build image if it doesn't exist
    if ! docker image inspect $DOCKER_IMAGE >/dev/null 2>&1; then
        if ! build_docker_image; then
            return 1
        fi
    fi
    
    # Run compilation in Docker
    docker run --rm \
        -v "$(pwd):/cv" \
        -w /cv \
        $DOCKER_IMAGE \
        ./build-cv.sh --local
}

# Function to compile locally
compile_locally() {
    local latex_cmd="$1"
    local template="$2"
    local output_name="$3"
    
    echo -e "${BLUE}📄 Compiling $(basename "$template")...${NC}"
    
    # Change to templates directory
    cd "$TEMPLATES_DIR" || return 1
    
    # Compile (first pass)
    echo -e "${BLUE}  → First pass...${NC}"
    if [ "$VERBOSE" = true ]; then
        $latex_cmd "$(basename "$template")"
    else
        $latex_cmd "$(basename "$template")" >/dev/null 2>&1
    fi
    
    local first_pass_result=$?
    if [ $first_pass_result -eq 0 ]; then
        # Second pass for references
        echo -e "${BLUE}  → Second pass...${NC}"
        if [ "$VERBOSE" = true ]; then
            $latex_cmd "$(basename "$template")"
        else
            $latex_cmd "$(basename "$template")" >/dev/null 2>&1
        fi
        
        local second_pass_result=$?
        if [ $second_pass_result -eq 0 ]; then
            # Move PDF to output directory with proper name
            local pdf_file="${template%.tex}.pdf"
            if [ -f "$(basename "$pdf_file")" ]; then
                mv "$(basename "$pdf_file")" "../$OUTPUT_DIR/$output_name"
                echo -e "${GREEN}✓ Successfully compiled $(basename "$template")${NC}"
                echo -e "${GREEN}  → $OUTPUT_DIR/$output_name${NC}"
                cd .. || return 1
                return 0
            else
                echo -e "${RED}✗ PDF file not generated: $(basename "$pdf_file")${NC}"
            fi
        else
            echo -e "${RED}✗ Second pass failed for $(basename "$template")${NC}"
            if [ -f "$(basename "${template%.tex}.log")" ]; then
                echo -e "${YELLOW}--- Recent log messages from $(basename "${template%.tex}.log") ---${NC}"
                tail -n 30 "$(basename "${template%.tex}.log")"
                echo -e "${YELLOW}--- End of log messages ---${NC}"
            fi
            if [ "$VERBOSE" != true ]; then
                echo -e "${YELLOW}  Run with --verbose to see detailed errors${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ First pass failed for $(basename "$template")${NC}"
        if [ -f "$(basename "${template%.tex}.log")" ]; then
            echo -e "${YELLOW}--- Recent log messages from $(basename "${template%.tex}.log") ---${NC}"
            tail -n 30 "$(basename "${template%.tex}.log")"
            echo -e "${YELLOW}--- End of log messages ---${NC}"
        fi
        if [ "$VERBOSE" != true ]; then
            echo -e "${YELLOW}  Run with --verbose to see detailed errors${NC}"
        fi
    fi
    
    echo -e "${RED}✗ Failed to compile $(basename "$template")${NC}"
    cd .. || return 1
    return 1
}

# Function to clean auxiliary files
clean_aux_files() {
    echo -e "${BLUE}🧹 Cleaning auxiliary files...${NC}"
    find . \( -name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.fdb_latexmk" -o -name "*.fls" -o -name "*.synctex.gz" \) -exec rm -f {} +
    echo -e "${GREEN}✓ Auxiliary files cleaned${NC}"
}

# Function to build cover letter template
build_cover_letter_template() {
    echo -e "${BLUE}📝 Building cover letter template...${NC}"
    
    # Check if cover letter content file exists
    if [ ! -f "data/cover-letter-content.tex" ]; then
        echo -e "${YELLOW}⚠ Cover letter content file not found. Creating template...${NC}"
        echo "% Cover letter content template - customize for each application" > data/cover-letter-content.tex
        echo "% See templates/cover-letter-template.tex for usage examples" >> data/cover-letter-content.tex
    fi
    
    local LATEX_CMD="$1"
    if compile_locally "$LATEX_CMD" "$TEMPLATES_DIR/cover-letter.tex" "Cover-Letter-Template.pdf"; then
        echo -e "${GREEN}✓ Cover letter template built successfully${NC}"
        echo -e "${BLUE}ℹ️  To customize for specific applications:${NC}"
        echo -e "${BLUE}   1. Copy templates/cover-letter-template.tex${NC}"
        echo -e "${BLUE}   2. Customize job and company details${NC}"
        echo -e "${BLUE}   3. Build with: xelatex your-custom-cover-letter.tex${NC}"
        return 0
    else
        echo -e "${RED}✗ Cover letter template build failed${NC}"
        return 1
    fi
}

# Main execution
echo -e "${PURPLE}Building CV for: $(whoami)${NC}"

# Clean output if requested
if [ "$CLEAN_OUTPUT" = true ]; then
    echo -e "${YELLOW}🧹 Cleaning output directory...${NC}"
    rm -rf "$OUTPUT_DIR"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Determine compilation method
if [ "$USE_DOCKER" = true ] || { [ "$USE_LOCAL" != true ] && ! detect_latex >/dev/null; }; then
    if check_docker; then
        compile_with_docker
        exit $?
    else
        echo -e "${RED}✗ Docker not available and no local LaTeX installation found${NC}"
        echo ""
        echo "Please either:"
        echo "1. Install Docker: https://docs.docker.com/get-docker/"
        echo "2. Install LaTeX: brew install --cask mactex"
        exit 1
    fi
else
    # Use local LaTeX
    LATEX_CMD=$(detect_latex)
    if [ -z "$LATEX_CMD" ]; then
        echo -e "${RED}✗ No LaTeX installation found${NC}"
        echo "Please install LaTeX: brew install --cask mactex"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Using local LaTeX: $LATEX_CMD${NC}"
    
    # Compile modern CV
    if [ "$BUILD_MODERN" = true ]; then
        if ! compile_locally "$LATEX_CMD" "$TEMPLATES_DIR/modern-cv.tex" "Modern-CV.pdf"; then
            echo -e "${YELLOW}⚠ Modern CV compilation failed${NC}"
        fi
    fi
    
    # Compile ATS-friendly CV
    if [ "$BUILD_ATS" = true ]; then
        if ! compile_locally "$LATEX_CMD" "$TEMPLATES_DIR/ats-friendly-cv.tex" "ATS-Friendly-CV.pdf"; then
            echo -e "${YELLOW}⚠ ATS-friendly CV compilation failed${NC}"
        fi
    fi
    
    # Compile cover letter
    if [ "$BUILD_COVER_LETTER" = true ]; then
        if ! build_cover_letter_template "$LATEX_CMD"; then
            echo -e "${YELLOW}⚠ Cover letter compilation failed${NC}"
        fi
    fi
    
    # Clean auxiliary files
    clean_aux_files
fi

# Function to validate build results
validate_build() {
    local success=true
    echo ""
    echo -e "${PURPLE}🎉 Build process complete!${NC}"
    echo ""
    echo "Generated files in $OUTPUT_DIR/:"
    
    if [ "$BUILD_MODERN" = true ]; then
        if [ -f "$OUTPUT_DIR/Modern-CV.pdf" ]; then
            echo -e "${GREEN}✓ Modern-CV.pdf${NC}"
        else
            echo -e "${RED}✗ Modern-CV.pdf (MISSING)${NC}"
            success=false
        fi
    fi
    
    if [ "$BUILD_ATS" = true ]; then
        if [ -f "$OUTPUT_DIR/ATS-Friendly-CV.pdf" ]; then
            echo -e "${GREEN}✓ ATS-Friendly-CV.pdf${NC}"
        else
            echo -e "${RED}✗ ATS-Friendly-CV.pdf (MISSING)${NC}"
            success=false
        fi
    fi
    
    if [ "$BUILD_COVER_LETTER" = true ]; then
        if [ -f "$OUTPUT_DIR/Cover-Letter-Template.pdf" ]; then
            echo -e "${GREEN}✓ Cover-Letter-Template.pdf${NC}"
        else
            echo -e "${RED}✗ Cover-Letter-Template.pdf (MISSING)${NC}"
            success=false
        fi
    fi
    
    if [ -z "$(ls -A $OUTPUT_DIR/*.pdf 2>/dev/null)" ]; then
        echo -e "${RED}No PDF files found${NC}"
        success=false
    fi
    
    echo ""
    if [ "$success" = true ]; then
        echo -e "${GREEN}💡 Success! Your CVs and cover letter are ready:${NC}"
        echo "• Use Modern-CV.pdf for human reviewers and networking"
        echo "• Use ATS-Friendly-CV.pdf for online job applications"
        echo "• Use Cover-Letter.pdf for your job applications"
        echo "• Run with --help to see all options"
        return 0
    else
        echo -e "${RED}💡 Build Issues Detected:${NC}"
        echo "• Check template syntax and data file paths"
        echo "• Run with --verbose to see detailed compilation errors"
        echo "• Ensure all required LaTeX packages are installed"
        return 1
    fi
}

# Validate and report results
validate_build
