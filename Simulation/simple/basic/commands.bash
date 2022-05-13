while getopts f: flag
do
    case "${flag}" in
        f) fringeFactor=${OPTARG};;
    esac
done

#generate origin destination trips
python ../../tools/randomTrips.py -n basicGrid.net.xml --fringe-factor "$fringeFactor" --junction-taz -o simpleTrips.trips.xml

#generate routes
duarouter -n basicGrid.net.xml --junction-taz --r simpleTrips.trips.xml -o basicRoutes.rou.xml

#simulate the routes to for baseline demand
sumo -c basic_config_18_04_2022.sumocfg

#scale demand to match count data
python ../../mytools/scaleDemand.py --edgedata-file edgeData.xml --count-file countData.xml -o expandedCounts.xml

#use scaled count data as input for route sampling
python ../../tools/routeSampler.py -r basicRoutes.rou.xml -d expandedCounts.xml -o sampledRoutes.rou.xml 

#run baseline demand simulation
sumo -c analysis_config.sumocfg

#generate trips with correct volume from the baseline demand 
python ../../mytools/tripsFromRoutes.py  -i sampledRoutes.rou.xml -r basicRoutes.rou.xml -t simpleTrips.trips.xml -o ../ltn/ltnTrips.rou.xml

#route the trips on the converted network
duarouter -n ../ltn/ltnGrid.net.xml --r ../ltn/ltnTrips.rou.xml -o ../ltn/ltnRoutes.rou.xml --junction-taz

#run the simulation of the converted network
sumo -c ../ltn/ltn_config.sumocfg