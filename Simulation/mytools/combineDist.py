
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
    parser.add_argument("-1", "--distribution-route-1", dest="inFile1",
                        help="Input sampled route file ")
    parser.add_argument("-2", "--distribution-route-2", dest="inFile2",
                        help="Input route file ")
    parser.add_argument("-o", "--output-file", dest="out", default="out.xml",
                        help="Output edgeData file")
    # parser.add_argument("-b", "--begin", default=0, help="begin time (default 0)")
    # parser.add_argument("-e", "--end", default=3600,
    #                        help="end time (default 3600)")

    options = parser.parse_args(args=args)
    if (options.inFile2 is None or options.inFile1 is None):
        parser.print_help()
        sys.exit()
    return options


options = get_options()
