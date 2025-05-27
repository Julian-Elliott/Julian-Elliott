#!/bin/bash

# CV Template Setup Script
# This script helps new users set up the CV template with their own information

echo "🚀 CV Template Setup"
echo "==================="
echo ""
echo "This script will help you customize the CV template with your information."
echo "You can always modify the files manually later."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to prompt for input with default
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"
    
    echo -n "$prompt [$default]: "
    read input
    if [ -z "$input" ]; then
        eval "$var_name=\"$default\""
    else
        eval "$var_name=\"$input\""
    fi
}

echo -e "${BLUE}📝 Personal Information${NC}"
echo "Please enter your personal details:"
echo ""

prompt_with_default "Full Name" "Your Name" USER_NAME
prompt_with_default "Professional Title" "Your Professional Title" USER_TITLE
prompt_with_default "Email Address" "your.email@example.com" USER_EMAIL
prompt_with_default "Phone Number" "+1 234 567 8900" USER_PHONE
prompt_with_default "Location" "City, Country" USER_LOCATION
prompt_with_default "LinkedIn Username" "yourusername" USER_LINKEDIN
prompt_with_default "GitHub Username" "yourusername" USER_GITHUB

echo ""
echo -e "${BLUE}📸 Professional Photo${NC}"
echo "Do you have a professional photo to include?"
echo "1) Yes, I have a photo file"
echo "2) No, use placeholder"
echo -n "Choice [2]: "
read photo_choice

if [ "$photo_choice" = "1" ]; then
    echo -n "Photo filename (without extension): "
    read USER_PHOTO
    if [ -z "$USER_PHOTO" ]; then
        USER_PHOTO="your-photo"
    fi
else
    USER_PHOTO="placeholder-photo"
fi

echo ""
echo -e "${BLUE}💼 Professional Summary${NC}"
echo "Enter a brief professional summary (or press Enter to use template):"
read -r USER_SUMMARY

if [ -z "$USER_SUMMARY" ]; then
    USER_SUMMARY="Professional [Your Title] with X+ years of experience in [Your Field]. Expertise in [Your Skills]. Proven track record of [Your Achievements]."
fi

echo ""
echo -e "${BLUE}🏆 Key Achievement${NC}"
echo "Enter a key achievement metric (e.g., '£2M+ in savings', '50% efficiency gains'):"
read USER_ACHIEVEMENT

if [ -z "$USER_ACHIEVEMENT" ]; then
    USER_ACHIEVEMENT="[Your Key Achievement]"
fi

echo ""
echo -e "${YELLOW}🔧 Setting up your CV...${NC}"

# Create personal config directory if it doesn't exist
mkdir -p config

# Update the personal-info.tex file
cat > data/personal-info.tex << EOF
% Personal Information - Single Source of Truth
% This file contains all personal details used across CV templates

% Contact Information
\newcommand{\myname}{$USER_NAME}
\newcommand{\mytitle}{$USER_TITLE}
\newcommand{\myemail}{$USER_EMAIL}
\newcommand{\myphone}{$USER_PHONE}
\newcommand{\mylocation}{$USER_LOCATION}
\newcommand{\mylinkedin}{$USER_LINKEDIN}
\newcommand{\mygithub}{$USER_GITHUB}
\newcommand{\myphoto}{$USER_PHOTO}

% Professional Summary
\newcommand{\mysummary}{$USER_SUMMARY}

% Key Achievements (for easy reuse)
\newcommand{\mainachievement}{$USER_ACHIEVEMENT}
\newcommand{\efficiencyachievement}{50\\% efficiency improvements}
\newcommand{\salesachievement}{33\\% sales growth}
\newcommand{\experienceyears}{X+ years}
EOF

# Create a personal config file
cat > config/my-cv-config.yaml << EOF
# Your Personal CV Configuration
# Generated on $(date)

personal:
  name: "$USER_NAME"
  title: "$USER_TITLE"
  email: "$USER_EMAIL"
  phone: "$USER_PHONE"
  location: "$USER_LOCATION"
  linkedin: "$USER_LINKEDIN"
  github: "$USER_GITHUB"
  photo: "$USER_PHOTO"

summary: |
  $USER_SUMMARY

key_achievement: "$USER_ACHIEVEMENT"

# TODO: Update the following sections with your information
# - Edit data/experience.tex with your job history
# - Edit data/skills.tex with your technical skills
# - Edit data/education.tex with your education background
# - Add your professional photo as $USER_PHOTO.jpg
EOF

echo ""
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo ""
echo "Next steps:"
echo "1. 📝 Edit data/experience.tex with your work history"
echo "2. 🛠️  Edit data/skills.tex with your technical skills"
echo "3. 🎓 Edit data/education.tex with your education"
echo "4. 📸 Add your photo as $USER_PHOTO.jpg"
echo "5. 🏗️  Run ./build-cv.sh to generate your CVs"
echo ""
echo "Your personal config is saved in: config/my-cv-config.yaml"
echo ""
echo -e "${BLUE}💡 Pro tip:${NC} Check out the examples in the Julian Elliott template for reference!"
