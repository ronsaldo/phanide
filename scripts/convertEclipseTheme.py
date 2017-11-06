#!/usr/bin/python
from lxml import etree
import sys

f = open(sys.argv[1])

xml = etree.parse(f)
root = xml.getroot()
print '\t^ #('

for child in root:
    name = child.tag
    color = child.attrib['color']
    if color[0] == '#':
        color = '\'' + color[1:] + '\''
    print '\t\t\t(%s %s)' % (name, color)
print '\t)'

