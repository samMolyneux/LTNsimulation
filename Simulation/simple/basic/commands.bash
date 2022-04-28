python ../../tools/randomTrips.py -n basicGrid.net.xml --fringe-factor 5 --junction-taz -o simpleTrips.trips.xml

duarouter -n basicGrid.net.xml --junction-taz --r simpleTrips.trips.xml -o basicRoutes.rou.xml

#python ../../tools/randomTrips.py -n basicGrid.net.xml --fringe-factor 5 --junction-taz -r basicRoutes.rou.xml

sumo -c basic_config_18_04_2022.sumocfg

# <configuration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/sumoConfiguration.xsd">

#     <input>
#         <net-file value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\simple\basic\basicGrid.net.xml"/>
#         <route-files value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\simple\basic\basicRoutes.rou.xml"/>
#         <additional-files value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\simple\basic\edgeDataDef.xml" />
#     </input>

# </configuration>

python ../../mytools/scaleDemand.py --edgedata-file edgeData.xml --count-file countData.xml -o expandedCounts.xml

python ../../tools/routeSampler.py -r basicRoutes.rou.xml -d expandedCounts.xml -o sampledRoutes.rou.xml

sumo -c analysis_config.sumocfg

# <configuration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/sumoConfiguration.xsd">

#     <input>
#         <net-file value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\simple\basic\basicGrid.net.xml"/>
#         <route-files value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\simple\basic\sampledRoutes.rou.xml"/>
#         <additional-files value="C:\Users\sam\Documents\Work\Final%20Year\Dissertation\diss\Simulation\simple\basic\analysisDataDef.xml" />
#     </input>

# </configuration>

python ../../mytools/tripsFromRoutes.py  -i sampledRoutes.rou.xml -o ../ltn/ltnTrips.rou.xml

duarouter -n ../ltn/ltnGrid.net.xml --r ../ltn/ltnTrips.rou.xml -o ../ltn/ltnRoutes.rou.xml