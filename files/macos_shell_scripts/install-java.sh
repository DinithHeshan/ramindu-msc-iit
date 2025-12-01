#!/bin/bash
set -e

ZSHRC="$HOME/.zshrc"

# Load all environment variables that Homebrew needs
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "Updating Homebrew..."
brew update

# Install OpenJDK 21
echo "Installing OpenJDK 21..."
brew install openjdk@21

# Link JDK (macOS requires manual linking)
JDK_SYMLINK="/Library/Java/JavaVirtualMachines/openjdk-21.jdk"
JDK_TARGET="$(brew --prefix openjdk@21)/libexec/openjdk.jdk"

if [ -L "$JDK_SYMLINK" ]; then
    echo "Symlink $JDK_SYMLINK already exists. Skipping linking."
elif [ -d "$JDK_SYMLINK" ]; then
    echo "Directory $JDK_SYMLINK already exists but is not a symlink. Please check manually."
else
    echo "Creating symlink for OpenJDK 21..."
    sudo ln -sfn "$JDK_TARGET" "$JDK_SYMLINK"
    echo "Symlink created: $JDK_SYMLINK -> $JDK_TARGET"
fi

# Add JAVA_HOME if not present
if ! grep -q "java_home -v 21" "$ZSHRC"; then
    echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 21)' >> "$ZSHRC"
    echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> "$ZSHRC"
fi

# Install Maven
echo "Installing Maven..."
brew install maven

# Verify installations
echo "Java installed successfully:"
java -version
echo "JAVA_HOME = $JAVA_HOME"

echo "Maven installed successfully:"
mvn -v

echo
echo " Java + Maven installation completed!"
echo " Restart your terminal to apply all changes."
