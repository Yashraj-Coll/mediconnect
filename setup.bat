@echo off
echo ========================================
echo   MediConnect Setup - Windows
echo ========================================
echo.

echo [1/5] Checking prerequisites...
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java not found. Please install Java 17+
    pause
    exit /b 1
)

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js not found. Please install Node.js 16+
    pause
    exit /b 1
)

where mysql >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: MySQL command not found in PATH
    echo Please ensure MySQL is installed and running
    pause
)

echo All prerequisites found!
echo.

echo [2/5] Cloning repositories...
if not exist "mediconnect-backend" (
    git clone https://github.com/Yashraj-Coll/mediconnect-backend
) else (
    echo Backend already cloned, skipping...
)

if not exist "mediconnect-frontend" (
    git clone https://github.com/Yashraj-Coll/mediconnect-frontend
) else (
    echo Frontend already cloned, skipping...
)
echo.

echo [3/5] Setting up Backend...
cd mediconnect-backend
if not exist ".env" (
    copy .env.example .env
    echo.
    echo IMPORTANT: Please edit mediconnect-backend\.env with your database credentials
    echo Press any key after editing .env file...
    pause >nul
)

echo Building backend (this may take a few minutes)...
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo ERROR: Backend build failed
    pause
    exit /b 1
)
cd ..
echo.

echo [4/5] Setting up Frontend...
cd mediconnect-frontend
if not exist ".env" (
    copy .env.example .env
)

echo Installing frontend dependencies...
call npm install
if %errorlevel% neq 0 (
    echo ERROR: Frontend dependencies installation failed
    pause
    exit /b 1
)
cd ..
echo.

echo [5/5] Setup Complete!
echo.
echo ========================================
echo   Next Steps:
echo ========================================
echo.
echo 1. Create MySQL database:
echo    mysql -u root -p
echo    CREATE DATABASE mediconnect;
echo    exit;
echo.
echo 2. Start Backend (in new terminal):
echo    cd mediconnect-backend
echo    mvn spring-boot:run
echo.
echo 3. Start Frontend (in another terminal):
echo    cd mediconnect-frontend
echo    npm run dev
echo.
echo 4. Access application:
echo    Frontend: http://localhost:5173
echo    Backend:  http://localhost:8080
echo    Swagger:  http://localhost:8080/swagger-ui.html
echo.
echo ========================================
pause