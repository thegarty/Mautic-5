# Mautic 5 Railway Deployment

This repository contains the configuration files needed to deploy Mautic 5 on Railway with all three service containers (web, worker, and cron) plus a MySQL database.

## Prerequisites

- A Railway account
- Railway CLI (optional, for local development)
- Docker (for local development)

## Deployment Steps

1. **Create a new Railway project**
   - Go to [Railway Dashboard](https://railway.app/dashboard)
   - Click "New Project"
   - Select "Deploy from GitHub repo"

2. **Set up the database**
   - Add a MySQL plugin to your project
   - Note down the database credentials provided by Railway

3. **Configure Environment Variables**
   In Railway's dashboard, set the following environment variables:
   ```
   MYSQL_HOST=<your-railway-mysql-host>
   MYSQL_PORT=3306
   MYSQL_DATABASE=mautic
   MYSQL_USER=<your-railway-mysql-user>
   MYSQL_PASSWORD=<your-railway-mysql-password>
   
   DOCKER_MAUTIC_ROLE=mautic_web  # For web service
   DOCKER_MAUTIC_RUN_MIGRATIONS=true
   
   # PHP Settings
   PHP_INI_VALUE_DATE_TIMEZONE=UTC
   PHP_INI_VALUE_MEMORY_LIMIT=512M
   PHP_INI_VALUE_UPLOAD_MAX_FILESIZE=512M
   PHP_INI_VALUE_POST_MAX_FILESIZE=512M
   PHP_INI_VALUE_MAX_EXECUTION_TIME=300
   ```

4. **Deploy the Services**
   - Railway will automatically detect the Dockerfile and build the image
   - Create three services in Railway, one for each Mautic role:
     - Web service: Set `DOCKER_MAUTIC_ROLE=mautic_web`
     - Worker service: Set `DOCKER_MAUTIC_ROLE=mautic_worker`
     - Cron service: Set `DOCKER_MAUTIC_ROLE=mautic_cron`

5. **Configure Persistent Storage**
   - In Railway, set up persistent storage for:
     - `/var/www/html/app/config`
     - `/var/www/html/media`
     - `/var/www/html/var/logs`

## Local Development

1. Copy `.env.example` to `.env` and fill in your values
2. Run `docker-compose up` to start all services locally
3. Access Mautic at `http://localhost:8080`

## Important Notes

- Make sure to set strong passwords for your database
- Keep your environment variables secure
- Monitor your Railway usage to stay within free tier limits
- Consider setting up a custom domain in Railway for production use

## Troubleshooting

1. If the web service fails to start:
   - Check database connection settings
   - Verify all required environment variables are set
   - Check logs in Railway dashboard

2. If workers aren't processing:
   - Verify worker service is running
   - Check worker logs in Railway dashboard
   - Ensure database connection is working

3. If cron jobs aren't running:
   - Verify cron service is running
   - Check cron logs in Railway dashboard
   - Ensure database connection is working

## Support

For issues with this deployment:
- Check [Mautic Docker documentation](https://github.com/mautic/docker-mautic)
- Visit [Railway documentation](https://docs.railway.app/)
- Join [Mautic community forums](https://forum.mautic.org/) 