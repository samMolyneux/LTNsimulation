python ../tools/visualization/plot_net_dump.py -n basicGrid.net.xml --measures entered,entered -i old_data/minimize_val_0.xml,old_data/minimize_val_0.xml

###
# shows change in traffic volume after implementation of ltn
python ../tools/output/netdumpdiff.py -2 basic/analysisData.xml -1 ltn/data/edgeData.xml -o out.xml
python ../tools/visualization/plot_net_dump.py -n basic/basicGrid.net.xml --measures entered -i out.xml --default-width 1
###