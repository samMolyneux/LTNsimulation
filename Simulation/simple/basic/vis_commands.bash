
python ../../tools/visualization/plot_net_dump.py -n basicGrid.net.xml --measures entered -i demand_testing/f1.dump.xml -w 1 --internal -o demand_testing/f1.png

##full basic with heatmap
python ../../tools/visualization/plot_net_dump.py -n basicGrid.net.xml --measures entered 
-i demand_testing/f10.dump.xml -w 1 -o demand_testing/f10.png --color-bar-label "Traffic Volume [no. cars]"  --xticks 0,900,100,12 
--yticks 0,900,100,12 --xlim 0,900 --ylim 0,900 --xlabel [m] --ylabel [m] 
--min-color-value 0 --max-color-value 400 --colormap "#0:#42f54e,0.25:#f5e642,0.75:#f5aa42,1:#f54242"

###
# shows change in traffic volume after implementation of ltn
python ../tools/output/netdumpdiff.py -2 basic/analysisData.xml -1 ltn/data/edgeData.xml -o out.xml
python ../tools/visualization/plot_net_dump.py -n basic/basicGrid.net.xml --measures entered -i out.xml --default-width 1
###