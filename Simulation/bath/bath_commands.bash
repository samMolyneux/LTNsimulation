while getopts f:a: flag
do
    case "${flag}" in
        f) fringeFactor=${OPTARG};;
        a) age=${OPTARG};;
    esac
done


python ../tools/randomTrips.py -n bath.net.xml --fringe-factor "$fringeFactor" --junction-taz -o basicTrips.trips.xml

duarouter -n bath.net.xml --junction-taz --r basicTrips.trips.xml -o routes/basicRoutes.rou.xml

sumo -c basic_bath_config.sumocfg

# <configuration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/sumoConfiguration.xsd">

#     <input>
#         <net-file value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\bath\bath.net.xml"/>
#        <route-files value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\bath\routes\basicRoutes.rou.xml"/>
#        <additional-files value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\bath\edgeDataDef.xml" />
#     </input>

# </configuration>

python ../mytools/scaleDemand.py --edgedata-file data/edgeData.xml --count-file countData.xml -o expandedCounts.xml

python ../tools/routeSampler.py -r routes/basicRoutes.rou.xml -d expandedCounts.xml -o routes/sampledRoutes.rou.xml

# sumo -c an_basic_bath_config.sumocfg

# <configuration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/sumoConfiguration.xsd">

    # <input>
    #     <net-file value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\bath\bath.net.xml"/>
    #     <route-files value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\bath\routes\sampledRoutesBasic.rou.xml"/>
    #     <additional-files value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\bath\analysisDataDef.xml" />
    # </input>

# </configuration>

# python ../mytools/tripsFromRoutes.py  -i routes/sampledRoutes.rou.xml -r routes/basicRoutes.rou.xml -t simpleTrips.trips.xml -o ../ltn/ltnTrips.rou.xml

# duarouter -n ../ltn/ltnGrid.net.xml --r ../ltn/ltnTrips.rou.xml -o ../ltn/ltnRoutes.rou.xml --junction-taz