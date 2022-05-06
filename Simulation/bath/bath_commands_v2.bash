#generate basic trips
python ../tools/randomTrips.py -n bath.net.xml --fringe-factor 2 --junction-taz -o basicTrips.trips.xml

#route them
duarouter -n bath.net.xml --junction-taz --r basicTrips.trips.xml -o routes/basicRoutes.rou.xml

#generate route distribution covering available count data
python ../tools/routeSampler.py -r routes/basicRoutes.rou.xml -d countData.xml -o routes/countRoutes.rou.xml --weighted -u countDis

#run simulation with rough routes
sumo -c basic_bath_config.sumocfg

#generate route distribution for general demand
python ../tools/routeSampler.py -r routes/basicRoutes.rou.xml -d data/edgeData.xml -o routes/generalRoutes.rou.xml --weighted -u generalDis --prefix g

##now do the copy stuff, changing route prefixes

##where this runs the combines route distribution file
sumo -c an_basic_bath_config.sumocfg

##now scale up to to fit counts
python ../mytools/scaleDemand.py --edgedata-file data/analysisData.xml --count-file countData.xml -o expandedCounts.xml

#then sample to match scaled data (optimize)
python ../tools/routeSampler.py -r routes/basicRoutes.rou.xml -d expandedCounts.xml -o routes/sampledRoutes.rou.xml --weighted --optimize full

#now run sumo with sampled routes 
sumo -c sample_basic_bath_config.sumocfg

#generate trips for ltn
python ../mytools/tripsFromRoutes.py -t basicTrips.trips.xml -r routes/basicRoutes.rou.xml -i routes/sampledRoutes.rou.xml -o ltn/ltnTrips.trips.xml

#route them
#duarouter -n ltn/ltnGrid.net.xml --r ltn/ltnTrips.trips.xml -o ltn/ltnRoutes.rou.xml --junction-taz