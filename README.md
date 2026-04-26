# https-am-i-mullvad

Using https-am-i-mullvad, you can check if your connection is using Mullvad VPN or not without having to install their cli. It is a simple command-line tool that checks your IP address against mullvads <https://am.i.mullvad.net/> service.

> NOTE: Be nice to their service and don't set the interval too low, 60 seconds is a good starting point. (◕‿◕✿)

## Commands

| Command     | Description                                                                   |
| ----------- | ----------------------------------------------------------------------------- |
| \* / waybar | Checks if the connection is using Mullvad VPN and returns the status as JSON. |
| copy        | Copies the current IP address to the clipboard.                               |
| json        | Returns the full JSON response from the Mullvad service.                      |
| status      | Returns only the status of the connection (connected, disconnected).          |

## Getting https-am-i-mullvad to work with waybar

**1. Clone the repo**

```sh
git clone git@github.com:dottmp/https-am-i-mullvad.git
```

**2. Add the module to your waybar config**

Paste the module into your `~/.config/waybar/config.jsonc`

```jsonc
  "modules-center": ["custom/https-am-i-mullvad"],

  "custom/https-am-i-mullvad": {
    "format": "m",
    "exec": "~/path/to/your/script/https-am-i-mullvad/https-am-i-mullvad.sh",
    "interval": 60,
    "return-type": "json",
    "on-click-right": "~/path/to/your/script/https-am-i-mullvad/https-am-i-mullvad.sh copy", #right click for copy ip
    "on-click": "~/path/to/your/script/https-am-i-mullvad/https-am-i-mullvad.sh", #click for refresh
  },
```

**3. Add some sweet sweet css to your custom module**

```css
/* waybar/styles.css probably?*/

@define-color error #F96184;
@define-color foreground #D3D9FF;
@define-color success #01D38F;

#custom-https-am-i-mullvad {
  min-width: 14px;
  margin: 0 7.5px;
}

#custom-https-am-i-mullvad.connecting {
  color: @foreground;
}
#custom-https-am-i-mullvad.connected {
  color: @success;
}
#custom-https-am-i-mullvad.disconnected {
  font-size: 16px;
  margin: 0 7.5px 0 4.5px;
  color: @error;
}
```

**4. Restart waybar**

```sh
killall waybar && waybar &
```

finish

## Contributing

Contributions are welcome! Please submit pull requests or open issues for any suggestions, bug reports, or improvements.
