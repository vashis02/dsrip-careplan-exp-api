%dw 2.0
output application/json  
---
if (payload.status == 204)
  payload
else
  {
    resourceType: "Bundle",
    "type": "searchset",
    meta: {
      lastUpdated: now()
    },
    entry: payload map (payload01, indexOfPayload01) -> {
      fullUrl: "https://apiconnect-dev.mountsinai.org/api/CarePlan/" ++ indexOfPayload01,
      resource: {
        resourceType: "CarePlan",
        category: "Health Maintenance",
        id: payload01."PATIENT_HM_BKEY",
        subject: {
          reference: "MEDICAL_RECORD_NUMBER/" ++ payload01."MEDICAL_RECORD_NUMBER"
        },
        identifier: [
          {
            assigner: {
              display: payload01."DATA_SOURCE_NAME"
            }
          }
        ],
        intent: "plan",
        title: payload01."HM_TOPIC_DESC",
        activity: [
          {
            detail: {
              scheduledPeriod: {
                end: 
                  if (not payload01."DUE_DT" == null)
                    payload01."DUE_DT" as Localdatetime {format: "yyyy-MM-dd'T'HH:mm:ss"} as String {format: "yyyy-MM-dd"}
                  else
                    null
              }
            }
          }
        ],
        status: 
          if (payload01.STATUS == "Completed" or payload01.STATUS == "Done" or payload01.STATUS == "Previously completed")
            "completed"
          else (if (payload01.STATUS == "Declined")
            "cancelled"
          else
            "unknown"),
        period: {
          end: 
            if (not payload01."COMPLETED_DT" == null)
              payload01."COMPLETED_DT" as Localdatetime {format: "yyyy-MM-dd'T'HH:mm:ss"} as String {format: "yyyy-MM-dd"}
            else
              null
        },
        note: [
          {
            text: payload01.COMMENTS
          }
        ]
      }
    }
  }