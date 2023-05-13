cd /home/tech-support-backend/
git fetch --all
git reset --hard origin/master
git log --oneline -1
\cp -rf /home/override_config.json /home/tech-support-backed/configs/config.json
\cp -rf /home/override_autoAchievementsConfig.json /home/tech-support-backend/configs/autoAchievementsConfig.json
systemctl daemon-reload
systemctl restart gunicorn_site
echo "Backend updated successfully"
