// API endpoint
const API_URL = '/api/visits';

// Update visits from API
async function updateVisits() {
    const visitCountEl = document.getElementById('visitCount');
    const serverNameEl = document.getElementById('serverName');
    const lastUpdateEl = document.getElementById('lastUpdate');
    const refreshBtn = document.querySelector('.btn-refresh');
    
    // Show loading state
    refreshBtn.classList.add('loading');
    refreshBtn.textContent = '⏳ Loading...';
    
    try {
        const response = await fetch(API_URL);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        
        // Update UI
        visitCountEl.textContent = data.visits;
        serverNameEl.textContent = data.hostname;
        lastUpdateEl.textContent = new Date(data.timestamp).toLocaleString();
        
        // Animate number change
        visitCountEl.style.animation = 'none';
        setTimeout(() => {
            visitCountEl.style.animation = 'pulse 0.5s ease-out';
        }, 10);
        
    } catch (error) {
        console.error('Error fetching visits:', error);
        visitCountEl.textContent = 'Error';
        serverNameEl.textContent = 'Unable to connect';
        lastUpdateEl.textContent = 'N/A';
        
        // Show error message
        alert('Failed to fetch visit count. Please check if the backend services are running.');
    } finally {
        // Reset button state
        refreshBtn.classList.remove('loading');
        refreshBtn.textContent = '🔄 Refresh';
    }
}

// Auto-update every 5 seconds
let autoUpdateInterval;

function startAutoUpdate() {
    updateVisits(); // Initial load
    autoUpdateInterval = setInterval(updateVisits, 5000);
}

function stopAutoUpdate() {
    if (autoUpdateInterval) {
        clearInterval(autoUpdateInterval);
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    startAutoUpdate();
    
    // Stop auto-update when page is hidden, resume when visible
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            stopAutoUpdate();
        } else {
            startAutoUpdate();
        }
    });
});





