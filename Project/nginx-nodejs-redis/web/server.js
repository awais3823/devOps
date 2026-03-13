const os = require('os');
const express = require('express');
const path = require('path');
const app = express();
const redis = require('redis');

// Redis configuration
const REDIS_HOST = process.env.REDIS_HOST || 'redis';
const REDIS_PORT = process.env.REDIS_PORT || 6379;

const redisClient = redis.createClient({
  host: REDIS_HOST,
  port: REDIS_PORT,
  retry_strategy: (options) => {
    if (options.error && options.error.code === 'ECONNREFUSED') {
      return new Error('The server refused the connection');
    }
    if (options.total_retry_time > 1000 * 60 * 60) {
      return new Error('Retry time exhausted');
    }
    if (options.attempt > 10) {
      return undefined;
    }
    return Math.min(options.attempt * 100, 3000);
  }
});

// Handle Redis connection events
redisClient.on('connect', () => {
  console.log('Connected to Redis');
});

redisClient.on('ready', () => {
  console.log('Redis client ready');
});

redisClient.on('error', (err) => {
  console.error('Redis Client Error:', err);
});

redisClient.on('end', () => {
  console.log('Redis connection ended');
});

// Middleware
app.use(express.json());
app.use(express.static('public'));

// API Routes
app.get('/api/visits', function(req, res) {
    redisClient.get('numVisits', function(err, numVisits) {
        if (err) {
            console.error('Redis error:', err);
            return res.status(500).json({ 
                error: 'Database error',
                hostname: os.hostname(),
                message: err.message
            });
        }
        
        let numVisitsToDisplay = parseInt(numVisits) + 1;
        if (isNaN(numVisitsToDisplay)) {
            numVisitsToDisplay = 1;
        }
        
        const response = {
            hostname: os.hostname(),
            visits: numVisitsToDisplay,
            timestamp: new Date().toISOString()
        };
        
        // Update Redis
        redisClient.set('numVisits', numVisitsToDisplay, function(setErr) {
            if (setErr) {
                console.error('Error updating visits:', setErr);
            }
        });
        
        res.json(response);
    });
});

app.get('/api/health', function(req, res) {
    res.json({
        status: 'healthy',
        hostname: os.hostname(),
        service: 'backend-api'
    });
});

// Root route - serve frontend
app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, function() {
    console.log(`Web application is listening on port ${PORT}`);
    console.log(`Hostname: ${os.hostname()}`);
});
