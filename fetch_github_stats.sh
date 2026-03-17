#!/bin/bash

# Script to fetch GitHub stats locally
# This will be run automatically by GitHub Actions, but you can also run it manually

echo "Fetching GitHub stats..."

# Create _data directory if it doesn't exist
mkdir -p _data

# Start writing the YAML file
echo "# Auto-generated GitHub stats" > _data/github_stats.yml
echo "# Last updated: $(date -u +"%Y-%m-%d %H:%M:%S UTC")" >> _data/github_stats.yml
echo "" >> _data/github_stats.yml

# Array of repositories
repos=(
  "Helix-Research-Lab/PIGLET"
  "Helix-Research-Lab/HOTPocket"
  "kristycarp/gpt3-lexicon"
  "kristycarp/TAYMACS"
)

for repo in "${repos[@]}"; do
  echo "Fetching stats for $repo..."

  # Fetch repo data from GitHub API
  response=$(curl -s -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/repos/$repo")

  # Extract stars and forks
  stars=$(echo "$response" | grep -o '"stargazers_count": [0-9]*' | grep -o '[0-9]*')
  forks=$(echo "$response" | grep -o '"forks_count": [0-9]*' | grep -o '[0-9]*')

  # Sanitize repo name for YAML key (replace / and -)
  repo_key=$(echo "$repo" | sed 's/\//_/g' | sed 's/-/_/g')

  # Write to YAML file
  echo "$repo_key:" >> _data/github_stats.yml
  echo "  stars: $stars" >> _data/github_stats.yml
  echo "  forks: $forks" >> _data/github_stats.yml
  echo "" >> _data/github_stats.yml
done

echo "Done! Stats written to _data/github_stats.yml"
cat _data/github_stats.yml
