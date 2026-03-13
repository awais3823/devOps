#!/bin/bash
# Test ingress connectivity

NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
NODE_PORT=30303

echo "Testing ingress..."
echo "Node IP: $NODE_IP"
echo "Node Port: $NODE_PORT"
echo ""

echo "1. Testing /api/health:"
curl -s -H "Host: nginx-nodejs-redis.local" "http://${NODE_IP}:${NODE_PORT}/api/health"
echo ""
echo ""

echo "2. Testing /api/visits:"
curl -s -H "Host: nginx-nodejs-redis.local" "http://${NODE_IP}:${NODE_PORT}/api/visits"
echo ""
echo ""

echo "3. Testing / (frontend):"
curl -s -H "Host: nginx-nodejs-redis.local" "http://${NODE_IP}:${NODE_PORT}/" | head -20



