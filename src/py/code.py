#!/usr/bin/python
import os

testname = "dummy"

for i in range (1, 3) :
   os.system("mkdir -p /home/vivek/git_clones/fpga/regression/" + testname +  "_%d"%i )
   print("mkdir  /home/vivek/git_clones/fpga/regression/" + testname +  "_%d"%i )
   os.system("cp log /home/vivek/git_clones/fpga/regression/" + testname +  "_%d"%i + "/" + testname +  "_%d"%i + ".log")
   print("cp log /home/vivek/git_clones/fpga/regression/" + testname +  "_%d"%i + "/" + testname +  "_%d"%i + ".log")
