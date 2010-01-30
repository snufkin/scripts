#!/opt/local/bin/python
"""Drupal site veryfier for Python

Script to test if a given site is Drupal or not. We are exploting the fact that all drupal sites have Dries' birthday as expires header.

Usage: ptyhon isdrupal.py [options] [source]

Options:
  -f ..., --file=...  use the specified file containing a list of URLs
  -h, --help          show this help
"""

import httplib
import sys, getopt

def main(argv): 
  try:
    opts, args = getopt.getopt(argv, "hf:", ["help", "file="])
  except getopt.GetoptError:
    usage()
    sys.exit(2)
  for opt, arg in opts:
    if opt in ("-h", "--help"):
      usage()
      sys.exit()
    elif opt in ("-f", "--file"):
      sites = arg
  
  f = open(sites, 'r')
  for line in f:
    # Removing spaces
    target = line.strip()
    if 0 != len(target):
      conn = httplib.HTTPConnection(target)
      conn.request("GET", "/index.php")
      resp = conn.getresponse()
      header = resp.getheader('expires')
      conn.close
      if ('Sun, 19 Nov 1978 05:00:00 GMT' == header):
        print "[D] " + target
      else:
        print "[X] " + target
  f.close()



def usage():
  print __doc__

if "__main__" == __name__:
  main(sys.argv[1:])

