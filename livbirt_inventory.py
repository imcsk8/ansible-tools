#!/bin/python

# Generates an ansible inventory for a given list of libvirt guests

import subprocess
import libvirt
import libxml2
import sys
import re


try:
    import json
except:
    import simplejson as json


# For now justrReturn just the first interface
def getHWAddr(dom):
    xml = libxml2.parseDoc(dom.XMLDesc(0))
    matches = xml.xpathEval("//devices/interface[@type='network']/mac/@address")
    try:
        return(re.search('address="(.+)"', str(matches[0])).group(1))
        #return(re.search('address="(.+)"', 'address="52:54:00:8f:5b:ea"').group(1))
    except AttributeError:
        return ""



# Look up the MAC addresses in the output of 'arp -an'.
def getIP(dom):
    hwaddr = getHWAddr(dom)
    cmd = "arp -an | grep %s" % hwaddr
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
    output, errors = p.communicate()
    ip = re.search("\((.*?)\) at (.*?)", output).group(1)
    return ip


def toText(hosts):
    for id in hosts:
        dom = conn.lookupByID(id)
        ip = getIP(dom)
        print "[%s]\n%s" % (dom.name(), ip)

def toJSON(hosts):
    vm = []
    group = {}
    for id in hosts:
        dom = conn.lookupByID(id)
        ip = getIP(dom)
        vm.append(ip)
    group["VM"] = { "hosts": vm }    
    #print json.dumps(groups, sort_keys=True, indent=2)
    print json.dumps(group, sort_keys=True, indent=2)


conn = libvirt.openReadOnly("qemu:///system")
if conn == None:
    print 'Failed to open connection to the hypervisor'
    sys.exit(1)


toJSON(conn.listDomainsID())




