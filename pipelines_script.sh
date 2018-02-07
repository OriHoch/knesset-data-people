#!/usr/bin/env bash

RUN_PIPELINE_CMD="${RUN_PIPELINE_CMD:-dpp run}"

RES=0;

! $RUN_PIPELINE_CMD ./download/committees && RES=1;
! $RUN_PIPELINE_CMD ./download/members && RES=1;
! $RUN_PIPELINE_CMD ./join-committee-meetings && RES=1;
! $RUN_PIPELINE_CMD ./join-members && RES=1;
! $RUN_PIPELINE_CMD ./committee-meeting-attendees && RES=1;
! $RUN_PIPELINE_CMD ./join-committee-meeting-attendees-mks && RES=1;
! $RUN_PIPELINE_CMD ./committee-meeting-attendees-mks-stats && RES=1;

exit $RES
