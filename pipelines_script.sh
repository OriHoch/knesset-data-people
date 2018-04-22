#!/usr/bin/env bash


RUN_PIPELINE_CMD="${RUN_PIPELINE_CMD:-dpp run}"


RES=0;

! (
    $RUN_PIPELINE_CMD --concurrency ${DPP_CONCURRENCY:-4} ./download/% &&\
    $RUN_PIPELINE_CMD --concurrency ${DPP_CONCURRENCY:-4} ./join-committee-meetings,./join-members &&\
    $RUN_PIPELINE_CMD ./committee-meeting-attendees &&\
    $RUN_PIPELINE_CMD ./join-committee-meeting-attendees-mks &&\
    $RUN_PIPELINE_CMD ./committee-meeting-attendees-mks-stats
) && RES=1


exit $RES
