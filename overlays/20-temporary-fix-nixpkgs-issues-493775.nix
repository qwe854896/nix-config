final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyFinal: pyPrev: {
      # TODO: remove once https://github.com/NixOS/nixpkgs/issues/493775 is fixed
      # (jeepney skips D-Bus installCheck on darwin; opened 2026-02-24)
      jeepney = pyPrev.jeepney.overrideAttrs (_: {
        doInstallCheck = false; # dbus-run-session unavailable on darwin
        # jeepney.io.trio needs outcome (trio dep), but trio support is optional
        pythonImportsCheck = [
          "jeepney"
          "jeepney.auth"
          "jeepney.io"
          "jeepney.io.asyncio"
          "jeepney.io.blocking"
          "jeepney.io.threading"
        ];
      });
    })
  ];
}
