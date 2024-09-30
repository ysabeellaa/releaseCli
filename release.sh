if [ -z "$1" ]; then
  echo "Uso: ./release.sh [patch|minor|major]"
  exit 1
fi

npm version $1

echo "## [$(node -p "require('./package.json').version")] - $(date +%Y-%m-%d)" >> CHANGELOG.md
echo "" >> CHANGELOG.md

git log $(git describe --tags --abbrev=0)..HEAD --oneline >> CHANGELOG.md
echo "" >> CHANGELOG.md

git add package.json CHANGELOG.md
git commit -m "chore: release version $(node -p "require('./package.json').version")"

git tag v$(node -p "require('./package.json').version")

git push origin main
git push origin v$(node -p "require('./package.json').version")

gh release create v$(node -p "require('./package.json').version") CHANGELOG.md --title "Release v$(node -p "require('./package.json').version")" --notes "Notas da versão aqui."
