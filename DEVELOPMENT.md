# CV Template Development Guide

## 🚀 Quick Start

### Prerequisites
- **LaTeX Distribution**: TeX Live (recommended) or MiKTeX
- **VS Code**: With LaTeX Workshop extension
- **Docker** (optional): For containerized builds

### Getting Started
1. Open this workspace in VS Code: `cv-template.code-workspace`
2. Install recommended extensions when prompted
3. Use `Ctrl+Shift+P` → "Tasks: Run Task" to see available build options

### ✅ System Validation
**New!** Run the validation script to check your system:
```bash
chmod +x validate-cv.sh
./validate-cv.sh
```
This will check all dependencies, file structure, and LaTeX syntax.

## 🛠️ Development Workflow

### Building CVs
- **Fastest**: `make all` (if you have LaTeX installed locally)
- **Most Compatible**: `./build-cv.sh --docker` (Docker)
- **Development**: `make watch` for automatic rebuilds
- **Selective**: `./build-cv.sh --modern` or `./build-cv.sh --ats`

**Recent Fix**: Template path issues have been resolved. Both modern and ATS-friendly CVs now compile successfully with proper data file imports.

### File Structure
```
data/           # Single source of truth for all content
├── personal-info.tex    # Contact details, name, title
├── experience.tex       # Work experience entries
├── skills.tex          # Technical skills and ratings
└── education.tex        # Education and certifications

templates/      # LaTeX template files
├── modern-cv.tex        # AltaCV-based visual template
├── ats-friendly-cv.tex  # ModernCV-based ATS template
└── common-packages.tex  # Shared package configuration

output/         # Generated PDFs appear here
```

## 📝 Content Management

### Adding New Experience
1. Edit `data/experience.tex`
2. Create new command: `\newcommand{\myNewJobEntry}{...}`
3. Add to both templates in appropriate sections

### Updating Skills
1. Edit `data/skills.tex` 
2. For visual skills: `\newcommand{\skillName}{rating}`
3. For ATS lists: Update category commands

### LaTeX Best Practices

#### Command Naming
- Use semantic names: `\automationAnalystEntry` not `\job1`
- Prefix with content type: `\skill`, `\cert`, `\achievement`
- Use camelCase for consistency

#### Content Structure
```latex
% Good: Semantic and reusable
\newcommand{\savingsAchievement}{£2M+ in annual savings}

% Avoid: Hard-coded values scattered throughout
```

#### Error Prevention
```latex
% Always provide fallbacks
\providecommand{\myname}{Your Name Here}

% Use consistent formatting
\newcommand{\skillPython}{5}  % Rating 1-5
```

## 🎨 Customization

### Colors (Modern CV)
Edit `templates/modern-cv.tex`:
```latex
\definecolor{VividPurple}{HTML}{3E0097}  % Primary color
\definecolor{SlateGrey}{HTML}{2E2E2E}    % Text color
```

### Fonts
```latex
% XeLaTeX/LuaLaTeX (recommended)
\setmainfont{Roboto Slab}
\setsansfont{Lato}

% PDFLaTeX fallback
\usepackage[rm]{roboto}
\usepackage[defaultsans]{lato}
```

### Layout
```latex
% Page margins
\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm}

% Column ratio (modern CV)
\columnratio{0.6}  % 60% left, 40% right
```

## 🔧 VS Code Features

### Snippets
- Type `cventry` → Create experience entry
- Type `cvskill` → Add skill with rating  
- Type `newcert` → Define certification

### Tasks (Ctrl+Shift+P → "Tasks: Run Task")
- **Build All CVs**: Default build (Docker)
- **Make: Build All CVs**: Fast local build
- **Make: Watch**: Auto-rebuild on file changes
- **Make: Validate**: Check LaTeX syntax

### LaTeX Workshop Features
- **Auto-compile**: Saves trigger builds
- **PDF Preview**: View output in VS Code
- **Syntax Highlighting**: LaTeX-aware editor
- **Error Detection**: Real-time problem detection

## 🐛 Troubleshooting

### Common Issues

#### "Command not found" errors
- **Problem**: Missing LaTeX packages
- **Solution**: Use Docker build or install missing packages

#### PDF not updating
- **Problem**: Cached auxiliary files
- **Solution**: Run "Make: Clean" task or `make clean`

#### Compilation errors
- **Problem**: LaTeX syntax errors
- **Solution**: Check Problems panel in VS Code

#### Font issues
- **Problem**: Missing fonts in Docker
- **Solution**: Use XeLaTeX with included fonts

### Build Debugging
```bash
# Verbose build output
./build-cv.sh --verbose

# Check LaTeX log files
find . -name "*.log" -exec cat {} \;

# Validate syntax
make validate
```

## 📋 Code Quality

### LaTeX Standards
- **Encoding**: Always use UTF-8
- **Line Length**: Keep under 80 characters where possible
- **Indentation**: 2 spaces for LaTeX
- **Comments**: Document complex sections

### Content Standards
- **Achievements**: Use quantified results
- **Skills**: Honest self-assessment (1-5 scale)
- **Consistency**: Same format across all entries
- **Grammar**: Professional language throughout

### Version Control
- **Commit Frequently**: Small, logical changes
- **Branch for Features**: Use branches for major updates
- **Tag Releases**: Tag stable versions
- **Document Changes**: Clear commit messages

## 🚀 Advanced Features

### Custom Templates
1. Copy existing template
2. Modify layout and styling
3. Update build scripts to include new template
4. Test thoroughly with sample data

### Automated Builds
```yaml
# .github/workflows/build-cv.yml
name: Build CV
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build CVs
        run: docker-compose up --build
```

### Multi-language Support
```latex
% In data files
\newcommand{\mynameEN}{Julian Elliott}
\newcommand{\mynameES}{Julián Elliott}

% In templates
\usepackage[english,spanish]{babel}
```

## 📚 Resources

- [AltaCV Documentation](https://github.com/liantze/altacv)
- [ModernCV Guide](https://ctan.org/pkg/moderncv)
- [LaTeX Workshop VS Code Extension](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)
- [LaTeX Best Practices](https://en.wikibooks.org/wiki/LaTeX)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Make improvements
4. Test thoroughly
5. Submit pull request

Remember: This template is designed to be a starting point. Customize it to match your personal brand and career objectives!
