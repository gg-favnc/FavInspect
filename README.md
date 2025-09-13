# FavInspect - Windows System Diagnostic Tool

FavInspect is a comprehensive Windows batch script that collects detailed system information for diagnostics, troubleshooting, and inventory purposes. Originally created in 2011 style, now enhanced with modern features.

## 📋 Collected Information

- **System Information**: OS version, build, architecture, and hardware details
- **Processor**: CPU name, core count, logical processors, clock speed
- **Memory**: RAM modules, capacity, speed, manufacturer
- **Storage**: Physical disks and logical volumes with file systems
- **Network**: Adapters, IP configuration, Wi-Fi interfaces
- **Graphics**: Video controllers, resolution, refresh rates
- **BIOS**: Manufacturer, version, serial numbers
- **Services**: All services with status and startup types
- **Additional**: Timezone, monitor information, system product details

## 🚀 Features

- **Multiple Output Formats**: TXT, JSON, and Markdown reports
- **Admin Detection**: Notifies when running without elevated privileges
- **Interactive Menu**: Easy navigation between report options
- **Discord Webhook Support**: Upload reports directly to Discord
- **Persistent Settings**: Remembers webhook URLs for future use
- **Clean Organization**: All files saved in organized Temp folder

## 📁 Output Files

All reports are saved to `Temp/` folder with naming pattern: `[COMPUTERNAME]_report.[format]`

- `*.txt` - Comprehensive human-readable text report
- `*.json` - Structured JSON data for programmatic use
- `*.md` - Markdown formatted version for documentation

## 🔧 Usage

1. **Download** the `FavInspect.bat` file
2. **Run** the script (right-click → Run as Administrator for best results)
3. **Follow** the interactive menu to:
   - View reports in different formats
   - Upload to Discord webhook
   - Open the output folder
   - Exit the application

## 🌐 Discord Webhook Integration

To use the webhook feature:

1. Create a webhook in your Discord channel settings
2. Either:
   - Enter the URL when prompted during first use
   - Create a `webhook.url` file in the script directory containing your URL
3. Select option 4 from the menu to upload your report

## ⚙️ Requirements

- Windows 7 or newer
- PowerShell (included with Windows)
- Internet connection (for webhook feature only)

## 🔒 Privacy & Security

- All data is collected locally only
- No information is sent anywhere without your explicit permission
- Webhook URLs are stored locally in `webhook.url` file
- Review reports before sharing as they contain system identifiers

## 📝 License

This project is licensed under the terms found at [https://gg-favnc.github.io/P/license](https://gg-favnc.github.io/P/license)

## 🆕 Version History

- **v2.1** - Enhanced menu system, webhook support, improved formatting
- **Original** - Basic system information collection functionality

## 🆘 Support

For issues or questions, please check that:
- You're running Windows 7 or newer
- PowerShell execution is not restricted on your system
- You have write permissions in the script directory

---

*FavInspect - Because knowing your system is the first step to fixing it.*
