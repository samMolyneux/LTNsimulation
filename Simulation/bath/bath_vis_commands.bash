python ../tools/visualization/plot_net_dump.py -n bath.net.xml --measures entered -i ltn/data/ltnData.xml -w 1  --color-bar-label "Traffic Volume [no. cars]" --xlabel [m] --ylabel [m] --min-color-value 0 --max-color-value 800 --colormap "#0:#42f54e,0.25:#f5e642,0.5:#f5aa42,0.75:#f54242,1:#f0079e"
-o images/demandDis.png

###
# shows change in traffic volume for expermintal routes (called when in the ltn folder)
python ../../tools/output/edgeDataDiff.py data/ltnData.xml scalingExperiment/scaledOutputData.xml scalingExperiment/diff.xml
python ../../tools/visualization/plot_net_dump.py -n ltn_bath.net.xml --measures entered -i scalingExperiment/diff.xml --default-width 1 --color-bar-label "Traffic Volume [no. cars]" --xlabel [m] --ylabel [m] --colormap "#0:#e439ed,0.5:#395ded,1:#6ced39"
###
