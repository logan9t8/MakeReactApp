# Libraries
$libManifest = @(
    @{
        name = "react.development.js"
        url  = "https://cdnjs.cloudflare.com/ajax/libs/react/18.3.1/umd/react.development.js"
    },
    @{
        name = "react-dom.development.js"
        url  = "https://cdnjs.cloudflare.com/ajax/libs/react-dom/18.3.1/umd/react-dom.development.js"
    },
    @{
        name = "babel.js"
        url  = "https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/7.25.6/babel.js"
    }
)

# Check if app name is passed, if not, ask for it
if ($args.Length -eq 0) {
    $name = Read-Host -Prompt 'Enter name of the app '
}
else {
    $name = $args[0]
}

# App files
$manifest = @(
    @{
        htmlFile = @"
<!DOCTYPE html>
<html>

<head>
    <script src="./scripts/react.development.js"></script>
    <script src="./scripts/react-dom.development.js"></script>
    <script src="./scripts/babel.js"></script>
    <script src="./scripts/index.js" type="text/babel"></script>
    <link rel="stylesheet" href="./styles/{0}.css">
</head>

<body>
    <div id="root"></div>
</body>
</html>
"@ -f $name
    },
    @{
        jsFile = @"
const { useState } = React;

function App() {
    return (
        <div className="App">
            <title></title>
        </div>
    );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
"@
    },
    @{
        cssFile = @"
"@
    }
)

# Create directory and files
foreach ($item in @($name, "$name\scripts", "$name\styles")) {
    New-Item -Path $item -ItemType directory 2>&1 | Out-Null
}
foreach ($item in @(("$name\index.html", $manifest.htmlFile), ("$name\scripts\index.js", $manifest.jsFile), ("$name\styles\index.css", $manifest.cssFile))) {
    New-Item -Path $item[0] -ItemType file -Value $item[1] 2>&1 | Out-Null
}

# Download libraries if not present, copy to app directory
foreach ($item in $libManifest) {
    if (-not (Test-Path "$PSScriptRoot\$($item.name)")) {
        Invoke-WebRequest -Uri $item.url -OutFile "$PSScriptRoot\$($item.name)"
    }
    Copy-Item -Path "$PSScriptRoot\$($item.name)" -Destination "$name\scripts\$($item.name)" 2>&1 | Out-Null
}