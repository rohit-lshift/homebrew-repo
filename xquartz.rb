cask 'xquartz' do
  version '2.7.10'
  sha256 'd5cd043ed0e22f6da81cb1f36241d812ecef34ce80f92c928626284c7f93b0ac'

  # bintray.com/xquartz was verified as official when first introduced to the cask
  url "https://dl.bintray.com/xquartz/downloads/XQuartz-#{version}.dmg"
  appcast 'https://www.xquartz.org/releases/sparkle/release.xml'
  name 'XQuartz'
  homepage 'https://www.xquartz.org/'

  auto_updates true

  pkg 'XQuartz.pkg'

  postflight do
    Pathname.new(File.expand_path('~')).join('Library', 'Logs').mkpath

    # Set default path to X11 to avoid the need of manual setup
    system_command '/usr/bin/defaults', args: ['write', 'com.apple.applescript', 'ApplicationMap', '-dict-add', 'X11', 'file://localhost/Applications/Utilities/XQuartz.app/']

    # Load & start XServer to avoid the need of relogin
    system_command '/bin/launchctl', args: ['load', '/Library/LaunchAgents/org.macosforge.xquartz.startx.plist']
  end

  uninstall quit:      'org.macosforge.xquartz.X11',
            launchctl: [
                         'org.macosforge.xquartz.startx',
                         'org.macosforge.xquartz.privileged_startx',
                       ],
            pkgutil:   'org.macosforge.xquartz.pkg',
            delete:    [
                         '/opt/X11',
                         '/private/etc/manpaths.d/40-XQuartz',
                         '/private/etc/paths.d/40-XQuartz',
                       ]

  zap trash: [
               '~/.Xauthority',
               '~/Library/Application Support/XQuartz',
               '~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.macosforge.xquartz.x11.sfl*',
               '~/Library/Caches/org.macosforge.xquartz.X11',
               '~/Library/Cookies/org.macosforge.xquartz.X11.binarycookies',
               '~/Library/Logs/X11/org.macosforge.xquartz.log',
               '~/Library/Logs/X11/org.macosforge.xquartz.log.old',
               '~/Library/Preferences/org.macosforge.xquartz.X11.plist',
               '~/Library/Saved Application State/org.macosforge.xquartz.X11.savedState',
             ],
      rmdir: [
               '~/.fonts',
               '~/Library/Logs/X11',
             ]
end
