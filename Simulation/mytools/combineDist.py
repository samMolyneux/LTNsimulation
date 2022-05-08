
import sys
import os
import time

SUMO_HOME = os.environ.get('SUMO_HOME',
                           os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
sys.path.append(os.path.join(SUMO_HOME, 'tools'))
import sumolib  # noqa
from sumolib.xml import parse  # noqa



def get_options(args=None):
    parser = sumolib.options.ArgumentParser(
        description="Get junction to junction trips from a route file produced by sampling")
    parser.add_argument("-d", "--distribution-only", dest="distributionFile",
                        help="Input sampled route file ")
    parser.add_argument("-r", "--route-to-map", dest="routeFile",
                        help="Input route file ")
    parser.add_argument("-o", "--output-file", dest="out", default="out.xml",
                        help="Output edgeData file")
    parser.add_argument("-p", "--prefix", dest ="prefix", default="merged")
    # parser.add_argument("-b", "--begin", default=0, help="begin time (default 0)")
    # parser.add_argument("-e", "--end", default=3600,
    #                        help="end time (default 3600)")

    options = parser.parse_args(args=args)
    if (options.distributionFile is None or options.routeFile is None):
        parser.print_help()
        sys.exit()
    return options


options = get_options()


    
with open(options.out, "w") as outf:
    sumolib.xml.writeHeader(outf)
    outf.write(
        '<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/routes_file.xsd">\n')
    
    outf.write('<routeDistribution id="mergedDistribution">\n')
    for route in sumolib.xml.parse(options.distributionFile, ['route']):
        outf.write('        <route id="%s" edges="%s" probability="%s"/>\n' %
            (options.prefix + route.id, route.edges, route.probability)) 
    for route in sumolib.xml.parse(options.routeFile, ['route']):
        outf.write('        <route id="%s" edges="%s" probability="%s"/>\n' %
            (route.id, route.edges, route.probability)) 
    
    outf.write('</routeDistribution>\n')
    for vehicle in sumolib.xml.parse(options.routeFile, ['vehicle']):
        outf.write(' <vehicle id="%s" depart="%s" route="mergedDistribution"/>\n' %
                   (vehicle.id, vehicle.depart))
    outf.write('</routes>')