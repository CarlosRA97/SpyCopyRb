#!/usr/bin/env ruby

require 'fileutils'

class Host_os
	def initialize
	end
	def windows?
		(/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RbConfig::CONFIG["host_os"]) !=nil
	end
	def mac?
		(/darwin/ =~ RbConfig::CONFIG["host_os"]) != nil
	end
	def linux?
		!windows? and !mac?
	end
end

class Action < Directories	
	def initialize
	end
	
	def searchfCopy(src,dest)
		for dir in arraySrc
			if dir == ''
				src << '/' << dir
				for dir1 in @Directories.arrayDir(@Directories.defaultDir)
					if dir1 == ''
						src << '/' << dir1
						check_copy src,dir1,dest
					end
				end
			end
		end
	end
	
	def checkCopy(src,dir1,dest)
		# f es una array de los archivos contenidos en el destino
		f = Dir.entries(dest).select {|entry| File.directory? File.join(dest,entry) and !(entry =='.' || entry == '..') }	
	
		for folder in f
			if File.exist? dir1 and folder == dir1
				break
			else
				next
			end
		end
		FileUtils.copy_entry src,dest
	end
	
	def logFile (s,n,option)
		File.open(n, option) do |f|
			f.puts s
		end
	end
	
end

class Directories < Host_os
	def initialize
	end
	
	def arrayDir(p)
		return Dir.entries(p).select do |entry| File.directory? File.join(p,entry) and !(entry =='.' || entry == '..') end
	end
	def defaultDir(w,m,l)
      	src = 'G:' if windows?
      	dest = Dir.home() if windows?

		src = '/Volumes' if mac?
      	dest = Dir.home() if mac?

		src = '/media' if linux?
		dest = Dir.home() if linux?
	end
	def subDir(src)
		Dir.glob(File.join(src,"**")) 
	end
end



#action.search src,dest

#log_file subDir, 'a+'
