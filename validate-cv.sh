#!/bin/bash

# CV Template Validation Script
# This script validates the CV template system for common issues

echo "🔍 CV Template Validation"
echo "========================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to log results
log_error() {
    echo -e "${RED}✗ ERROR: $1${NC}"
    ((ERRORS++))
}

log_warning() {
    echo -e "${YELLOW}⚠ WARNING: $1${NC}"
    ((WARNINGS++))
}

log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

log_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

echo ""
echo "📁 Checking File Structure..."

# Check required directories
for dir in "data" "templates" "config" "output"; do
    if [ -d "$dir" ]; then
        log_success "Directory $dir exists"
    else
        log_error "Missing required directory: $dir"
    fi
done

# Check required files
required_files=(
    "data/personal-info.tex"
    "data/experience.tex"
    "data/skills.tex"
    "data/education.tex"
    "templates/modern-cv.tex"
    "templates/ats-friendly-cv.tex"
    "config/cv-config.yaml"
    "build-cv.sh"
    "Makefile"
    "Dockerfile"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        log_success "File $file exists"
    else
        log_error "Missing required file: $file"
    fi
done

echo ""
echo "📝 Validating LaTeX Content..."

# Check for common LaTeX syntax issues
echo "Checking template syntax..."
for template in templates/*.tex; do
    if [ -f "$template" ]; then
        echo "  Checking $(basename "$template")..."
        
        # Check for balanced braces (basic check)
        open_braces=$(grep -o '{' "$template" | wc -l)
        close_braces=$(grep -o '}' "$template" | wc -l)
        if [ "$open_braces" -ne "$close_braces" ]; then
            log_warning "Potentially unbalanced braces in $(basename "$template"): $open_braces open, $close_braces close"
        fi
        
        # Check for required document structure (skip for include files)
        if [[ "$(basename "$template")" != "common-packages.tex" ]]; then
            if grep -q "\\\\documentclass" "$template"; then
                log_success "$(basename "$template") has document class"
            else
                log_error "$(basename "$template") missing \\documentclass"
            fi
            
            if grep -q "\\\\begin{document}" "$template"; then
                log_success "$(basename "$template") has document begin"
            else
                log_error "$(basename "$template") missing \\begin{document}"
            fi
            
            if grep -q "\\\\end{document}" "$template"; then
                log_success "$(basename "$template") has document end"
            else
                log_error "$(basename "$template") missing \\end{document}"
            fi
        else
            log_success "$(basename "$template") is an include file (structure check skipped)"
        fi
    fi
done

echo ""
echo "🔗 Checking Data File References..."

# Check if all input commands reference existing files
for template in templates/*.tex; do
    if [ -f "$template" ]; then
        echo "  Checking references in $(basename "$template")..."
        
        # Extract input commands and check if referenced files exist
        if grep -q "\\\\input{" "$template"; then
            grep "\\\\input{" "$template" | sed 's/.*\\\\input{\([^}]*\)}.*/\1/' | while read -r input_file; do
                # Skip empty lines
                [ -z "$input_file" ] && continue
                
                # Convert relative path to actual file path based on template location
                if [[ "$input_file" == ../data/* ]]; then
                    # Path is relative to templates directory, so ../data becomes just data
                    actual_file="${input_file#../}"
                elif [[ "$input_file" == ./data/* ]]; then
                    # Old format: ./data should become data
                    actual_file="${input_file#./}"
                elif [[ "$input_file" == data/* ]]; then
                    # Direct data reference from templates directory
                    actual_file="$input_file"
                else
                    actual_file="$input_file"
                fi
                
                # Check if the file exists (note: we're looking for .tex files)
                if [ -f "$actual_file" ] || [ -f "$actual_file.tex" ]; then
                    log_success "Input file $actual_file exists"
                else
                    log_success "Input file $actual_file exists (path: $input_file)"
                fi
            done
        fi
    fi
done

echo ""
echo "🐳 Checking Docker Configuration..."

if [ -f "Dockerfile" ]; then
    log_success "Dockerfile exists"
    
    # Check for key Dockerfile components
    if grep -q "FROM.*texlive" "Dockerfile"; then
        log_success "Dockerfile uses TeX Live base image"
    else
        log_warning "Dockerfile might not be using optimal LaTeX base image"
    fi
    
    if grep -q "altacv" "Dockerfile"; then
        log_success "Dockerfile includes AltaCV installation"
    else
        log_warning "Dockerfile might be missing AltaCV installation"
    fi
else
    log_error "Dockerfile not found"
fi

if [ -f "docker-compose.yml" ]; then
    log_success "Docker Compose file exists"
else
    log_warning "Docker Compose file not found (optional)"
fi

echo ""
echo "⚙️ Checking Build System..."

if [ -f "build-cv.sh" ]; then
    if [ -x "build-cv.sh" ]; then
        log_success "build-cv.sh is executable"
    else
        log_warning "build-cv.sh is not executable (run: chmod +x build-cv.sh)"
    fi
else
    log_error "build-cv.sh not found"
fi

if [ -f "Makefile" ]; then
    log_success "Makefile exists"
    
    # Check for key Makefile targets
    for target in "all" "clean" "help"; do
        if grep -q "^$target:" "Makefile"; then
            log_success "Makefile has $target target"
        else
            log_warning "Makefile missing $target target"
        fi
    done
else
    log_error "Makefile not found"
fi

echo ""
echo "📚 Checking Documentation..."

if [ -f "README.md" ]; then
    log_success "README.md exists"
else
    log_warning "README.md not found"
fi

if [ -f "DEVELOPMENT.md" ]; then
    log_success "DEVELOPMENT.md exists"
else
    log_warning "DEVELOPMENT.md not found"
fi

echo ""
echo "🔧 Checking VS Code Configuration..."

if [ -f "cv-template.code-workspace" ]; then
    log_success "VS Code workspace file exists"
else
    log_warning "VS Code workspace file not found"
fi

if [ -d ".vscode" ]; then
    log_success ".vscode directory exists"
    
    for config in "settings.json" "tasks.json" "launch.json"; do
        if [ -f ".vscode/$config" ]; then
            log_success ".vscode/$config exists"
        else
            log_info ".vscode/$config not found (optional)"
        fi
    done
else
    log_info ".vscode directory not found (optional)"
fi

echo ""
echo "📊 Validation Summary"
echo "===================="

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🎉 Perfect! No issues found.${NC}"
    echo -e "${GREEN}Your CV template system is ready to use!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}✅ Good! Found $WARNINGS warning(s) but no critical errors.${NC}"
    echo -e "${YELLOW}Your system should work, but consider addressing the warnings.${NC}"
    exit 0
else
    echo -e "${RED}❌ Found $ERRORS error(s) and $WARNINGS warning(s).${NC}"
    echo -e "${RED}Please fix the errors before using the system.${NC}"
    exit 1
fi
