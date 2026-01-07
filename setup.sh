#!/bin/bash

echo "========================================"
echo "   MediConnect Setup - Linux/Mac"
echo "========================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "[1/5] Checking prerequisites..."

# Check Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}ERROR: Java not found. Please install Java 17+${NC}"
    exit 1
fi

# Check Node
if ! command -v node &> /dev/null; then
    echo -e "${RED}ERROR: Node.js not found. Please install Node.js 16+${NC}"
    exit 1
fi

# Check MySQL
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}WARNING: MySQL command not found in PATH${NC}"
    echo "Please ensure MySQL is installed and running"
fi

echo -e "${GREEN}All prerequisites found!${NC}"
echo ""

echo "[2/5] Cloning repositories..."
if [ ! -d "mediconnect-backend" ]; then
    git clone https://github.com/Yashraj-Coll/mediconnect-backend
else
    echo "Backend already cloned, skipping..."
fi

if [ ! -d "mediconnect-frontend" ]; then
    git clone https://github.com/Yashraj-Coll/mediconnect-frontend
else
    echo "Frontend already cloned, skipping..."
fi
echo ""

echo "[3/5] Setting up Backend..."
cd mediconnect-backend
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo ""
    echo -e "${YELLOW}IMPORTANT: Please edit mediconnect-backend/.env with your database credentials${NC}"
    read -p "Press Enter after editing .env file..."
fi

echo "Building backend (this may take a few minutes)..."
mvn clean install -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Backend build failed${NC}"
    exit 1
fi
cd ..
echo ""

echo "[4/5] Setting up Frontend..."
cd mediconnect-frontend
if [ ! -f ".env" ]; then
    cp .env.example .env
fi

echo "Installing frontend dependencies..."
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Frontend dependencies installation failed${NC}"
    exit 1
fi
cd ..
echo ""

echo -e "${GREEN}[5/5] Setup Complete!${NC}"
echo ""
echo "========================================"
echo "   Next Steps:"
echo "========================================"
echo ""
echo "1. Create MySQL database:"
echo "   mysql -u root -p"
echo "   CREATE DATABASE mediconnect;"
echo "   exit;"
echo ""
echo "2. Start Backend (in new terminal):"
echo "   cd mediconnect-backend"
echo "   mvn spring-boot:run"
echo ""
echo "3. Start Frontend (in another terminal):"
echo "   cd mediconnect-frontend"
echo "   npm run dev"
echo ""
echo "4. Access application:"
echo "   Frontend: http://localhost:5173"
echo "   Backend:  http://localhost:8080"
echo "   Swagger:  http://localhost:8080/swagger-ui.html"
echo ""
echo "========================================"