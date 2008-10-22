#! /usr/bin/perl -w

use warnings;
use strict;


if(`uname -a` =~ m/Darwin/) {
	if(`which py2applet` ne "") {
		print "Creating Gitso.app ";
		`rm -f setup.py`;
		`rm -rf dist`;
		
		print "..";
		`py2applet --make-setup Gitso.py`;
		
		print "..";
		`python setup.py py2app`;
		
		print "..";
		`cp arch/osx/Info.plist dist/Gitso.app/Contents/`;
		`cp copyright dist/Gitso.app/Contents/Resources/`;
		`cp PythonApplet.icns dist/Gitso.app/Contents/Resources/`;
		
		`tar xvfz arch/osx/OSXvnc.tar.gz`;
		`mv OSXvnc dist/Gitso.app/Contents/Resources/`;

		`tar xvfz arch/osx/vncviewer.tar.gz`;
		`mv vncviewer dist/Gitso.app/Contents/Resources/`;
		print " [done]\n";
		
		print "Creating Gitso.dmg ";
		`rm -f Gitso.dmg`;
		
		`mkdir dist/Gitso`;
		`cp arch/osx/dmg_DS_Store dist/Gitso/.DS_Store`;
		`ln -s /Applications/ dist/Gitso/Applications`;
		
		`mv "dist/Gitso.app" "dist/Gitso/"`;
		`cp -r arch/osx/Readme.rtfd dist/Gitso/Readme.rtfd`;
		
		print "...";
		`hdiutil create -srcfolder dist/Gitso/ Gitso.dmg`;
		print "... [done]\n";
	} else {
		print "Error, you need py2applet to be installed.";
	}
	
} elsif (`uname -a` =~ m/Linux/) {
	my $deb  = "gitso_0.5_all.deb";
	my $path = "gitso";
	print "Creating $path.deb";
	`rm -rf $path`;
	`mkdir $path`;
	`mkdir $path/DEBIAN`;
	`cp arch/linux/control $path/DEBIAN`;

	print "..";
	`mkdir $path/usr`;
	`mkdir $path/usr/bin`;
	`mkdir $path/usr/share`;
	`mkdir $path/usr/share/applications`;
	`mkdir $path/usr/share/doc`;
	`mkdir $path/usr/share/doc/$path`;
	`mkdir $path/usr/share/$path`;
	`cp arch/linux/gitso $path/usr/bin/`;
	`chmod 755 $path/usr/bin/gitso`;
	`cp Gitso.py $path/usr/share/$path/`;
	`cp __init__.py $path/usr/share/$path/`;
	`cp hosts.txt $path/usr/share/$path/`;
	`cp icon.ico $path/usr/share/$path/`;

	print "..";
	`cp arch/linux/gitso.desktop $path/usr/share/applications/`;
	`cp arch/linux/README.txt $path/usr/share/doc/$path/README`;
	`cp copyright $path/usr/share/doc/$path/`;
	`gzip -cf arch/linux/changelog > $path/usr/share/doc/$path/changelog.gz`;

	print "..";
	`dpkg -b $path/ $deb`;

	#`rm -rf $path`;

	print " [done]\n";
}
