{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsNoGuiHook,
  gobject-introspection,
  innoextract,
  systemd,
}:

python3Packages.buildPythonPackage rec {
  pname = "python-validity";
  version = "0.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "uunicorn";
    repo = "python-validity";
    rev = version;
    hash = "sha256-6NbxeokbGW5yP3g9Q/W3k0JiU6g+qyeZfKfw0nBJ37o=";
  };

  patches = [
    ./dbus-service.patch
    ./sensor.py.patch
    ./python-validity-dbus-service.patch
    ./setup.py.patch
    ./validity-sensors-firmware.patch
    ./upload_fwext.py.patch
  ];

  postPatch = ''
    cp ${./tmpdir.py} validitysensor/tmpdir.py

    substituteInPlace bin/validity-sensors-firmware \
      --replace-fail "'innoextract'" "'${lib.getExe innoextract}'"

    substituteInPlace debian/python3-validity.service \
      --replace-fail "ExecStart=/usr/lib/python-validity/dbus-service" \
      "ExecStart=$out/bin/python-validity-dbus-service" \
      --replace-fail " --debug" ""
  '';

  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  propagatedBuildInputs = with python3Packages; [
    cryptography
    pyusb
    pyyaml
    dbus-python
    pygobject3
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postInstall = ''
    install -D -m 644 debian/python3-validity.service \
      $out/lib/systemd/system/python3-validity.service

    install -D -m 644 debian/python3-validity.udev \
      $out/lib/udev/rules.d/60-python-validity.rules

    substituteInPlace $out/lib/udev/rules.d/60-python-validity.rules \
      --replace-fail "/bin/systemctl" "${lib.getExe' systemd "systemctl"}"

    install -Dm644 LICENSE $out/share/licenses/${pname}/LICENSE
  '';

  meta = {
    description = "Validity fingerprint sensor driver";
    homepage = "https://github.com/uunicorn/python-validity";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
