# 📄 Modular LaTeX CV Template

A professional, maintainable CV system with modular content management and Docker support. Build beautiful CVs with a single source of truth for all your information.

[![Docker Support](https://img.shields.io/badge/Docker-Supported-blue?logo=docker)](Dockerfile)
[![LaTeX](https://img.shields.io/badge/LaTeX-Template-green?logo=latex)](templates/)
[![Modular](https://img.shields.io/badge/Design-Modular-orange)](data/)

## 🚀 Quick Start

### For New Users

1. **Clone and Setup**
   ```bash
   git clone <this-repo>
   cd <repo-name>
   ./setup-cv.sh
   ```

2. **Add Your Information**
   - Edit `data/experience.tex` with your work history
   - Edit `data/skills.tex` with your technical skills
   - Edit `data/education.tex` with your education
   - Add your photo as `your-photo.jpg`

3. **Build Your CVs**
   ```bash
   ./build-cv.sh
   ```

### For the Included Example (Julian Elliott)

```bash
# Build using Docker (recommended)
./build-cv.sh --docker

# Or build locally (requires LaTeX installation)
./build-cv.sh --local
```

## 🏗️ Project Structure

```
📂 Modular CV Template
├── 🔧 build-cv.sh                  # Universal build script
├── ⚙️  setup-cv.sh                 # New user setup wizard
├── 🐳 Dockerfile                   # Self-contained build environment
├── 🐳 docker-compose.yml           # Docker development environment
├── 📸 [your-photo].jpg             # Professional photo
├── 📁 templates/                   # LaTeX CV templates
│   ├── modern-cv.tex              # Modern visual CV (AltaCV)
│   └── ats-friendly-cv.tex        # ATS-optimized CV (ModernCV)
├── 📁 data/                        # Single source of truth
│   ├── personal-info.tex          # Contact & summary
│   ├── experience.tex             # Work history
│   ├── skills.tex                 # Skills & certifications
│   └── education.tex              # Education & development
├── 📁 examples/                    # Template examples
│   ├── experience-template.tex    # How to structure experience
│   ├── skills-template.tex        # How to structure skills
│   └── education-template.tex     # How to structure education
├── 📁 config/                      # Configuration files
│   └── cv-config.yaml             # Template configuration
└── 📁 output/                      # Generated PDFs
```

## 🎨 CV Templates

### Modern CV (AltaCV)
- **Style**: Visual, modern design with photo
- **Features**: Skill ratings, activity wheel, color themes
- **Best for**: Human reviewers, networking, creative roles
- **Color**: Customizable (default: VividPurple)

### ATS-Friendly CV (ModernCV)
- **Style**: Clean, single-column, keyword-rich
- **Features**: Maximum ATS compatibility, structured layout
- **Best for**: Online applications, ATS systems
- **Focus**: Keyword density and clean formatting

## 📝 Content Management

### Modular Design Benefits

✅ **Single Source of Truth** - Update once, applies everywhere  
✅ **No Duplication** - Consistent information across templates  
✅ **Easy Maintenance** - Centralized content management  
✅ **Template Flexibility** - Add new templates without content duplication  

### Data Files

| File | Purpose | Contains |
|------|---------|----------|
| `personal-info.tex` | Identity | Name, contact, summary, key achievements |
| `experience.tex` | Work History | Jobs with both template format variants |
| `skills.tex` | Technical Skills | Skills ratings, certifications, technologies |
| `education.tex` | Education | Degrees, courses, professional development |

### Updating Content

```bash
# Update your contact information
nano data/personal-info.tex

# Add new job experience
nano data/experience.tex

# Update skills and certifications
nano data/skills.tex

# Add education or training
nano data/education.tex

# Rebuild both CVs
./build-cv.sh
```

## 🔧 Build System

### Docker Build (Recommended)

```bash
# Build both CVs with Docker
./build-cv.sh --docker

# Build only modern CV
./build-cv.sh --docker --modern

# Clean build with verbose output
./build-cv.sh --docker --clean --verbose
```

**Benefits:**
- ✅ No local LaTeX installation required
- ✅ Consistent builds across all systems
- ✅ All dependencies included
- ✅ Works on macOS, Linux, Windows

### Local Build

```bash
# Install LaTeX (macOS)
brew install --cask mactex

# Build locally
./build-cv.sh --local
```

### Build Options

| Option | Description |
|--------|-------------|
| `--docker` | Use Docker for compilation |
| `--local` | Use local LaTeX installation |
| `--modern` | Build only modern CV |
| `--ats` | Build only ATS-friendly CV |
| `--clean` | Clean output directory first |
| `--verbose` | Show detailed compilation output |
| `--help` | Show all options |

## 🎯 Customization Guide

### For New Users

1. **Run Setup Wizard**
   ```bash
   ./setup-cv.sh
   ```

2. **Customize Content**
   - Follow the examples in `examples/` directory
   - Use the included Julian Elliott data as reference
   - Update `data/` files with your information

3. **Personalize Design**
   - Modify colors in `templates/modern-cv.tex`
   - Adjust layout in template files
   - Add new sections as needed

### Adding New Templates

1. Create new `.tex` file in `templates/`
2. Add data imports: `\input{../data/[file]}`
3. Use modular commands from data files
4. Update `build-cv.sh` if needed

## 🐳 Docker Environment

### Features
- **Base**: Official TeXLive image with full LaTeX distribution
- **Packages**: Pre-installed AltaCV, ModernCV, FontAwesome5, and dependencies
- **Build**: Automatic compilation with proper permissions
- **Output**: PDFs generated in `output/` directory

### Manual Docker Usage

```bash
# Build image
docker build -t cv-builder .

# Run compilation
docker run --rm -v "$(pwd):/cv" cv-builder

# Interactive development
docker run --rm -it -v "$(pwd):/cv" cv-builder bash
```

## 📊 Example: Julian Elliott

This repository includes a complete example CV for Julian Elliott, demonstrating:

- **Professional Data Analyst CV** with quantified achievements
- **Modern visual design** with professional photo integration
- **ATS-optimized version** for online applications
- **Comprehensive skill ratings** and certifications
- **Real-world work experience** formatting
- **Professional development** and education

### Julian's Achievements Highlighted
- 💰 **£2M+ in annual savings** through automation
- 📈 **50% efficiency improvements** in process optimization
- 🎯 **33% sales growth** through data-driven strategies
- 🎓 **14+ years experience** in data analytics and automation

## 🛠️ Troubleshooting

### Common Issues

**Docker Build Fails**
```bash
# Check Docker is running
docker info

# Rebuild image
docker build --no-cache -t cv-builder .
```

**LaTeX Compilation Errors**
```bash
# Check logs in output directory
cat output/*.log

# Try verbose build to see errors
./build-cv.sh --verbose

# Use Docker to avoid local LaTeX issues
./build-cv.sh --docker
```

**Missing Packages**
```bash
# Install specific package
tlmgr install [package-name]

# Or use Docker (includes all packages)
./build-cv.sh --docker
```

## 📈 Usage Scenarios

### Job Applications
1. **ATS Systems**: Use `ATS-Friendly-CV.pdf`
2. **Human Review**: Use `Modern-CV.pdf`
3. **Networking**: Print `Modern-CV.pdf`

### Content Updates
1. **New Position**: Add to `experience.tex`
2. **New Certification**: Update `skills.tex`
3. **Contact Change**: Modify `personal-info.tex`
4. **Education Progress**: Update `education.tex`

### Template Expansion
1. **New Design**: Create in `templates/`
2. **New Format**: Copy and modify existing
3. **New Sections**: Add to data files
4. **Custom Builds**: Extend `build-cv.sh`

## 🔮 Advanced Features

### Multi-Language Support (Future)
- Separate data files per language
- Language-specific templates
- Automated language switching

### Automation Integration
- GitHub Actions for automatic builds
- Git hooks for content validation
- Automated certification link checking

### Web Integration
- HTML export capability
- Online preview generation
- Web-based content editor

## 🤝 Contributing

This template is designed to be:
- ✅ **Easily customizable** for individual needs
- ✅ **Extensible** with new templates and features
- ✅ **Maintainable** through modular design
- ✅ **Shareable** as a starting point for others

Feel free to:
- Add new templates
- Improve the build system
- Enhance documentation
- Share your customizations

## 📝 License

This template is provided as-is for personal and professional use. Feel free to adapt, modify, and share.

## 📧 Support

For questions about using this template:
- Review the `examples/` directory for implementation patterns
- Look at Julian Elliott's implementation as a reference

---

**Built with ❤️ for the professional community**  
*Making beautiful CVs accessible to everyone*
