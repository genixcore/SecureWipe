// index.js (Main Process)

const { app, BrowserWindow } = require('electron');
const path = require('path');

function createWindow () {
  const mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    minWidth: 600, 
    minHeight: 400, 
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false // Simplifies communication for this example
      // In a real-world app, you should use contextIsolation: true with a preload script
    }
  });

  // Load the initial splash screen
  mainWindow.loadFile('splash.html');

  // Optional: Open DevTools automatically (uncomment for debugging)
  // mainWindow.webContents.openDevTools();
}

// Electron is ready to create browser windows
app.whenReady().then(createWindow);

// Quit the app when all windows are closed (except on macOS)
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// Re-open a window if the app is activated on macOS
app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});