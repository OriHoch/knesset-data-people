from datapackage_pipelines.wrapper import ingest, spew
from datapackage_pipelines.utilities.resources import PROP_STREAMING
from copy import deepcopy
import logging, datetime, csv


parameters, datapackage, resources = ingest()

errors = []
mk_attendance = []

committees = {}
for committee in next(resources):
    committees[committee["CommitteeID"]] = {"id": committee["CommitteeID"],
                                            "Name": committee["Name"],
                                            "KnessetNum": committee["KnessetNum"], }

for meeting in next(resources):
    committee_name = committees[meeting["CommitteeID"]]["Name"]
    meeting_aggs = {"knesset_num": meeting["KnessetNum"],
                    "committee_id": meeting["CommitteeID"],
                    "committee_name": committee_name,
                    "meeting_start_date": meeting["StartDate"],
                    "meeting_topics": ", ".join(meeting["topics"]) if meeting["topics"] else None, }
    for mk in meeting["attended_mk_individuals"]:
        mk_name = None
        for name_pair in ((mk["mk_individual_first_name"], mk["mk_individual_name"]),
                          (mk["FirstName"], mk["LastName"]),):
            if all(name_pair):
                mk_name = "{} {}".format(*name_pair)
                break
        if mk_name:
            try:
                mk_id = mk["mk_individual_id"]
                mk_aggs = deepcopy(meeting_aggs)
                mk_aggs.update(mk_name=mk_name, mk_id=mk_id)
                mk_faction_id = None
                mk_faction_name = None
                mk_membership_committee_names = set()
                for position in mk["positions"]:
                    mk_position_start_date = datetime.datetime.strptime(position["start_date"], "%Y-%m-%d %H:%M:%S")
                    if position.get("finish_date"):
                        mk_position_finish_date = datetime.datetime.strptime(position["finish_date"], "%Y-%m-%d %H:%M:%S")
                    else:
                        mk_position_finish_date = datetime.datetime.now()
                    assert meeting["StartDate"], "meeting must have a start date"
                    if not meeting["FinishDate"]:
                        meeting["FinishDate"] = datetime.datetime.now()
                    if meeting["StartDate"] >= mk_position_start_date and meeting["FinishDate"] <= mk_position_finish_date:
                        if position.get("FactionID") and position.get("FactionName"):
                            if mk_faction_id is None or mk_faction_id == position["FactionID"]:
                                mk_faction_id = position["FactionID"]
                                mk_faction_name = position["FactionName"]
                            else:
                                logging.warning("Invalid faction for knesset num {} mk id {} faction name {}".format(meeting["KnessetNum"],
                                                                                                                     mk_id,
                                                                                                                     position.get("FactionName")))
                        elif position.get("CommitteeID") and position.get("CommitteeName"):
                            mk_membership_committee_names.add(position["CommitteeName"])
                mk_aggs.update(mk_membership_committee_names=", ".join(mk_membership_committee_names),
                               mk_faction_id=mk_faction_id, mk_faction_name=mk_faction_name)
                mk_attendance.append(mk_aggs)
            except Exception:
                logging.exception("Failed to process mk name {}".format(mk_name))
                raise
        else:
            raise Exception("Failed to find mk name for mk id {}".format(mk["mk_individual_id"]))

meeting_aggs_fields = [{"name": "knesset_num", "type": "integer"},
                       {"name": "committee_id", "type": "integer"},
                       {"name": "committee_name", "type": "string"},
                       {"name": "meeting_start_date", "type": "datetime"},
                       {"name": "meeting_topics", "type": "string"}, ]

datapackage["resources"] = []

datapackage["resources"] += [{"name": "errors", "path": "errors.csv", PROP_STREAMING: True,
                              "schema": {"fields": [{"name": "error", "type": "string"}, ]}}]

datapackage["resources"] += [{PROP_STREAMING: True,
                              "name": "mk_attendance",
                              "path": "mk_attendance.csv",
                              "schema": {"fields": meeting_aggs_fields + [{"name": "mk_id", "type": "integer"},
                                                                          {"name": "mk_name", "type": "string"},
                                                                          {"name": "mk_membership_committee_names",
                                                                           "type": "string"},
                                                                          {"name": "mk_faction_id", "type": "integer"},
                                                                          {"name": "mk_faction_name", "type": "string"},
                                                                          ]}}]

spew(datapackage, [errors,
                   mk_attendance])
