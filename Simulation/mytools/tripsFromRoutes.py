
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
    parser.add_argument("-i", "--sampled-file", dest="sampledFile",
                        help="Input sampled route file ")
    parser.add_argument("-r", "--route-file", dest="routeFile",
                        help="Input route file ")
    parser.add_argument("-t", "--trips-file", dest="tripsFile",
                        help="Input trips file ")
    parser.add_argument("-o", "--output-file", dest="out", default="out.xml",
                        help="Output edgeData file")
    parser.add_argument("-b", "--begin", default=0, help="begin time (default 0)")
    parser.add_argument("-e", "--end", default=3600,
                           help="end time (default 3600)")

    options = parser.parse_args(args=args)
    if (options.sampledFile is None or options.tripsFile is None or options.routeFile is None):
        parser.print_help()
        sys.exit()
    return options


options = get_options()


#loop through all sample routes
#match to route from route file
#match route id to trip id
#oupute trip to and from to file
matchedTrip = None
start = time.time()
with open(options.out, "w") as outf:
    sumolib.xml.writeHeader(outf)
    outf.write('<routes>\n')
    vehicles = []
    routes = []
    trips = []
    for vehicle in sumolib.xml.parse(options.sampledFile, ['vehicle']):
        vehicles.append(vehicle)
    for template_veh in sumolib.xml.parse(options.routeFile, ['vehicle']):
        routes.append(template_veh)
    for trip in sumolib.xml.parse(options.tripsFile, ['trip']):
        trips.append(trip)
    for vehicle in vehicles:
        for template_veh in routes:
            if(str(vehicle.route[0]) == str(template_veh.route[0])):
                for trip in trips:
                    if(int(trip.id) == int(template_veh.id)):
                        matchedTrip = trip
        if matchedTrip is None:
            print(vehicle.route[0])
            print("incompatible trip or route file")
            sys.exit()
                
        
        edges = vehicle.route[0].edges.split(" ")
        outf.write('        <trip id="%s" depart="%s" fromJunction="%s" toJunction="%s"/>\n' %
                (vehicle.id, vehicle.depart, matchedTrip.fromJunction,matchedTrip.toJunction ))
    outf.write('</routes>\n')
end = time.time()
print(end - start)