# Universal LaTeX CV Builder
# Self-contained environment for building professional CVs
# Supports the modular CV template system

FROM texlive/texlive:latest as latex-base

# Set up proper repository and install available packages
RUN tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet && \
    tlmgr update --self --verify-repo=none || true && \
    echo "Installing available packages from repository..." && \
    tlmgr install --verify-repo=none \
    moderncv \
    fontawesome5 \
    academicons \
    roboto \
    lato \
    sourcesanspro \
    paracol \
    geometry \
    xcolor \
    hyperref \
    enumitem \
    ragged2e \
    etoolbox \
    ifmtarg \
    babel \
    csquotes \
    biblatex \
    l3packages \
    microtype \
    iftex \
    fontspec \
    tgtermes \
    tgheros \
    pgf \
    tikz \
    || echo "Some packages may already be installed"

# Download and install altacv manually since it's not in the standard repository
RUN echo "Installing altacv class manually..." && \
    mkdir -p /tmp/altacv && \
    cd /tmp/altacv && \
    curl -L -o altacv.zip "https://github.com/liantze/altacv/archive/refs/heads/main.zip" && \
    unzip altacv.zip && \
    mkdir -p /usr/local/texlive/texmf-local/tex/latex/altacv && \
    find . -name "*.cls" -exec cp {} /usr/local/texlive/texmf-local/tex/latex/altacv/ \; && \
    find . -name "*.sty" -exec cp {} /usr/local/texlive/texmf-local/tex/latex/altacv/ \; 2>/dev/null || true && \
    texhash && \
    mktexlsr && \
    cd / && \
    rm -rf /tmp/altacv

# Verify critical packages are available
RUN echo "Verifying package installation..." && \
    kpsewhich moderncv.cls && \
    kpsewhich altacv.cls && \
    kpsewhich fontawesome5.sty && \
    echo "All required packages are available!"

# Set working directory
WORKDIR /cv

# Copy project files
COPY . .

# Ensure all scripts are executable
RUN find . -name "*.sh" -type f -exec chmod +x {} \;

# Create output directory with proper permissions
RUN mkdir -p output && chmod 755 output

# Set environment variables for better LaTeX compilation
ENV TEXMFHOME=/tmp/texmf
ENV TEXMFVAR=/tmp/texmf-var
ENV TEXMFCONFIG=/tmp/texmf-config

# Default command builds both CVs
CMD ["./build-cv.sh", "--local"]
