param([switch]$EnableFonts)

$ErrorActionPreference = 'Stop'
$AppName = '가정간호노트'
$utf8 = New-Object System.Text.UTF8Encoding($false)

function Say($m, $c = 'Gray') { Write-Host $m -ForegroundColor $c }

$manifest = 'android\app\src\main\AndroidManifest.xml'
if (Test-Path $manifest) {
    $x = Get-Content $manifest -Raw -Encoding UTF8
    $x = $x -replace 'android:label="[^"]*"', "android:label=`"$AppName`""
    [IO.File]::WriteAllText((Resolve-Path $manifest), $x, $utf8)
    Say "OK    android:label = $AppName" Green
} else {
    Say "SKIP  $manifest 없음 — flutter create 를 먼저 실행" Yellow
}

$plist = 'ios\Runner\Info.plist'
if (Test-Path $plist) {
    $x = Get-Content $plist -Raw -Encoding UTF8
    if ($x -match '<key>CFBundleDisplayName</key>') {
        $x = $x -replace '(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)', "`${1}$AppName`${2}"
    } else {
        $x = $x -replace '(<key>CFBundleName</key>)',
            "<key>CFBundleDisplayName</key>`r`n`t<string>$AppName</string>`r`n`t`$1"
    }
    [IO.File]::WriteAllText((Resolve-Path $plist), $x, $utf8)
    Say "OK    CFBundleDisplayName = $AppName" Green
} else {
    Say "SKIP  $plist 없음" Yellow
}

$need = @(
    @{ f = 'Pretendard-Regular.otf';    w = 400 },
    @{ f = 'Pretendard-Medium.otf';     w = 500 },
    @{ f = 'Pretendard-SemiBold.otf';   w = 600 },
    @{ f = 'Pretendard-Bold.otf';       w = 700 },
    @{ f = 'Pretendard-ExtraBold.otf';  w = 800 }
)
New-Item -ItemType Directory -Path 'fonts' -Force | Out-Null
$missing = $need | Where-Object { -not (Test-Path "fonts\$($_.f)") }

if ($missing.Count -gt 0) {
    Say ""
    Say "폰트 없음 ($($missing.Count)/5)" Yellow
    $missing | ForEach-Object { Say "      fonts\$($_.f)" DarkGray }
    Say "      https://github.com/orioncactus/pretendard/releases   OFL 1.1" DarkGray
    Say "      없어도 실행은 된다. 시스템 폰트로 뜨고 자간이 달라 보인다." DarkGray
} else {
    Say "OK    폰트 5종 확인" Green
}

$p = Get-Content 'pubspec.yaml' -Raw -Encoding UTF8
$hasFonts = $p -match '(?m)^  fonts:'

if ($EnableFonts) {
    if ($missing.Count -gt 0) {
        Say ""
        Say "중단  폰트가 없어 활성화하지 않는다. 넣고 다시 실행." Red
        exit 1
    }
    if ($hasFonts) {
        Say "OK    pubspec 폰트 블록 이미 있음" Green
    } else {
        $block = "`r`n  fonts:`r`n    - family: Pretendard`r`n      fonts:`r`n"
        foreach ($n in $need) {
            $block += "        - asset: fonts/$($n.f)`r`n          weight: $($n.w)`r`n"
        }
        [IO.File]::WriteAllText((Resolve-Path 'pubspec.yaml'), $p.TrimEnd() + $block, $utf8)
        Say "OK    pubspec 폰트 블록 추가" Green
    }
} elseif ($hasFonts -and $missing.Count -gt 0) {
    Say ""
    Say "경고  pubspec 에 폰트 블록이 있는데 파일이 없다. flutter run 이 멈춘다." Red
}

Say ""
Say "다음" Cyan
Say "      flutter pub get"
Say "      dart analyze"
Say "      flutter run"
