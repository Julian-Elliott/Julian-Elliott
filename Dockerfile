# Universal LaTeX CV Builder
# Self-contained environment for building professional CVs
# Supports the modular CV template system

FROM texlive/texlive:latest as latex-base

# Install additional LaTeX packages for CV templates
RUN tlmgr update --self --all && \
    tlmgr install \
    altacv \
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
    xparse \
    pgf \
    tikz \
    babel \
    csquotes \
    biblatex

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
