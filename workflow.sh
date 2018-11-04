#!/bin/bash


function update_status
{
   STATUS=`pegasus-status --noqueue | tail -1 | sed 's/[:\(\)]/ /g'| awk '{print $5}'`
   SUMMARY=`pegasus-status | grep "Condor jobs total" | sed 's/Summary: //'`
}


function show_state
{
    OUT="# STATUS is $STATUS"
    if [ "x$STATUS" = "xRunning" -a "x$SUMMARY" != "x" ]; then
        OUT="$OUT - $SUMMARY"
    fi

    if [ "x$OLD_OUT" = "x$OUT" ]; then
        return
    fi

    OLD_OUT="$OUT"
    echo "$OUT"
}


cd ~/montage/0.1deg

WF_USER=`whoami`
BASE_DIR=`pwd`

# Fix replica catalog
RC_IN=$BASE_DIR/replica.catalog.in
RC=$BASE_DIR/replica.catalog
cp $RC_IN $RC
sed -i "s/@@USER@@/$WF_USER/g" $RC

#Fix sites.xml
SITESXML=$BASE_DIR/sites.xml
SITESXML_IN=$BASE_DIR/sites.xml.in.xml
cp $SITESXML_IN $SITESXML
sed -i "s/@@USER@@/$WF_USER/g" $SITESXML



pegasus-plan --conf pegasus.conf --sites condor_pool --dax dax.xml | tee plan.out

#Get RUNDIR from the planning output
RUN_DIR=`grep pegasus-run plan.out | awk '{print $2}'`
if [ "x$RUN_DIR" = "x" ]; then
    echo "Unable to determine the RUN_DIR from the planner output - did the planner fail?" 1>&2
    exit 1
fi

cd $RUN_DIR
pegasus-run

STATUS=""
TIMEOUT=60
COUNT=0

sleep 30s
update_status
show_state

while [ "$STATUS" = "Running" -o "$STATUS" = "" -o "$STATUS" = "Unknown"  ] ; do
    if [ $COUNT -ge $TIMEOUT ]; then
        echo "Reached TIMEOUT of $TIMEOUT. Calling pegasus-remove"
        pegasus-remove `pwd`
        STATUS=TIMEOUT
        sleep 1m
        break;
    fi
    ((COUNT++))
    sleep 1m
    update_status
    show_state
done

if [ "$STATUS" = "Success" ]; then
    # give monitord some time to finish
    sleep 1m
    echo "*** Workflow finished succesfully ***"
    echo
    pegasus-statistics -s all
    exit 0
else
    echo "*** Workflow failed ***"
    echo
    pegasus-analyzer

    exit 1
fi
