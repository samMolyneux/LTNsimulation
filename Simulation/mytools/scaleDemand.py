from operator import contains
import sys
import os

SUMO_HOME = os.environ.get('SUMO_HOME',
                           os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..'))
sys.path.append(os.path.join(SUMO_HOME, 'tools'))
import sumolib  # noqa
from sumolib.xml import parse  # noqa



def get_options(args=None):
    parser = sumolib.options.ArgumentParser(
        description="Scale edges to match counts")
    parser.add_argument("-i", "--edgedata-file", dest="edgeDataFile",
                        help="Input edgeData file ")
    parser.add_argument("-f", "--count-file", dest="countFile",
                        help="Input count file ")
    parser.add_argument("-o", "--output-file", dest="out", default="out.xml",
                        help="Output edgeData file")
    # parser.add_argument("-b", "--begin", default=0, help="begin time (default 0)")
    # parser.add_argument("-e", "--end", default=3600,
    #                        help="end time (default 3600)")
    parser.add_argument("-s", "--scale",
                           help="explicit scale factor")

    options = parser.parse_args(args=args)
    if ((options.countFile is None and options.scale is None) or options.edgeDataFile is None):
        parser.print_help()
        sys.exit()
    return options


options = get_options()

if(options.countFile):
    ratioSum = 0
    counts = 0
    countEdges = []
    for countEdge in sumolib.xml.parse(options.countFile, ['edge']):
        countEdges.append(countEdge)
        for edge in sumolib.xml.parse(options.edgeDataFile, ['edge']):
            if(countEdge.id == edge.id):
                print(countEdge.id)
                ratio = int(countEdge.entered)/int(edge.entered)
                ratioSum += ratio
                counts += 1
                print(ratio)
                print()

    scaleRatio = ratioSum/counts
else:
    scaleRatio = float(options.scale)

print("Scale ratio: ", scaleRatio)

with open(options.out, "w") as outf:
    sumolib.xml.writeHeader(outf)
    outf.write('<data>\n')
    outf.write('    <interval id="flowdata" begin="%s" end="%s">\n' % (options.begin, options.end))
    for edge in sumolib.xml.parse(options.edgeDataFile, ['edge']):
        isCountEdge = False
        if(options.countFile):
            for countEdge in countEdges:
                if countEdge.id == edge.id:
                    outf.write('        <edge id="%s" entered="%s"/>\n' %
                            (countEdge.id, countEdge.entered))
                    isCountEdge = True
                    break
        if not isCountEdge:
            edge.entered = int(edge.entered) * scaleRatio
            outf.write('        <edge id="%s" entered="%s"/>\n' %
            (edge.id, int(edge.entered)))
        
    outf.write('    </interval>\n')
    outf.write('</data>\n')
# now average ratios
# and multiply all values in input by average ratio
# then output a count file with edge id and entered value
# result cav be fed to route sampler
