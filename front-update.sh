cd /home/tech-support-frontend/
git fetch --all
git reset --hard origin/serg/acheivements
git log --oneline -1
rm -rf ./dist
npm run dist
rm -f /data/techSupport/*
\cp -r ./dist/. /data/techSupport
echo "Frontend updated successfully"
